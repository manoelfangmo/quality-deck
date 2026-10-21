-- Clients: contact records for a business. Soft-delete only.
--
-- Error tokens (SQLSTATE class Q0):
--   Q0040 client_not_found

-- ---------------------------------------------------------------------------
-- clients
-- ---------------------------------------------------------------------------

create table public.clients (
  id uuid primary key default gen_random_uuid(),
  business_id uuid not null default public.current_business_id()
    references public.businesses (id),
  full_name text not null,
  email text,
  phone text,
  street text,
  city text,
  state text,
  zip text,
  last_activity_at timestamptz not null default now(),
  created_by uuid not null default auth.uid()
    references public.users (id),
  deleted_at timestamptz,
  deleted_by uuid references public.users (id),
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now(),
  constraint clients_full_name_length
    check (length(trim(full_name)) between 1 and 120),
  constraint clients_email_or_phone
    check (email is not null or phone is not null),
  constraint clients_address_all_or_nothing
    check (
      (street is null and city is null and state is null and zip is null)
      or (street is not null and city is not null and state is not null and zip is not null)
    ),
  constraint clients_state_format
    check (state is null or state ~ '^[A-Z]{2}$'),
  constraint clients_zip_format
    check (zip is null or zip ~ '^\d{5}(-\d{4})?$'),
  constraint clients_deleted_pair
    check ((deleted_at is null) = (deleted_by is null))
);

create trigger clients_set_updated_at
  before update on public.clients
  for each row execute function public.set_updated_at();

create index clients_business_id_idx
  on public.clients (business_id);

create index clients_business_id_last_activity_at_idx
  on public.clients (business_id, last_activity_at desc)
  where deleted_at is null;

create index clients_created_by_idx
  on public.clients (created_by);

create index clients_deleted_by_idx
  on public.clients (deleted_by);

-- ---------------------------------------------------------------------------
-- Grants: authenticated only. Revoke everything from anon.
-- deleted_at / deleted_by are not updatable; remove_client sets them.
-- ---------------------------------------------------------------------------

revoke all on table public.clients from anon, authenticated, public;

grant select on table public.clients to authenticated;
grant insert (
  id, business_id, full_name, email, phone, street, city, state, zip,
  last_activity_at, created_by, created_at, updated_at
) on table public.clients to authenticated;
grant update (
  full_name, email, phone, street, city, state, zip
) on table public.clients to authenticated;

-- ---------------------------------------------------------------------------
-- RLS
-- ---------------------------------------------------------------------------

alter table public.clients enable row level security;

create policy clients_select on public.clients
  for select to authenticated
  using (business_id = (select public.current_business_id()));

create policy clients_insert on public.clients
  for insert to authenticated
  with check (business_id = (select public.current_business_id()));

create policy clients_update on public.clients
  for update to authenticated
  using (
    business_id = (select public.current_business_id())
    and deleted_at is null
  );

-- ---------------------------------------------------------------------------
-- remove_client
-- ---------------------------------------------------------------------------

create function public.remove_client(p_client_id uuid)
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
end;
$$;

revoke all on function public.remove_client(uuid) from public, anon;
grant execute on function public.remove_client(uuid) to authenticated;
