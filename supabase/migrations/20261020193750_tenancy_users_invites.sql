-- Tenancy, users, memberships, and invites.
--
-- Error tokens (SQLSTATE class Q0):
--   Q0001 already_in_business
--   Q0002 invalid_business_name
--   Q0010 invite_not_found
--   Q0011 invite_expired
--   Q0012 invite_used
--   Q0013 invite_revoked
--   Q0020 not_owner
--   Q0021 invite_not_active
--   Q0030 member_not_found
--   Q0031 cannot_remove_owner
--
-- Every future table uses:
--   business_id uuid not null default current_business_id()
-- and RLS:
--   using (business_id = current_business_id())

-- ---------------------------------------------------------------------------
-- Types and shared trigger
-- ---------------------------------------------------------------------------

create type public.user_role as enum ('owner', 'member');

create function public.set_updated_at()
returns trigger
language plpgsql
set search_path = public
as $$
begin
  new.updated_at = now();
  return new;
end;
$$;

-- ---------------------------------------------------------------------------
-- users (created before businesses; businesses.owner_id references users)
-- ---------------------------------------------------------------------------

create table public.users (
  id uuid primary key references auth.users (id) on delete cascade,
  email text not null unique,
  full_name text not null,
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now()
);

create trigger users_set_updated_at
  before update on public.users
  for each row execute function public.set_updated_at();

create function public.handle_new_user()
returns trigger
language plpgsql
security definer
set search_path = public
as $$
begin
  insert into public.users (id, email, full_name)
  values (
    new.id,
    coalesce(new.email, ''),
    coalesce(new.raw_user_meta_data->>'full_name', '')
  );
  return new;
end;
$$;

create trigger on_auth_user_created
  after insert on auth.users
  for each row execute function public.handle_new_user();

-- ---------------------------------------------------------------------------
-- businesses
-- ---------------------------------------------------------------------------

create table public.businesses (
  id uuid primary key default gen_random_uuid(),
  name text not null,
  owner_id uuid not null references public.users (id),
  timezone text not null default 'America/New_York',
  default_onsite_minutes int not null default 60,
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now(),
  constraint businesses_name_length check (length(trim(name)) between 1 and 80),
  constraint businesses_default_onsite_minutes_positive check (default_onsite_minutes > 0)
);

create trigger businesses_set_updated_at
  before update on public.businesses
  for each row execute function public.set_updated_at();

create index businesses_owner_id_idx on public.businesses (owner_id);

-- ---------------------------------------------------------------------------
-- memberships (PK = one business per user in Part 1)
-- ---------------------------------------------------------------------------

create table public.memberships (
  user_id uuid primary key references public.users (id) on delete cascade,
  business_id uuid not null references public.businesses (id) on delete cascade,
  role public.user_role not null,
  joined_at timestamptz not null default now()
);

create index memberships_business_id_idx on public.memberships (business_id);

-- Exactly one owner per business at the database level.
create unique index memberships_one_owner_per_business
  on public.memberships (business_id)
  where role = 'owner';

-- ---------------------------------------------------------------------------
-- current_business_id / is_business_owner
-- ---------------------------------------------------------------------------

create function public.current_business_id()
returns uuid
language sql
stable
security definer
set search_path = public
as $$
  select business_id from public.memberships where user_id = auth.uid()
$$;

comment on function public.current_business_id() is
  'Every future table uses business_id uuid not null default current_business_id() and RLS using (business_id = current_business_id()). Reads memberships live, so removing a member ends access on their next query.';

create function public.is_business_owner()
returns boolean
language sql
stable
security definer
set search_path = public
as $$
  select coalesce(
    (select role = 'owner' from public.memberships where user_id = auth.uid()),
    false
  )
$$;

-- ---------------------------------------------------------------------------
-- invites
-- ---------------------------------------------------------------------------

