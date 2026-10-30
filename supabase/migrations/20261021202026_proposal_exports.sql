-- Proposal PDF exports: business letterhead fields, job exclusions/timeframe,
-- per-business proposal numbers, versioned storage, and access rules.
--
-- Error tokens (SQLSTATE class Q0):
--   Q0070 project_not_found (reused)

-- ---------------------------------------------------------------------------
-- businesses: letterhead, terms, and proposal numbering
-- ---------------------------------------------------------------------------

alter table public.businesses
  add column street text,
  add column city text,
  add column state text,
  add column zip text,
  add column phone text,
  add column email text,
  add column website text,
  add column license_number text,
  add column tagline text,
  add column terms text,
  add column logo_path text,
  add column proposal_prefix text not null default 'QD',
  add column proposal_seq int not null default 0,
  add constraint businesses_address_all_or_nothing
    check (
      (street is null and city is null and state is null and zip is null)
      or (street is not null and city is not null and state is not null and zip is not null)
    ),
  add constraint businesses_state_format
    check (state is null or state ~ '^[A-Z]{2}$'),
  add constraint businesses_zip_format
    check (zip is null or zip ~ '^\d{5}(-\d{4})?$'),
  add constraint businesses_proposal_prefix_format
    check (proposal_prefix ~ '^[A-Z]{2,4}$'),
  add constraint businesses_proposal_seq_nonnegative
    check (proposal_seq >= 0),
  add constraint businesses_license_number_length
    check (license_number is null or length(trim(license_number)) between 1 and 80),
  add constraint businesses_tagline_length
    check (tagline is null or length(trim(tagline)) between 1 and 120),
  add constraint businesses_terms_length
    check (terms is null or length(terms) <= 8000);

grant update (
  street, city, state, zip, phone, email, website,
  license_number, tagline, terms, logo_path, proposal_prefix
) on table public.businesses to authenticated;

-- ---------------------------------------------------------------------------
-- projects: proposal number assigned on first export, reused on later versions
-- ---------------------------------------------------------------------------

alter table public.projects
  add column proposal_number text;

create unique index projects_business_id_proposal_number_key
  on public.projects (business_id, proposal_number)
  where proposal_number is not null;

-- ---------------------------------------------------------------------------
-- jobs: optional copy that appears on the PDF when set
-- ---------------------------------------------------------------------------

alter table public.jobs
  add column exclusions text,
  add column timeframe text,
  add constraint jobs_exclusions_length
    check (exclusions is null or length(exclusions) <= 2000),
  add constraint jobs_timeframe_length
    check (timeframe is null or length(timeframe) <= 80);

create or replace function public.jobs_normalize()
returns trigger
language plpgsql
set search_path = public
as $$
begin
  new.title := trim(new.title);
  if new.description is not null then
    new.description := nullif(trim(new.description), '');
  end if;
  if new.exclusions is not null then
    new.exclusions := nullif(trim(new.exclusions), '');
  end if;
  if new.timeframe is not null then
    new.timeframe := nullif(trim(new.timeframe), '');
  end if;
  return new;
end;
$$;

grant update (exclusions, timeframe) on table public.jobs to authenticated;

-- ---------------------------------------------------------------------------
-- proposal_exports
-- ---------------------------------------------------------------------------

create table public.proposal_exports (
  id uuid primary key default gen_random_uuid(),
  business_id uuid not null default public.current_business_id()
    references public.businesses (id),
  project_id uuid not null references public.projects (id),
  version int not null,
  proposal_number text not null,
  storage_path text not null unique,
  total_cents bigint not null,
  page_count int,
  created_by uuid not null references public.users (id),
  created_at timestamptz not null default now(),
  constraint proposal_exports_version_positive check (version >= 1),
  constraint proposal_exports_total_cents_nonnegative check (total_cents >= 0),
  constraint proposal_exports_page_count_positive
    check (page_count is null or page_count >= 1),
  constraint proposal_exports_project_id_version_key unique (project_id, version)
);

create index proposal_exports_project_id_created_at_idx
  on public.proposal_exports (project_id, created_at desc, version desc);

create index proposal_exports_business_id_idx
  on public.proposal_exports (business_id);

create index proposal_exports_created_by_idx
  on public.proposal_exports (created_by);

revoke all on table public.proposal_exports from anon, authenticated, public;
grant select on table public.proposal_exports to authenticated;

alter table public.proposal_exports enable row level security;

create policy proposal_exports_select on public.proposal_exports
  for select to authenticated
  using (business_id = (select public.current_business_id()));

-- ---------------------------------------------------------------------------
-- next_proposal_export: one call assigns the proposal number and next version.
-- Locks the project and business rows so two exports cannot collide.
-- Not granted to authenticated; the Edge Function calls it with the service role
-- after confirming the caller can see the project.
-- ---------------------------------------------------------------------------

