-- Projects: a job site belonging to one client. Archive only; never delete.
--
-- Error tokens (SQLSTATE class Q0):
--   Q0040 client_not_found
--   Q0070 project_not_found
--   Q0071 project_already_archived
--   Q0072 project_not_archived

-- ---------------------------------------------------------------------------
-- projects
-- ---------------------------------------------------------------------------

create table public.projects (
  id uuid primary key default gen_random_uuid(),
  business_id uuid not null default public.current_business_id()
    references public.businesses (id),
  client_id uuid not null references public.clients (id),
  title text not null,
  site_street text not null,
  site_city text not null,
  site_state text not null,
  site_zip text not null,
  archived_at timestamptz,
  archived_by uuid references public.users (id),
  created_by uuid not null default auth.uid()
    references public.users (id),
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now(),
  constraint projects_title_length
    check (length(trim(title)) between 1 and 120),
  constraint projects_site_street_length
    check (length(trim(site_street)) >= 1),
  constraint projects_site_city_length
    check (length(trim(site_city)) >= 1),
  constraint projects_site_state_format
    check (site_state ~ '^[A-Z]{2}$'),
  constraint projects_site_zip_format
    check (site_zip ~ '^\d{5}(-\d{4})?$'),
  constraint projects_archived_pair
    check ((archived_at is null) = (archived_by is null))
);

create trigger projects_set_updated_at
  before update on public.projects
  for each row execute function public.set_updated_at();

create index projects_active_idx
  on public.projects (business_id, created_at desc)
  where archived_at is null;

create index projects_archived_idx
  on public.projects (business_id, archived_at desc)
  where archived_at is not null;

create index projects_client_id_idx
  on public.projects (client_id);

create index projects_created_by_idx
  on public.projects (created_by);

create index projects_archived_by_idx
  on public.projects (archived_by);

-- ---------------------------------------------------------------------------
-- Grants: authenticated can select only. Create / archive go through RPCs.
-- ---------------------------------------------------------------------------

revoke all on table public.projects from anon, authenticated, public;

grant select on table public.projects to authenticated;

revoke delete on table public.projects from authenticated;

-- ---------------------------------------------------------------------------
-- RLS
-- ---------------------------------------------------------------------------

alter table public.projects enable row level security;

create policy projects_select on public.projects
  for select to authenticated
  using (business_id = (select public.current_business_id()));

-- ---------------------------------------------------------------------------
-- create_project
-- ---------------------------------------------------------------------------

create function public.create_project(
  p_client_id uuid,
  p_title text,
  p_site_street text,
  p_site_city text,
  p_site_state text,
  p_site_zip text
)
returns uuid
language plpgsql
security definer
set search_path = public
as $$
declare
  v_id uuid;
begin
  if not exists (
    select 1
    from public.clients
    where id = p_client_id
      and business_id = public.current_business_id()
      and deleted_at is null
  ) then
    raise exception 'client_not_found' using errcode = 'Q0040';
  end if;

  insert into public.projects (
    client_id, title, site_street, site_city, site_state, site_zip
  ) values (
    p_client_id,
    trim(p_title),
    trim(p_site_street),
    trim(p_site_city),
    upper(trim(p_site_state)),
    trim(p_site_zip)
  )
  returning id into v_id;

  return v_id;
end;
$$;

-- ---------------------------------------------------------------------------
-- archive_project
-- ---------------------------------------------------------------------------

create function public.archive_project(p_project_id uuid)
returns void
language plpgsql
security definer
set search_path = public
as $$
declare
  v_archived_at timestamptz;
begin
  select archived_at into v_archived_at
  from public.projects
  where id = p_project_id
    and business_id = public.current_business_id();

  if not found then
    raise exception 'project_not_found' using errcode = 'Q0070';
  end if;

  if v_archived_at is not null then
    raise exception 'project_already_archived' using errcode = 'Q0071';
  end if;

  update public.projects
  set
    archived_at = now(),
    archived_by = auth.uid()
  where id = p_project_id
    and business_id = public.current_business_id();
end;
$$;

-- ---------------------------------------------------------------------------
-- unarchive_project
-- ---------------------------------------------------------------------------

create function public.unarchive_project(p_project_id uuid)
returns void
language plpgsql
security definer
set search_path = public
as $$
declare
  v_archived_at timestamptz;
begin
  select archived_at into v_archived_at
  from public.projects
  where id = p_project_id
    and business_id = public.current_business_id();

  if not found then
    raise exception 'project_not_found' using errcode = 'Q0070';
  end if;

  if v_archived_at is null then
    raise exception 'project_not_archived' using errcode = 'Q0072';
  end if;

  update public.projects
  set
    archived_at = null,
    archived_by = null
  where id = p_project_id
    and business_id = public.current_business_id();
end;
$$;

-- ---------------------------------------------------------------------------
-- project_rows: projects plus the client and the client's active appointment
-- ---------------------------------------------------------------------------

create view public.project_rows
with (security_invoker = true)
as
select
  p.id,
  p.title,
  p.created_at,
  p.archived_at,
  p.site_street,
  p.site_city,
  p.site_state,
  p.site_zip,
  c.id                     as client_id,
  c.full_name              as client_name,
  c.phone                  as client_phone,
  c.deleted_at is not null as client_removed,
  a.starts_at              as appointment_starts_at,
  a.duration_minutes       as appointment_duration_minutes
from public.projects p
join public.clients c on c.id = p.client_id
left join public.appointments a
  on a.client_id = c.id and a.deleted_at is null;

revoke all on table public.project_rows from anon, authenticated, public;
grant select on table public.project_rows to authenticated;

-- ---------------------------------------------------------------------------
-- Function grants
-- ---------------------------------------------------------------------------

revoke all on function public.create_project(uuid, text, text, text, text, text)
  from public, anon;
revoke all on function public.archive_project(uuid)
  from public, anon;
revoke all on function public.unarchive_project(uuid)
  from public, anon;

grant execute on function public.create_project(uuid, text, text, text, text, text)
  to authenticated;
grant execute on function public.archive_project(uuid)
  to authenticated;
grant execute on function public.unarchive_project(uuid)
  to authenticated;
