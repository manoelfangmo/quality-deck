-- Jobs and line items on a project. Prices are copied, not referenced.
--
-- Error tokens (SQLSTATE class Q0):
--   Q0060 price_item_not_found
--   Q0070 project_not_found
--   Q0073 project_archived
--   Q0074 job_not_found
--   Q0075 line_item_not_found
--   Q0076 invalid_quantity
--   Q0077 field_locked
--   Q0078 reorder_mismatch
--   Q0079 invalid_overhead

-- ---------------------------------------------------------------------------
-- Shared check: true when the project is in the caller's business and not
-- archived. Used by jobs RLS and by the line-item write functions.
-- ---------------------------------------------------------------------------

create function public.project_is_writable(p_project_id uuid)
returns boolean
language sql
stable
security definer
set search_path = public
as $$
  select exists (
    select 1
    from public.projects
    where id = p_project_id
      and business_id = public.current_business_id()
      and archived_at is null
  );
$$;

revoke all on function public.project_is_writable(uuid) from public, anon;
grant execute on function public.project_is_writable(uuid) to authenticated;

-- ---------------------------------------------------------------------------
-- job_type
-- ---------------------------------------------------------------------------

create type public.job_type as enum ('deck', 'patio', 'hardscaping');

-- ---------------------------------------------------------------------------
-- jobs
-- ---------------------------------------------------------------------------

create table public.jobs (
  id uuid primary key default gen_random_uuid(),
  business_id uuid not null default public.current_business_id()
    references public.businesses (id),
  project_id uuid not null references public.projects (id) on delete cascade,
  title text not null,
  job_type public.job_type not null,
  description text,
  labor_hours numeric(8, 2),
  labor_rate_cents bigint,
  labor_total_cents bigint
    generated always as (
      round(labor_hours * labor_rate_cents)::bigint
    ) stored,
  created_by uuid not null default auth.uid()
    references public.users (id),
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now(),
  constraint jobs_title_length
    check (length(trim(title)) between 1 and 120),
  constraint jobs_description_length
    check (length(description) <= 2000),
  constraint jobs_labor_hours_range
    check (labor_hours > 0 and labor_hours <= 10000),
  constraint jobs_labor_rate_cents_range
    check (labor_rate_cents between 0 and 100000),
  constraint jobs_labor_pair
    check ((labor_hours is null) = (labor_rate_cents is null))
);

create trigger jobs_set_updated_at
  before update on public.jobs
  for each row execute function public.set_updated_at();

create function public.jobs_normalize()
returns trigger
language plpgsql
set search_path = public
as $$
begin
  new.title := trim(new.title);
  if new.description is not null then
    new.description := nullif(trim(new.description), '');
  end if;
  return new;
end;
$$;

create trigger jobs_normalize
  before insert or update on public.jobs
  for each row execute function public.jobs_normalize();

create index jobs_project_id_created_at_id_idx
  on public.jobs (project_id, created_at, id);

create index jobs_created_by_idx
  on public.jobs (created_by);

-- ---------------------------------------------------------------------------
-- projects: overhead (basis points; null = none)
-- ---------------------------------------------------------------------------

alter table public.projects
  add column overhead_bps int,
  add constraint projects_overhead_bps_range
    check (overhead_bps between 0 and 10000);

-- ---------------------------------------------------------------------------
-- line_items
-- ---------------------------------------------------------------------------

create table public.line_items (
  id uuid primary key default gen_random_uuid(),
  business_id uuid not null default public.current_business_id()
    references public.businesses (id),
  job_id uuid not null references public.jobs (id) on delete cascade,
  position int not null,
  is_custom boolean not null,
  price_item_id uuid references public.price_items (id) on delete set null,
  name text not null,
  description text,
  pricing_type public.pricing_type not null,
  quantity numeric(10, 2) not null,
  saved_price_cents bigint not null,
  override_price_cents bigint,
  total_cents bigint
    generated always as (
      round(
        quantity * coalesce(override_price_cents, saved_price_cents)
      )::bigint
    ) stored,
  created_by uuid not null default auth.uid()
    references public.users (id),
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now(),
  constraint line_items_name_length
    check (length(trim(name)) between 1 and 120),
  constraint line_items_description_length
    check (length(description) <= 1000),
  constraint line_items_quantity_range
    check (quantity > 0 and quantity <= 1000000),
  constraint line_items_fixed_quantity
    check (pricing_type <> 'fixed' or quantity = 1),
  constraint line_items_saved_price_cents_range
    check (saved_price_cents between 0 and 100000000),
  constraint line_items_override_price_cents_range
    check (override_price_cents between 0 and 100000000),
  constraint line_items_custom_no_override
    check (not is_custom or override_price_cents is null),
  constraint line_items_job_id_position_key
    unique (job_id, position) deferrable initially deferred
);