create table public.invites (
  id uuid primary key default gen_random_uuid(),
  business_id uuid not null default public.current_business_id() references public.businesses (id) on delete cascade,
  code text not null unique,
  created_by uuid not null references public.users (id),
  created_at timestamptz not null default now(),
  expires_at timestamptz not null,
  used_at timestamptz,
  used_by uuid references public.users (id),
  revoked_at timestamptz
);

create index invites_business_id_idx on public.invites (business_id);
create index invites_created_by_idx on public.invites (created_by);

-- Status is derived, not stored: revoked if revoked_at, used if used_at,
-- expired if now() >= expires_at, else active.
create view public.invite_list
with (security_invoker = true) as
select
  i.id,
  i.business_id,
  i.code,
  i.created_by,
  i.created_at,
  i.expires_at,
  i.used_at,
  i.used_by,
  i.revoked_at,
  case
    when i.revoked_at is not null then 'revoked'
    when i.used_at is not null then 'used'
    when now() >= i.expires_at then 'expired'
    else 'active'
  end as status,
  u.full_name as used_by_name
from public.invites i
left join public.users u on u.id = i.used_by;

-- ---------------------------------------------------------------------------
-- Grants: authenticated only. Revoke everything from anon.
-- ---------------------------------------------------------------------------

revoke all on table public.users from anon, authenticated, public;
revoke all on table public.businesses from anon, authenticated, public;
revoke all on table public.memberships from anon, authenticated, public;
revoke all on table public.invites from anon, authenticated, public;
revoke all on table public.invite_list from anon, authenticated, public;

grant select on table public.users to authenticated;
grant update (full_name) on table public.users to authenticated;

grant select on table public.businesses to authenticated;
grant update (name) on table public.businesses to authenticated;

grant select on table public.memberships to authenticated;

grant select on table public.invites to authenticated;
grant select on table public.invite_list to authenticated;

-- ---------------------------------------------------------------------------
-- RLS
-- ---------------------------------------------------------------------------

alter table public.users enable row level security;
alter table public.businesses enable row level security;
alter table public.memberships enable row level security;
alter table public.invites enable row level security;

create policy users_select on public.users
  for select to authenticated
  using (
    id = (select auth.uid())
    or exists (
      select 1
      from public.memberships m
      where m.user_id = users.id
        and m.business_id = (select public.current_business_id())
    )
  );

create policy users_update on public.users
  for update to authenticated
  using (id = (select auth.uid()))
  with check (id = (select auth.uid()));

create policy memberships_select on public.memberships
  for select to authenticated
  using (business_id = (select public.current_business_id()));

create policy businesses_select on public.businesses
  for select to authenticated
  using (id = (select public.current_business_id()));

create policy businesses_update on public.businesses
  for update to authenticated
  using ((select public.is_business_owner()))
  with check ((select public.is_business_owner()));

create policy invites_select on public.invites
  for select to authenticated
  using (
    business_id = (select public.current_business_id())
    and (select public.is_business_owner())
  );

-- ---------------------------------------------------------------------------
-- SQL functions (security definer). Client never writes memberships,
-- businesses, or invites directly.
-- ---------------------------------------------------------------------------

create function public.create_business(p_name text)
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

  return v_id;
end;
$$;

create function public.redeem_invite(p_code text)
returns uuid
language plpgsql
security definer
set search_path = public
as $$
declare
  v_code text;
  v_invite public.invites%rowtype;
begin
  perform 1 from public.users where id = auth.uid() for update;

  if exists (select 1 from public.memberships where user_id = auth.uid()) then
    raise exception 'already_in_business' using errcode = 'Q0001';
  end if;

  v_code := upper(replace(replace(trim(p_code), ' ', ''), '-', ''));

  select * into v_invite
  from public.invites
  where code = v_code
  for update;

  if not found then
    raise exception 'invite_not_found' using errcode = 'Q0010';
  end if;

  if v_invite.revoked_at is not null then
    raise exception 'invite_revoked' using errcode = 'Q0013';
  end if;

  if v_invite.used_at is not null then
    raise exception 'invite_used' using errcode = 'Q0012';
  end if;

  if now() >= v_invite.expires_at then
    raise exception 'invite_expired' using errcode = 'Q0011';
  end if;

  insert into public.memberships (user_id, business_id, role)
  values (auth.uid(), v_invite.business_id, 'member');

  update public.invites
  set used_at = now(), used_by = auth.uid()
  where id = v_invite.id;

  return v_invite.business_id;
