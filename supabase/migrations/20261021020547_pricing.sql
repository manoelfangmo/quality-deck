-- Pricing: one settings row per business, and the price list.
--
-- Estimates will copy name, description, pricing_type and price onto each
-- line when an item is added. When that ticket creates line_items, its
-- price_item_id foreign key must be ON DELETE SET NULL so deleting a price
-- item leaves existing estimates untouched.

-- ---------------------------------------------------------------------------
-- Types and shared trigger
-- ---------------------------------------------------------------------------

create type public.pricing_type as enum (
  'fixed',
  'per_unit',
  'per_sq_ft',
  'per_linear_ft',
  'per_step'
);

create function public.set_updated_by()
returns trigger
language plpgsql
set search_path = public
as $$
begin
  new.updated_by = auth.uid();
  return new;
end;
$$;

revoke all on function public.set_updated_by() from public, anon, authenticated;

-- ---------------------------------------------------------------------------
-- pricing_settings (one row per business)
-- ---------------------------------------------------------------------------

create table public.pricing_settings (
  business_id uuid primary key
    references public.businesses (id) on delete cascade,
  labor_rate_cents bigint
    constraint pricing_settings_labor_rate_cents_range
      check (labor_rate_cents between 0 and 100000),
  overhead_bps int
    constraint pricing_settings_overhead_bps_range
      check (overhead_bps between 0 and 10000),
  updated_by uuid references public.users (id),
  updated_at timestamptz not null default now()
);

create trigger pricing_settings_set_updated_at
  before update on public.pricing_settings
  for each row execute function public.set_updated_at();

create trigger pricing_settings_set_updated_by
  before update on public.pricing_settings
  for each row execute function public.set_updated_by();

create index pricing_settings_updated_by_idx
  on public.pricing_settings (updated_by);

insert into public.pricing_settings (business_id)
select id from public.businesses;

-- ---------------------------------------------------------------------------
-- price_items
-- ---------------------------------------------------------------------------

create table public.price_items (
  id uuid primary key default gen_random_uuid(),
  business_id uuid not null default public.current_business_id()
    references public.businesses (id) on delete cascade,
  name text not null
    constraint price_items_name_length
      check (length(trim(name)) between 1 and 120),
  description text
    constraint price_items_description_length
      check (length(description) <= 1000),
  pricing_type public.pricing_type not null,
  price_cents bigint not null
    constraint price_items_price_cents_range
      check (price_cents between 0 and 100000000),
  created_by uuid not null default auth.uid()
    references public.users (id),
  updated_by uuid references public.users (id),
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now()
);

create trigger price_items_set_updated_at
  before update on public.price_items
  for each row execute function public.set_updated_at();

create trigger price_items_set_updated_by
  before update on public.price_items
  for each row execute function public.set_updated_by();

create index price_items_business_id_name_idx
  on public.price_items (business_id, lower(name));

create index price_items_created_by_idx
  on public.price_items (created_by);

create index price_items_updated_by_idx
  on public.price_items (updated_by);

-- ---------------------------------------------------------------------------
-- Grants: authenticated only. Revoke everything from anon.
-- ---------------------------------------------------------------------------

revoke all on table public.pricing_settings from anon, authenticated, public;
revoke all on table public.price_items from anon, authenticated, public;

grant select on table public.pricing_settings to authenticated;
grant update (labor_rate_cents, overhead_bps)
  on table public.pricing_settings to authenticated;

grant select on table public.price_items to authenticated;
grant insert (
  id, business_id, name, description, pricing_type, price_cents,
  created_by, created_at, updated_at
) on table public.price_items to authenticated;
grant update (name, description, pricing_type, price_cents)
  on table public.price_items to authenticated;
grant delete on table public.price_items to authenticated;

-- ---------------------------------------------------------------------------
-- RLS
-- ---------------------------------------------------------------------------

alter table public.pricing_settings enable row level security;
alter table public.price_items enable row level security;

create policy pricing_settings_select on public.pricing_settings
  for select to authenticated
  using (business_id = (select public.current_business_id()));

create policy pricing_settings_update on public.pricing_settings
  for update to authenticated
  using (business_id = (select public.current_business_id()))
  with check (business_id = (select public.current_business_id()));

create policy price_items_select on public.price_items
  for select to authenticated
  using (business_id = (select public.current_business_id()));

create policy price_items_insert on public.price_items
  for insert to authenticated
  with check (business_id = (select public.current_business_id()));

create policy price_items_update on public.price_items
  for update to authenticated
  using (business_id = (select public.current_business_id()))
  with check (business_id = (select public.current_business_id()));

create policy price_items_delete on public.price_items
  for delete to authenticated
  using (business_id = (select public.current_business_id()));

-- ---------------------------------------------------------------------------
-- create_business: insert the settings row in the same transaction.
-- ---------------------------------------------------------------------------

create or replace function public.create_business(p_name text)
returns uuid
language plpgsql
security definer
set search_path = public
as $$
declare
  v_name text;
  v_id uuid;
begin
  perform 1 from public.users where id = auth.uid() for update;

  if exists (select 1 from public.memberships where user_id = auth.uid()) then
    raise exception 'already_in_business' using errcode = 'Q0001';
  end if;

  v_name := trim(p_name);
  if v_name is null or length(v_name) not between 1 and 80 then
    raise exception 'invalid_business_name' using errcode = 'Q0002';
  end if;

  insert into public.businesses (name, owner_id)
  values (v_name, auth.uid())
  returning id into v_id;

  insert into public.memberships (user_id, business_id, role)
  values (auth.uid(), v_id, 'owner');

  insert into public.pricing_settings (business_id)
  values (v_id);

  return v_id;
end;
$$;