create trigger line_items_set_updated_at
  before update on public.line_items
  for each row execute function public.set_updated_at();

create index line_items_job_id_position_idx
  on public.line_items (job_id, position);

create index line_items_created_by_idx
  on public.line_items (created_by);

create index line_items_price_item_id_idx
  on public.line_items (price_item_id);

-- ---------------------------------------------------------------------------
-- Grants
-- ---------------------------------------------------------------------------

revoke all on table public.jobs from anon, authenticated, public;
revoke all on table public.line_items from anon, authenticated, public;

grant select on table public.jobs to authenticated;
grant insert (
  id, business_id, project_id, title, job_type, description,
  created_by, created_at, updated_at
) on table public.jobs to authenticated;
grant update (
  title, job_type, description, labor_hours, labor_rate_cents
) on table public.jobs to authenticated;
grant delete on table public.jobs to authenticated;

grant select on table public.line_items to authenticated;

-- ---------------------------------------------------------------------------
-- RLS
-- ---------------------------------------------------------------------------

alter table public.jobs enable row level security;
alter table public.line_items enable row level security;

create policy jobs_select on public.jobs
  for select to authenticated
  using (business_id = (select public.current_business_id()));

create policy jobs_insert on public.jobs
  for insert to authenticated
  with check (
    business_id = (select public.current_business_id())
    and public.project_is_writable(project_id)
  );

create policy jobs_update on public.jobs
  for update to authenticated
  using (public.project_is_writable(project_id))
  with check (public.project_is_writable(project_id));

create policy jobs_delete on public.jobs
  for delete to authenticated
  using (public.project_is_writable(project_id));

create policy line_items_select on public.line_items
  for select to authenticated
  using (business_id = (select public.current_business_id()));

-- ---------------------------------------------------------------------------
-- project_rows: include overhead_bps
-- ---------------------------------------------------------------------------

drop view public.project_rows;

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
  a.duration_minutes       as appointment_duration_minutes,
  p.overhead_bps
from public.projects p
join public.clients c on c.id = p.client_id
left join public.appointments a
  on a.client_id = c.id and a.deleted_at is null;

revoke all on table public.project_rows from anon, authenticated, public;
grant select on table public.project_rows to authenticated;

-- ---------------------------------------------------------------------------
-- Write helpers (internal; not granted to authenticated)
-- ---------------------------------------------------------------------------

create function public._assert_job_writable(p_job_id uuid)
returns uuid
language plpgsql
stable
security definer
set search_path = public
as $$
declare
  v_business_id uuid;
  v_archived_at timestamptz;
begin
  select p.business_id, p.archived_at
  into v_business_id, v_archived_at
  from public.jobs j
  join public.projects p on p.id = j.project_id
  where j.id = p_job_id;

  if not found or v_business_id is distinct from public.current_business_id() then
    raise exception 'job_not_found' using errcode = 'Q0074';
  end if;

  if v_archived_at is not null then
    raise exception 'project_archived' using errcode = 'Q0073';
  end if;

  return p_job_id;
end;
$$;

create function public._assert_line_writable(p_id uuid)
returns uuid
language plpgsql
stable
security definer
set search_path = public
as $$
declare
  v_job_id uuid;
  v_business_id uuid;
  v_archived_at timestamptz;
begin
  select li.job_id, p.business_id, p.archived_at
  into v_job_id, v_business_id, v_archived_at
  from public.line_items li
  join public.jobs j on j.id = li.job_id
  join public.projects p on p.id = j.project_id
  where li.id = p_id;

  if not found or v_business_id is distinct from public.current_business_id() then
    raise exception 'line_item_not_found' using errcode = 'Q0075';
  end if;

  if v_archived_at is not null then
    raise exception 'project_archived' using errcode = 'Q0073';
  end if;

  return v_job_id;
end;
$$;

create function public._assert_project_writable(p_id uuid)
returns void
language plpgsql
stable
security definer
set search_path = public
as $$
declare
  v_business_id uuid;
  v_archived_at timestamptz;
begin
  select business_id, archived_at
  into v_business_id, v_archived_at
  from public.projects
  where id = p_id;

  if not found or v_business_id is distinct from public.current_business_id() then
    raise exception 'project_not_found' using errcode = 'Q0070';
  end if;

  if v_archived_at is not null then
    raise exception 'project_archived' using errcode = 'Q0073';
  end if;
end;
$$;

