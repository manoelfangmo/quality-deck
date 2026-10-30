-- Job photos: before / concept / after galleries on each job.
--
-- Error tokens (SQLSTATE class Q0):
--   Q0074 job_not_found (reused)
--   Q0080 photo_limit_reached
--   Q0081 photo_not_found

-- ---------------------------------------------------------------------------
-- kind
-- ---------------------------------------------------------------------------

create type public.job_photo_kind as enum ('before', 'after', 'concept');

-- ---------------------------------------------------------------------------
-- job_photos
-- ---------------------------------------------------------------------------

create table public.job_photos (
  id uuid primary key default gen_random_uuid(),
  business_id uuid not null default public.current_business_id()
    references public.businesses (id),
  job_id uuid not null references public.jobs (id) on delete cascade,
  kind public.job_photo_kind not null,
  storage_path text not null unique,
  width int not null,
  height int not null,
  created_by uuid not null default auth.uid()
    references public.users (id),
  created_at timestamptz not null default now(),
  constraint job_photos_width_positive check (width > 0),
  constraint job_photos_height_positive check (height > 0)
);

create index job_photos_job_id_kind_created_at_idx
  on public.job_photos (job_id, kind, created_at, id);

create index job_photos_created_by_idx
  on public.job_photos (created_by);

-- ---------------------------------------------------------------------------
-- 10-photo limit (per job + kind). Advisory lock covers two devices at once.
-- ---------------------------------------------------------------------------

create function public.job_photos_enforce_limit()
returns trigger
language plpgsql
set search_path = public
as $$
begin
  perform pg_advisory_xact_lock(
    hashtext(new.job_id::text),
    hashtext(new.kind::text)
  );

  if (
    select count(*)
    from public.job_photos
    where job_id = new.job_id
      and kind = new.kind
  ) >= 10 then
    raise exception 'photo_limit_reached' using errcode = 'Q0080';
  end if;

  return new;
end;
$$;

create trigger job_photos_enforce_limit
  before insert on public.job_photos
  for each row execute function public.job_photos_enforce_limit();

-- ---------------------------------------------------------------------------
-- Leftover storage objects when a file delete fails after the row is gone.
-- ---------------------------------------------------------------------------

create table public.storage_orphans (
  id uuid primary key default gen_random_uuid(),
  business_id uuid not null default public.current_business_id()
    references public.businesses (id),
  bucket text not null,
  storage_path text not null,
  created_at timestamptz not null default now()
);

create index storage_orphans_created_at_idx
  on public.storage_orphans (created_at);

-- ---------------------------------------------------------------------------
-- Grants
-- ---------------------------------------------------------------------------

revoke all on table public.job_photos from anon, authenticated, public;
revoke all on table public.storage_orphans from anon, authenticated, public;

grant select on table public.job_photos to authenticated;
grant insert (
  id, business_id, job_id, kind, storage_path, width, height,
  created_by, created_at
) on table public.job_photos to authenticated;
grant delete on table public.job_photos to authenticated;

grant select on table public.storage_orphans to authenticated;
grant insert (
  business_id, bucket, storage_path
) on table public.storage_orphans to authenticated;

-- ---------------------------------------------------------------------------
-- RLS
-- ---------------------------------------------------------------------------

alter table public.job_photos enable row level security;
alter table public.storage_orphans enable row level security;

create policy job_photos_select on public.job_photos
  for select to authenticated
  using (business_id = (select public.current_business_id()));

create policy job_photos_insert on public.job_photos
  for insert to authenticated
  with check (
    business_id = (select public.current_business_id())
    and exists (
      select 1
      from public.jobs j
      where j.id = job_id
        and j.business_id = (select public.current_business_id())
        and public.project_is_writable(j.project_id)
    )
  );

create policy job_photos_delete on public.job_photos
  for delete to authenticated
  using (
    business_id = (select public.current_business_id())
    and exists (
      select 1
      from public.jobs j
      where j.id = job_id
        and public.project_is_writable(j.project_id)
    )
  );

create policy storage_orphans_select on public.storage_orphans
  for select to authenticated
  using (business_id = (select public.current_business_id()));

create policy storage_orphans_insert on public.storage_orphans
  for insert to authenticated
  with check (business_id = (select public.current_business_id()));

-- ---------------------------------------------------------------------------
-- Private storage bucket
-- ---------------------------------------------------------------------------

insert into storage.buckets (id, name, public, file_size_limit, allowed_mime_types)
values (
  'job-photos',
  'job-photos',
  false,
  20971520,
  array['image/jpeg']
);

create policy job_photos_storage_select on storage.objects
  for select to authenticated
  using (
    bucket_id = 'job-photos'
    and (storage.foldername(name))[1] = (select public.current_business_id()::text)
  );

create policy job_photos_storage_insert on storage.objects
  for insert to authenticated
  with check (
    bucket_id = 'job-photos'
    and (storage.foldername(name))[1] = (select public.current_business_id()::text)
  );

create policy job_photos_storage_delete on storage.objects
  for delete to authenticated
  using (
    bucket_id = 'job-photos'
    and (storage.foldername(name))[1] = (select public.current_business_id()::text)
  );

-- ---------------------------------------------------------------------------
-- When a photo row is deleted (including job cascade), remove the file.
-- Failures are recorded for a later cleanup job and never block the row delete.
-- ---------------------------------------------------------------------------

create function public.job_photos_delete_object()
returns trigger
language plpgsql
security definer
set search_path = public, storage
as $$
begin
  -- storage.protect_delete rejects SQL deletes unless this GUC is set.
  perform set_config('storage.allow_delete_query', 'true', true);
  delete from storage.objects
  where bucket_id = 'job-photos'
    and name = old.storage_path;
  return old;
exception
  when others then
    insert into public.storage_orphans (business_id, bucket, storage_path)
    values (old.business_id, 'job-photos', old.storage_path);
    return old;
end;
$$;

create trigger job_photos_delete_object
  after delete on public.job_photos
  for each row execute function public.job_photos_delete_object();
