-- Appointments: one active appointment per client. Soft-delete only.
--
-- Error tokens (SQLSTATE class Q0):
--   Q0040 client_not_found
--   Q0050 invalid_duration
--   Q0051 appointment_not_found
--   Q0053 client_has_appointment

-- ---------------------------------------------------------------------------
-- appointments
-- ---------------------------------------------------------------------------

create table public.appointments (
  id uuid primary key default gen_random_uuid(),
  business_id uuid not null default public.current_business_id()
    references public.businesses (id),
  client_id uuid not null references public.clients (id),
  starts_at timestamptz not null,
  duration_minutes int not null,
  notes text,
  created_by uuid not null default auth.uid()
    references public.users (id),
  deleted_at timestamptz,
  deleted_by uuid references public.users (id),
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now(),
  constraint appointments_duration_minutes
    check (duration_minutes between 15 and 600),
  constraint appointments_notes_length
    check (notes is null or length(notes) <= 2000),
  constraint appointments_deleted_pair
    check ((deleted_at is null) = (deleted_by is null))
);

create trigger appointments_set_updated_at
  before update on public.appointments
  for each row execute function public.set_updated_at();

create unique index appointments_one_active_per_client
  on public.appointments (client_id)
  where deleted_at is null;

create index appointments_business_id_idx
  on public.appointments (business_id);

create index appointments_created_by_idx
  on public.appointments (created_by);

create index appointments_deleted_by_idx
  on public.appointments (deleted_by);

-- ---------------------------------------------------------------------------
-- Grants: authenticated can select only. Every write goes through RPCs.
-- ---------------------------------------------------------------------------

revoke all on table public.appointments from anon, authenticated, public;

grant select on table public.appointments to authenticated;

-- ---------------------------------------------------------------------------
-- RLS
-- ---------------------------------------------------------------------------

alter table public.appointments enable row level security;

create policy appointments_select on public.appointments
  for select to authenticated
  using (business_id = (select public.current_business_id()));

-- ---------------------------------------------------------------------------
-- add_appointment
-- ---------------------------------------------------------------------------

create function public.add_appointment(
  p_client_id uuid,
  p_starts_at timestamptz,
  p_duration_minutes int,
  p_notes text
)
returns uuid
language plpgsql
security definer
set search_path = public
as $$
declare
  v_id uuid;
  v_notes text;
begin
  if p_duration_minutes is null
     or p_duration_minutes < 15
     or p_duration_minutes > 600 then
    raise exception 'invalid_duration' using errcode = 'Q0050';
  end if;

  if not exists (
    select 1
    from public.clients
    where id = p_client_id
      and business_id = public.current_business_id()
      and deleted_at is null
  ) then
    raise exception 'client_not_found' using errcode = 'Q0040';
  end if;

  v_notes := nullif(trim(p_notes), '');

  begin
    insert into public.appointments (
      client_id, starts_at, duration_minutes, notes
    ) values (
      p_client_id, p_starts_at, p_duration_minutes, v_notes
    )
    returning id into v_id;
  exception
    when unique_violation then
      raise exception 'client_has_appointment' using errcode = 'Q0053';
  end;

  return v_id;
end;
$$;

-- ---------------------------------------------------------------------------
-- update_appointment
-- ---------------------------------------------------------------------------

create function public.update_appointment(
  p_id uuid,
  p_starts_at timestamptz,
  p_duration_minutes int,
  p_notes text
)
returns void
language plpgsql
security definer
set search_path = public
as $$
declare
  v_notes text;
begin
  if p_duration_minutes is null
     or p_duration_minutes < 15
     or p_duration_minutes > 600 then
    raise exception 'invalid_duration' using errcode = 'Q0050';
  end if;

  v_notes := nullif(trim(p_notes), '');

  update public.appointments a
  set
    starts_at = p_starts_at,
    duration_minutes = p_duration_minutes,
    notes = v_notes
  from public.clients c
  where a.id = p_id
    and a.business_id = public.current_business_id()
    and a.deleted_at is null
    and c.id = a.client_id
    and c.deleted_at is null;

  if not found then
    raise exception 'appointment_not_found' using errcode = 'Q0051';
  end if;
end;
$$;

-- ---------------------------------------------------------------------------
-- remove_appointment
-- ---------------------------------------------------------------------------

create function public.remove_appointment(p_id uuid)
returns void
language plpgsql
security definer
set search_path = public
as $$
begin
  update public.appointments
  set
    deleted_at = now(),
    deleted_by = auth.uid()
  where id = p_id
    and business_id = public.current_business_id()
    and deleted_at is null;

  if not found then
    raise exception 'appointment_not_found' using errcode = 'Q0051';
  end if;
end;
$$;

-- ---------------------------------------------------------------------------
-- remove_client also removes the client's active appointment
-- ---------------------------------------------------------------------------

create or replace function public.remove_client(p_client_id uuid)
returns void
language plpgsql
security definer
set search_path = public
as $$
begin
  update public.clients
  set
    deleted_at = now(),
    deleted_by = auth.uid()
  where id = p_client_id
    and business_id = public.current_business_id()
    and deleted_at is null;

  if not found then
    raise exception 'client_not_found' using errcode = 'Q0040';
  end if;

  update public.appointments
  set
    deleted_at = now(),
    deleted_by = auth.uid()
  where client_id = p_client_id
    and business_id = public.current_business_id()
    and deleted_at is null;
end;
$$;

-- ---------------------------------------------------------------------------
-- client_rows: active clients plus their one active appointment
-- ---------------------------------------------------------------------------

create view public.client_rows
with (security_invoker = true)
as
select
  c.*,
  a.id               as appointment_id,
  a.starts_at        as appointment_starts_at,
  a.duration_minutes as appointment_duration_minutes
from public.clients c
left join public.appointments a
  on a.client_id = c.id and a.deleted_at is null
where c.deleted_at is null;

revoke all on table public.client_rows from anon, authenticated, public;
grant select on table public.client_rows to authenticated;

-- ---------------------------------------------------------------------------
-- Function grants
-- ---------------------------------------------------------------------------

revoke all on function public.add_appointment(uuid, timestamptz, int, text)
  from public, anon;
revoke all on function public.update_appointment(uuid, timestamptz, int, text)
  from public, anon;
revoke all on function public.remove_appointment(uuid)
  from public, anon;

grant execute on function public.add_appointment(uuid, timestamptz, int, text)
  to authenticated;
grant execute on function public.update_appointment(uuid, timestamptz, int, text)
  to authenticated;
grant execute on function public.remove_appointment(uuid)
  to authenticated;