create function public._resolved_quantity(
  p_pricing_type public.pricing_type,
  p_quantity numeric
)
returns numeric
language plpgsql
immutable
set search_path = public
as $$
declare
  v_quantity numeric(10, 2);
begin
  if p_pricing_type = 'fixed' then
    return 1;
  end if;

  if p_quantity is null then
    raise exception 'invalid_quantity' using errcode = 'Q0076';
  end if;

  v_quantity := round(p_quantity, 2);
  if v_quantity <= 0 or v_quantity > 1000000 then
    raise exception 'invalid_quantity' using errcode = 'Q0076';
  end if;

  return v_quantity;
end;
$$;

revoke all on function public._assert_job_writable(uuid) from public, anon, authenticated;
revoke all on function public._assert_line_writable(uuid) from public, anon, authenticated;
revoke all on function public._assert_project_writable(uuid) from public, anon, authenticated;
revoke all on function public._resolved_quantity(public.pricing_type, numeric) from public, anon, authenticated;

-- ---------------------------------------------------------------------------
-- add_price_list_line
-- ---------------------------------------------------------------------------

create function public.add_price_list_line(
  p_job_id uuid,
  p_price_item_id uuid,
  p_quantity numeric
)
returns uuid
language plpgsql
security definer
set search_path = public
as $$
declare
  v_item public.price_items%rowtype;
  v_quantity numeric(10, 2);
  v_position int;
  v_id uuid;
begin
  perform public._assert_job_writable(p_job_id);

  select * into v_item
  from public.price_items
  where id = p_price_item_id
    and business_id = public.current_business_id();

  if not found then
    raise exception 'price_item_not_found' using errcode = 'Q0060';
  end if;

  v_quantity := public._resolved_quantity(v_item.pricing_type, p_quantity);

  select count(*) into v_position
  from public.line_items
  where job_id = p_job_id;

  insert into public.line_items (
    job_id, position, is_custom, price_item_id,
    name, description, pricing_type, quantity, saved_price_cents
  ) values (
    p_job_id, v_position, false, v_item.id,
    v_item.name, v_item.description, v_item.pricing_type,
    v_quantity, v_item.price_cents
  )
  returning id into v_id;

  return v_id;
end;
$$;

-- ---------------------------------------------------------------------------
-- add_custom_line
-- ---------------------------------------------------------------------------

create function public.add_custom_line(
  p_job_id uuid,
  p_name text,
  p_description text,
  p_pricing_type public.pricing_type,
  p_quantity numeric,
  p_price_cents bigint
)
returns uuid
language plpgsql
security definer
set search_path = public
as $$
declare
  v_quantity numeric(10, 2);
  v_position int;
  v_id uuid;
begin
  perform public._assert_job_writable(p_job_id);

  v_quantity := public._resolved_quantity(p_pricing_type, p_quantity);

  select count(*) into v_position
  from public.line_items
  where job_id = p_job_id;

  insert into public.line_items (
    job_id, position, is_custom, price_item_id,
    name, description, pricing_type, quantity, saved_price_cents
  ) values (
    p_job_id, v_position, true, null,
    trim(p_name),
    nullif(trim(p_description), ''),
    p_pricing_type,
    v_quantity,
    p_price_cents
  )
  returning id into v_id;

  return v_id;
end;
$$;

-- ---------------------------------------------------------------------------
-- update_line
-- ---------------------------------------------------------------------------

create function public.update_line(
  p_id uuid,
  p_quantity numeric default null,
  p_description text default null,
  p_override_price_cents bigint default null,
  p_name text default null,
  p_pricing_type public.pricing_type default null,
  p_price_cents bigint default null
)
returns void
language plpgsql
security definer
set search_path = public
as $$
declare
  v_is_custom boolean;
  v_pricing_type public.pricing_type;
  v_quantity numeric(10, 2);
begin
  perform public._assert_line_writable(p_id);

  select is_custom, pricing_type
  into v_is_custom, v_pricing_type
  from public.line_items
  where id = p_id;

  if v_is_custom then
    if p_override_price_cents is not null then
      raise exception 'field_locked' using errcode = 'Q0077';
    end if;

    v_pricing_type := coalesce(p_pricing_type, v_pricing_type);
    v_quantity := public._resolved_quantity(v_pricing_type, p_quantity);

    update public.line_items
    set
      name = trim(p_name),
      description = nullif(trim(p_description), ''),
      pricing_type = v_pricing_type,
      quantity = v_quantity,
      saved_price_cents = p_price_cents,
      override_price_cents = null
    where id = p_id;
  else
    if p_name is not null or p_pricing_type is not null or p_price_cents is not null then
      raise exception 'field_locked' using errcode = 'Q0077';
    end if;

    v_quantity := public._resolved_quantity(v_pricing_type, p_quantity);

    update public.line_items
    set
      quantity = v_quantity,
      description = nullif(trim(p_description), ''),
      override_price_cents = p_override_price_cents
    where id = p_id;
  end if;