end;
$$;

create function public.create_invite()
returns public.invite_list
language plpgsql
security definer
set search_path = public
as $$
declare
  v_id uuid;
  v_code text;
  v_row public.invite_list;
  v_alphabet constant text := 'ABCDEFGHJKMNPQRSTUVWXYZ23456789';
  v_attempt int;
  v_n int;
begin
  if not public.is_business_owner() then
    raise exception 'not_owner' using errcode = 'Q0020';
  end if;

  v_id := gen_random_uuid();

  for v_attempt in 1..20 loop
    v_code := '';
    for v_n in 1..8 loop
      v_code := v_code || substr(v_alphabet, 1 + (floor(random() * 32))::int, 1);
    end loop;

    begin
      insert into public.invites (
        id, business_id, code, created_by, expires_at
      ) values (
        v_id,
        public.current_business_id(),
        v_code,
        auth.uid(),
        now() + interval '7 days'
      );

      select * into v_row from public.invite_list where id = v_id;
      return v_row;
    exception
      when unique_violation then
        v_id := gen_random_uuid();
    end;
  end loop;

  raise exception 'invite_not_found' using errcode = 'Q0010';
end;
$$;

create function public.revoke_invite(p_invite_id uuid)
returns void
language plpgsql
security definer
set search_path = public
as $$
declare
  v_invite public.invites%rowtype;
begin
  if not public.is_business_owner() then
    raise exception 'not_owner' using errcode = 'Q0020';
  end if;

  select * into v_invite
  from public.invites
  where id = p_invite_id
  for update;

  if not found or v_invite.business_id is distinct from public.current_business_id() then
    raise exception 'not_owner' using errcode = 'Q0020';
  end if;

  if v_invite.revoked_at is not null
     or v_invite.used_at is not null
     or now() >= v_invite.expires_at then
    raise exception 'invite_not_active' using errcode = 'Q0021';
  end if;

  update public.invites
  set revoked_at = now()
  where id = p_invite_id;
end;
$$;

create function public.remove_member(p_user_id uuid)
returns void
language plpgsql
security definer
set search_path = public
as $$
declare
  v_membership public.memberships%rowtype;
begin
  if not public.is_business_owner() then
    raise exception 'not_owner' using errcode = 'Q0020';
  end if;

  select * into v_membership
  from public.memberships
  where user_id = p_user_id
  for update;

  if not found or v_membership.business_id is distinct from public.current_business_id() then
    raise exception 'member_not_found' using errcode = 'Q0030';
  end if;

  if v_membership.role = 'owner' then
    raise exception 'cannot_remove_owner' using errcode = 'Q0031';
  end if;

  delete from public.memberships where user_id = p_user_id;
  delete from auth.sessions where user_id = p_user_id;
end;
$$;

revoke all on function public.current_business_id() from public, anon;
revoke all on function public.is_business_owner() from public, anon;
revoke all on function public.create_business(text) from public, anon;
revoke all on function public.redeem_invite(text) from public, anon;
revoke all on function public.create_invite() from public, anon;
revoke all on function public.revoke_invite(uuid) from public, anon;
revoke all on function public.remove_member(uuid) from public, anon;
revoke all on function public.handle_new_user() from public, anon, authenticated;
revoke all on function public.set_updated_at() from public, anon, authenticated;

grant execute on function public.current_business_id() to authenticated;
grant execute on function public.is_business_owner() to authenticated;
grant execute on function public.create_business(text) to authenticated;
grant execute on function public.redeem_invite(text) to authenticated;
grant execute on function public.create_invite() to authenticated;
grant execute on function public.revoke_invite(uuid) to authenticated;
grant execute on function public.remove_member(uuid) to authenticated;