create function public.next_proposal_export(p_project_id uuid)
returns table (
  business_id uuid,
  proposal_number text,
  version int
)
language plpgsql
security definer
set search_path = public
as $$
declare
  v_business_id uuid;
  v_proposal_number text;
  v_version int;
  v_year int;
  v_seq int;
  v_prefix text;
  v_timezone text;
begin
  select p.business_id, p.proposal_number
  into v_business_id, v_proposal_number
  from public.projects p
  where p.id = p_project_id
  for update;

  if not found then
    raise exception 'project_not_found' using errcode = 'Q0070';
  end if;

  select b.proposal_prefix, b.timezone
  into v_prefix, v_timezone
  from public.businesses b
  where b.id = v_business_id
  for update;

  if v_proposal_number is null then
    update public.businesses
    set proposal_seq = proposal_seq + 1
    where id = v_business_id
    returning proposal_seq into v_seq;

    v_year := extract(year from timezone(v_timezone, now()))::int;
    v_proposal_number := v_prefix || '-' || v_year::text || '-' ||
      lpad(v_seq::text, 4, '0');

    update public.projects
    set proposal_number = v_proposal_number
    where id = p_project_id;
  end if;

  select coalesce(max(pe.version), 0) + 1
  into v_version
  from public.proposal_exports pe
  where pe.project_id = p_project_id;

  return query
  select v_business_id, v_proposal_number, v_version;
end;
$$;

revoke all on function public.next_proposal_export(uuid)
  from public, anon, authenticated;
grant execute on function public.next_proposal_export(uuid) to service_role;

-- New businesses get a prefix from the name's initials (Quality Deck → QD).
create or replace function public.create_business(p_name text)
returns uuid
language plpgsql
security definer
set search_path = public
as $$
declare
  v_name text;
  v_id uuid;
  v_prefix text;
begin
  perform 1 from public.users where id = auth.uid() for update;

  if exists (select 1 from public.memberships where user_id = auth.uid()) then
    raise exception 'already_in_business' using errcode = 'Q0001';
  end if;

  v_name := trim(p_name);
  if v_name is null or length(v_name) not between 1 and 80 then
    raise exception 'invalid_business_name' using errcode = 'Q0002';
  end if;

  select upper(regexp_replace(coalesce(string_agg(left(word, 1), ''), 'QD'), '[^A-Z]', '', 'g'))
  into v_prefix
  from unnest(regexp_split_to_array(v_name, '\s+')) as word
  where word <> '';

  if v_prefix is null or length(v_prefix) < 2 then
    v_prefix := rpad(coalesce(v_prefix, 'Q'), 2, 'D');
  elsif length(v_prefix) > 4 then
    v_prefix := left(v_prefix, 4);
  end if;

  insert into public.businesses (name, owner_id, proposal_prefix)
  values (v_name, auth.uid(), v_prefix)
  returning id into v_id;

  insert into public.memberships (user_id, business_id, role)
  values (auth.uid(), v_id, 'owner');

  insert into public.pricing_settings (business_id)
  values (v_id);

  return v_id;
end;
$$;

-- ---------------------------------------------------------------------------
-- Private storage bucket. Members can read files under their business folder.
-- Uploads go through the Edge Function (service role) with upsert: false.
-- ---------------------------------------------------------------------------

insert into storage.buckets (id, name, public, file_size_limit, allowed_mime_types)
values (
  'proposal-pdfs',
  'proposal-pdfs',
  false,
  20971520,
  array['application/pdf']
);

insert into storage.buckets (id, name, public, file_size_limit, allowed_mime_types)
values (
  'business-assets',
  'business-assets',
  false,
  5242880,
  array['image/jpeg', 'image/png', 'image/svg+xml', 'font/woff2']
);

create policy proposal_pdfs_storage_select on storage.objects
  for select to authenticated
  using (
    bucket_id = 'proposal-pdfs'
    and (storage.foldername(name))[1] = (select public.current_business_id()::text)
  );

create policy business_assets_storage_select on storage.objects
  for select to authenticated
  using (
    bucket_id = 'business-assets'
    and (storage.foldername(name))[1] = (select public.current_business_id()::text)
  );

create policy business_assets_storage_insert on storage.objects
  for insert to authenticated
  with check (
    bucket_id = 'business-assets'
    and (storage.foldername(name))[1] = (select public.current_business_id()::text)
  );

create policy business_assets_storage_update on storage.objects
  for update to authenticated
  using (
    bucket_id = 'business-assets'
    and (storage.foldername(name))[1] = (select public.current_business_id()::text)
  )
  with check (
    bucket_id = 'business-assets'
    and (storage.foldername(name))[1] = (select public.current_business_id()::text)
  );