end;
$$;

-- ---------------------------------------------------------------------------
-- reorder_lines
-- ---------------------------------------------------------------------------

create function public.reorder_lines(
  p_job_id uuid,
  p_ids uuid[]
)
returns void
language plpgsql
security definer
set search_path = public
as $$
declare
  v_count int;
begin
  perform public._assert_job_writable(p_job_id);

  select count(*) into v_count
  from public.line_items
  where job_id = p_job_id;

  if p_ids is null
    or cardinality(p_ids) is distinct from v_count
    or (
      select count(distinct x) from unnest(p_ids) as x
    ) is distinct from v_count
    or exists (
      select x from unnest(p_ids) as x
      except
      select li.id from public.line_items li where li.job_id = p_job_id
    )
  then
    raise exception 'reorder_mismatch' using errcode = 'Q0078';
  end if;

  update public.line_items li
  set position = v.ord - 1
  from unnest(p_ids) with ordinality as v(id, ord)
  where li.id = v.id
    and li.job_id = p_job_id;
end;
$$;

-- ---------------------------------------------------------------------------
-- delete_line
-- ---------------------------------------------------------------------------

create function public.delete_line(p_id uuid)
returns void
language plpgsql
security definer
set search_path = public
as $$
declare
  v_job_id uuid;
  v_position int;
begin
  v_job_id := public._assert_line_writable(p_id);

  select position into v_position
  from public.line_items
  where id = p_id;

  delete from public.line_items where id = p_id;

  update public.line_items
  set position = position - 1
  where job_id = v_job_id
    and position > v_position;
end;
$$;

-- ---------------------------------------------------------------------------
-- update_project
-- ---------------------------------------------------------------------------

create function public.update_project(
  p_id uuid,
  p_title text,
  p_site_street text,
  p_site_city text,
  p_site_state text,
  p_site_zip text
)
returns void
language plpgsql
security definer
set search_path = public
as $$
begin
  perform public._assert_project_writable(p_id);

  update public.projects
  set
    title = trim(p_title),
    site_street = trim(p_site_street),
    site_city = trim(p_site_city),
    site_state = upper(trim(p_site_state)),
    site_zip = trim(p_site_zip)
  where id = p_id
    and business_id = public.current_business_id();
end;
$$;

-- ---------------------------------------------------------------------------
-- set_project_overhead
-- ---------------------------------------------------------------------------

create function public.set_project_overhead(
  p_id uuid,
  p_overhead_bps int
)
returns void
language plpgsql
security definer
set search_path = public
as $$
begin
  perform public._assert_project_writable(p_id);

  if p_overhead_bps is not null
    and (p_overhead_bps < 0 or p_overhead_bps > 10000)
  then
    raise exception 'invalid_overhead' using errcode = 'Q0079';
  end if;

  update public.projects
  set overhead_bps = p_overhead_bps
  where id = p_id
    and business_id = public.current_business_id();
end;
$$;

-- ---------------------------------------------------------------------------
-- Function grants
-- ---------------------------------------------------------------------------

revoke all on function public.add_price_list_line(uuid, uuid, numeric)
  from public, anon;
revoke all on function public.add_custom_line(uuid, text, text, public.pricing_type, numeric, bigint)
  from public, anon;
revoke all on function public.update_line(uuid, numeric, text, bigint, text, public.pricing_type, bigint)
  from public, anon;
revoke all on function public.reorder_lines(uuid, uuid[])
  from public, anon;
revoke all on function public.delete_line(uuid)
  from public, anon;
revoke all on function public.update_project(uuid, text, text, text, text, text)
  from public, anon;
revoke all on function public.set_project_overhead(uuid, int)
  from public, anon;

grant execute on function public.add_price_list_line(uuid, uuid, numeric)
  to authenticated;
grant execute on function public.add_custom_line(uuid, text, text, public.pricing_type, numeric, bigint)
  to authenticated;
grant execute on function public.update_line(uuid, numeric, text, bigint, text, public.pricing_type, bigint)
  to authenticated;
grant execute on function public.reorder_lines(uuid, uuid[])
  to authenticated;
grant execute on function public.delete_line(uuid)
  to authenticated;
grant execute on function public.update_project(uuid, text, text, text, text, text)
  to authenticated;
grant execute on function public.set_project_overhead(uuid, int)
  to authenticated;
