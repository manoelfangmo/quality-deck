-- Manual RLS / RPC check. Run after `supabase db reset`:
--   docker exec -i supabase_db_field-notes psql -U postgres -v ON_ERROR_STOP=1 < supabase/tests/rls_check.sql
-- The script wraps everything in a transaction and rolls back.

begin;

do $setup$
begin
  create or replace function public._test_as_user(p_user_id uuid)
  returns void
  language plpgsql
  as $fn$
  begin
    perform set_config('role', 'authenticated', true);
    perform set_config('request.jwt.claim.sub', p_user_id::text, true);
    perform set_config(
      'request.jwt.claims',
      json_build_object(
        'sub', p_user_id,
        'role', 'authenticated',
        'aal', 'aal1'
      )::text,
      true
    );
  end;
  $fn$;
end;
$setup$;

do $assert$
declare
  owner_id uuid := '00000000-0000-4000-8000-000000000001';
  crew_id uuid := '00000000-0000-4000-8000-000000000002';
  other_id uuid := '00000000-0000-4000-8000-000000000003';
  nobusiness_id uuid := '00000000-0000-4000-8000-000000000004';
  joiner_id uuid := '00000000-0000-4000-8000-000000000005';
  qd_id uuid := '00000000-0000-4000-8000-000000000011';
  other_biz_id uuid := '00000000-0000-4000-8000-000000000012';
  qd_client_id uuid := '00000000-0000-4000-8000-000000000101';
  qd_removed_id uuid := '00000000-0000-4000-8000-000000000131';
  other_client_id uuid := '00000000-0000-4000-8000-000000000141';
  qd_client_priya uuid := '00000000-0000-4000-8000-000000000103';
  qd_client_luis uuid := '00000000-0000-4000-8000-000000000104';
  qd_client_megan uuid := '00000000-0000-4000-8000-000000000105';
  qd_upcoming_appt uuid := '00000000-0000-4000-8000-000000000201';
  qd_past_appt uuid := '00000000-0000-4000-8000-000000000202';
  qd_removed_appt uuid := '00000000-0000-4000-8000-000000000203';
  other_appt uuid := '00000000-0000-4000-8000-000000000241';
  qd_item_id uuid := '00000000-0000-4000-8000-000000000301';
  other_item_id uuid := '00000000-0000-4000-8000-000000000341';
  v_count int;
  v_id uuid;
  v_labor bigint;
  v_overhead int;
  v_role public.user_role;
  v_session_id uuid;
  v_deleted_at timestamptz;
  v_deleted_by uuid;
  v_appt_id uuid;
begin
  -- Quality Deck owner sees Quality Deck and both its users; not Other Co.
  perform public._test_as_user(owner_id);
  select count(*) into v_count from public.businesses;
  assert v_count = 1, 'owner should see 1 business';
  assert (select id from public.businesses) = qd_id, 'owner should see Quality Deck';
  select count(*) into v_count from public.users;
  assert v_count = 2, 'owner should see 2 users in Quality Deck';
  assert not exists (select 1 from public.businesses where id = other_biz_id),
    'owner must not see Other Co';
  select count(*) into v_count from public.invites;
  assert v_count = 4, 'owner should see all four invites';
  select count(*) into v_count from public.invite_list;
  assert v_count = 4, 'owner should see all four invite_list rows';
  select count(*) into v_count from public.clients;
  assert v_count = 32, 'owner should see Quality Deck clients including removed';
  assert exists (select 1 from public.clients where id = qd_removed_id),
    'owner should see a removed Quality Deck client by direct select';
  assert not exists (select 1 from public.clients where id = other_client_id),
    'owner must not see Other Co clients';

  -- Quality Deck member sees the business and both users; no invites; not Other Co.
  perform public._test_as_user(crew_id);
  select count(*) into v_count from public.businesses;
  assert v_count = 1, 'member should see 1 business';
  assert (select id from public.businesses) = qd_id, 'member should see Quality Deck';
  select count(*) into v_count from public.users;
  assert v_count = 2, 'member should see 2 users in Quality Deck';
  assert not exists (select 1 from public.businesses where id = other_biz_id),
    'member must not see Other Co';
  select count(*) into v_count from public.invites;
  assert v_count = 0, 'member should see no invites';
  select count(*) into v_count from public.invite_list;
  assert v_count = 0, 'member should see no invite_list rows';
  select count(*) into v_count from public.clients;
  assert v_count = 32, 'member should see Quality Deck clients including removed';
  assert not exists (select 1 from public.clients where id = other_client_id),
    'member must not see Other Co clients';

  -- Member calling owner-only RPCs gets Q0020.
  begin
    perform public.create_invite();
    raise exception 'member create_invite should fail';
  exception
    when sqlstate 'Q0020' then null;
  end;

  begin
    perform public.revoke_invite('00000000-0000-4000-8000-000000000021');
    raise exception 'member revoke_invite should fail';
  exception
    when sqlstate 'Q0020' then null;
  end;

  begin
    perform public.remove_member(owner_id);
    raise exception 'member remove_member should fail';
  exception
    when sqlstate 'Q0020' then null;
  end;

  -- Pricing: isolation, member writes, constraints, and permanent delete.
  perform public._test_as_user(owner_id);
  select count(*) into v_count from public.pricing_settings;
  assert v_count = 1, 'owner should see 1 pricing_settings row';
  select labor_rate_cents, overhead_bps into v_labor, v_overhead
  from public.pricing_settings;
  assert v_labor = 6500, 'owner should see Quality Deck labor rate';
  assert v_overhead = 1250, 'owner should see Quality Deck overhead';
  select count(*) into v_count from public.price_items;
  assert v_count = 25, 'owner should see 25 Quality Deck price items';
  assert not exists (select 1 from public.price_items where id = other_item_id),
    'owner must not see Other Co price items';

  perform public._test_as_user(other_id);
  select count(*) into v_count from public.pricing_settings;
  assert v_count = 1, 'Other Co should see 1 pricing_settings row';
  assert (select labor_rate_cents from public.pricing_settings) is null,
    'Other Co labor rate should be unset';
  assert (select overhead_bps from public.pricing_settings) is null,
    'Other Co overhead should be unset';
  select count(*) into v_count from public.price_items;
  assert v_count = 3, 'Other Co should see 3 price items';
  assert not exists (select 1 from public.price_items where id = qd_item_id),
    'Other Co must not see Quality Deck price items';
  update public.pricing_settings
  set labor_rate_cents = 1
  where business_id = qd_id;
  get diagnostics v_count = row_count;
  assert v_count = 0, 'Other Co must not update Quality Deck settings';
  delete from public.price_items where id = qd_item_id;
  get diagnostics v_count = row_count;
  assert v_count = 0, 'Other Co must not delete Quality Deck items';

  perform public._test_as_user(crew_id);
  update public.pricing_settings set labor_rate_cents = 7000;
  get diagnostics v_count = row_count;
  assert v_count = 1, 'member should update the labor rate';
  update public.pricing_settings set overhead_bps = 1500;
  get diagnostics v_count = row_count;
  assert v_count = 1, 'member should update overhead';
  assert (select updated_by from public.pricing_settings) = crew_id,
    'settings updated_by should be the member';

  insert into public.price_items (name, pricing_type, price_cents)
  values ('Temp item', 'fixed', 1000)
  returning id into v_id;
  update public.price_items set price_cents = 2000 where id = v_id;
  get diagnostics v_count = row_count;
  assert v_count = 1, 'member should edit a price item';
  delete from public.price_items where id = v_id;
  get diagnostics v_count = row_count;
  assert v_count = 1, 'member should delete a price item';
  assert not exists (select 1 from public.price_items where id = v_id),
    'deleting an item should remove the row';

  perform public._test_as_user(owner_id);
  begin
    insert into public.price_items (name, pricing_type, price_cents)
    values ('Negative', 'fixed', -1);
    raise exception 'negative price should fail';
  exception
    when check_violation then null;
  end;

  begin
    update public.pricing_settings set overhead_bps = 10001;
    raise exception 'overhead 10001 should fail';
  exception
    when check_violation then null;
  end;

  begin
    update public.pricing_settings set labor_rate_cents = 100001;
    raise exception 'labor rate over $1,000 should fail';
  exception
    when check_violation then null;
  end;

  begin
    insert into public.price_items (name, pricing_type, price_cents)
    values ('   ', 'fixed', 100);
    raise exception 'blank name should fail';
  exception
    when check_violation then null;
  end;

  begin
    insert into public.price_items (name, description, pricing_type, price_cents)
    values ('Long desc', repeat('x', 1001), 'fixed', 100);
    raise exception 'description over 1,000 characters should fail';
  exception
    when check_violation then null;
  end;

  begin
    update public.price_items
    set business_id = other_biz_id
    where id = qd_item_id;
    raise exception 'updating business_id on an item should fail';
  exception
    when insufficient_privilege then null;
    when sqlstate '42501' then null;
  end;

  -- nobusiness sees only their own users row and no business.
  perform public._test_as_user(nobusiness_id);
  select count(*) into v_count from public.users;
  assert v_count = 1, 'nobusiness should see only their own user row';
  assert (select id from public.users) = nobusiness_id;
  select count(*) into v_count from public.businesses;
  assert v_count = 0, 'nobusiness should see no business';
  select count(*) into v_count from public.memberships;
  assert v_count = 0, 'nobusiness should see no memberships';

  -- A second owner membership for the same business is rejected.
  perform set_config('role', 'postgres', true);
  begin
    insert into public.memberships (user_id, business_id, role)
    values (nobusiness_id, qd_id, 'owner');
    raise exception 'second owner membership should fail';
  exception
    when unique_violation then null;
  end;

  -- redeem_invite with each seeded code.
  begin
    perform public.redeem_invite('QDEXPIRD');
    raise exception 'expired invite should fail';
  exception
    when sqlstate 'Q0011' then null;
  end;

  begin
    perform public.redeem_invite('QDUSED22');
    raise exception 'used invite should fail';
  exception
    when sqlstate 'Q0012' then null;
  end;

  begin
    perform public.redeem_invite('QDREVOKD');
    raise exception 'revoked invite should fail';
  exception
    when sqlstate 'Q0013' then null;
  end;

  begin
    perform public.redeem_invite('ZZZZZZZZ');
    raise exception 'unknown invite should fail';
  exception
    when sqlstate 'Q0010' then null;
  end;

  begin
    perform public.redeem_invite('not a code');
    raise exception 'malformed invite should fail';
  exception
    when sqlstate 'Q0010' then null;
  end;

  v_id := public.redeem_invite('QDACTIVE');
  assert v_id = qd_id, 'active invite should join Quality Deck';
  select role into v_role from public.memberships where user_id = nobusiness_id;
  assert v_role = 'member', 'redeem_invite should grant member role';

  -- Second redeem of the now-used code, as another user, is Q0012.
  perform public._test_as_user(joiner_id);
  begin
    perform public.redeem_invite('QDACTIVE');
    raise exception 'second redeem should fail';
  exception
    when sqlstate 'Q0012' then null;
  end;

  -- create_business / redeem_invite by someone already in a business get Q0001.
  perform public._test_as_user(owner_id);
  begin
    perform public.create_business('Another Co');
    raise exception 'owner create_business should fail';
  exception
    when sqlstate 'Q0001' then null;
  end;

  begin
    perform public.redeem_invite('QDACTIVE');
    raise exception 'owner redeem_invite should fail';
  exception
    when sqlstate 'Q0001' then null;
  end;

  -- create_business gives the caller an owner membership.
  perform public._test_as_user(joiner_id);
  begin
    perform public.create_business('   ');
    raise exception 'blank business name should fail';
  exception
    when sqlstate 'Q0002' then null;
  end;

  v_id := public.create_business('Joiners Decks');
  select role into v_role from public.memberships where user_id = joiner_id;
  assert v_role = 'owner', 'create_business should grant owner role';
  assert (select b.owner_id from public.businesses b where b.id = v_id) = joiner_id,
    'create_business should set owner_id';
  assert exists (select 1 from public.pricing_settings where business_id = v_id),
    'create_business should create a pricing_settings row';
  assert (
    select labor_rate_cents from public.pricing_settings where business_id = v_id
  ) is null,
    'new pricing_settings labor rate should be unset';
  assert (
    select overhead_bps from public.pricing_settings where business_id = v_id
  ) is null,
    'new pricing_settings overhead should be unset';

  -- Seed a session for the crew so remove_member can revoke it.
  perform set_config('role', 'postgres', true);
  v_session_id := gen_random_uuid();
  insert into auth.sessions (id, user_id, created_at, updated_at)
  values (v_session_id, crew_id, now(), now());

  perform public._test_as_user(owner_id);
  perform public.remove_member(crew_id);

  perform set_config('role', 'postgres', true);
  assert not exists (select 1 from public.memberships where user_id = crew_id),
    'removed member membership should be gone';
  assert exists (select 1 from public.users where id = crew_id),
    'removed member users row should remain';
  assert not exists (select 1 from auth.sessions where user_id = crew_id),
    'removed member sessions should be gone';

  perform public._test_as_user(crew_id);
  select count(*) into v_count from public.businesses;
  assert v_count = 0, 'removed member should see 0 businesses';

  perform public._test_as_user(owner_id);
  begin
    perform public.remove_member(owner_id);
    raise exception 'cannot_remove_owner should fail';
  exception
    when sqlstate 'Q0031' then null;
  end;

  -- Appointments / client_rows: isolation, writes, and one-active-per-client.
  perform public._test_as_user(other_id);
  select count(*) into v_count from public.appointments;
  assert v_count = 1, 'Other Co should see only its own appointment';
  assert not exists (
    select 1 from public.appointments
    where id in (qd_upcoming_appt, qd_past_appt, qd_removed_appt)
  ), 'Other Co must not see Quality Deck appointments';
  select count(*) into v_count from public.client_rows;
  assert v_count = 3, 'Other Co should see 3 client_rows';
  assert not exists (
    select 1 from public.client_rows where id = qd_client_id
  ), 'Other Co must not see Quality Deck client_rows';
  begin
    perform public.add_appointment(
      qd_client_id, now() + interval '1 day', 60, null
    );
    raise exception 'add_appointment for another business should fail';
  exception
    when sqlstate 'Q0040' then null;
  end;

  perform public._test_as_user(owner_id);
  select count(*) into v_count from public.appointments;
  assert v_count = 3, 'owner should see 3 Quality Deck appointments including removed';
  select count(*) into v_count from public.client_rows;
  assert v_count = 30, 'owner should see 30 active client_rows';
  assert (
    select appointment_id from public.client_rows where id = qd_client_id
  ) = qd_upcoming_appt, 'Ana should show the upcoming appointment';
  assert (
    select appointment_id from public.client_rows where id = '00000000-0000-4000-8000-000000000102'
  ) = qd_past_appt, 'James should show the past appointment';
  assert (
    select appointment_id from public.client_rows where id = qd_client_priya
  ) is null, 'Priya''s removed appointment must not appear on client_rows';

  begin
    insert into public.appointments (client_id, starts_at, duration_minutes)
    values (qd_client_id, now() + interval '1 day', 60);
    raise exception 'direct appointment insert should fail';
  exception
    when insufficient_privilege then null;
    when sqlstate '42501' then null;
  end;

  begin
    update public.appointments
    set duration_minutes = 90
    where id = qd_upcoming_appt;
    raise exception 'direct appointment update should fail';
  exception
    when insufficient_privilege then null;
    when sqlstate '42501' then null;
  end;

  begin
    delete from public.appointments where id = qd_upcoming_appt;
    raise exception 'direct appointment delete should fail';
  exception
    when insufficient_privilege then null;
    when sqlstate '42501' then null;
  end;

  begin
    perform public.add_appointment(
      qd_client_megan, now() + interval '2 days', 10, null
    );
    raise exception '10-minute duration should fail';
  exception
    when sqlstate 'Q0050' then null;
  end;

  begin
    perform public.add_appointment(
      qd_client_id, now() + interval '1 day', 60, null
    );
    raise exception 'second add_appointment should fail';
  exception
    when sqlstate 'Q0053' then null;
  end;

  perform public.remove_appointment(qd_upcoming_appt);
  v_id := public.add_appointment(
    qd_client_id, now() + interval '1 day', 60, 'retry'
  );
  assert v_id is not null, 'add_appointment after remove should succeed';

  begin
    perform public.update_appointment(other_appt, now(), 60, null);
    raise exception 'update_appointment on another business should fail';
  exception
    when sqlstate 'Q0051' then null;
  end;

  begin
    perform public.remove_appointment(other_appt);
    raise exception 'remove_appointment on another business should fail';
  exception
    when sqlstate 'Q0051' then null;
  end;

  begin
    perform public.update_appointment(qd_removed_appt, now(), 60, null);
    raise exception 'update_appointment on removed should fail';
  exception
    when sqlstate 'Q0051' then null;
  end;

  begin
    perform public.remove_appointment(qd_removed_appt);
    raise exception 'remove_appointment on removed should fail';
  exception
    when sqlstate 'Q0051' then null;
  end;

  begin
    perform public.remove_appointment(qd_upcoming_appt);
    raise exception 'remove_appointment on just-removed should fail';
  exception
    when sqlstate 'Q0051' then null;
  end;

  begin
    perform public.add_appointment(
      qd_removed_id, now() + interval '1 day', 60, null
    );
    raise exception 'add_appointment for a removed client should fail';
  exception
    when sqlstate 'Q0040' then null;
  end;

  v_appt_id := public.add_appointment(
    qd_client_luis, now() + interval '4 days', 60, null
  );
  perform public.remove_client(qd_client_luis);
  select deleted_at, deleted_by into v_deleted_at, v_deleted_by
  from public.appointments
  where id = v_appt_id;
  assert v_deleted_at is not null, 'remove_client should set appointment deleted_at';
  assert v_deleted_by = owner_id, 'remove_client should set appointment deleted_by';

  -- Clients: insert with another business's id fails.
  begin
    insert into public.clients (business_id, full_name, phone)
    values (other_biz_id, 'Sneaky Client', '+13015550999');
    raise exception 'insert client for another business should fail';
  exception
    when insufficient_privilege then null;
    when sqlstate '42501' then null;
  end;

  -- delete from clients fails for authenticated.
  begin
    delete from public.clients where id = qd_client_id;
    raise exception 'delete from clients should fail';
  exception
    when insufficient_privilege then null;
    when sqlstate '42501' then null;
  end;

  -- Updating deleted_at directly fails; remove_client sets it and deleted_by.
  begin
    update public.clients
    set deleted_at = now()
    where id = qd_client_id;
    raise exception 'direct deleted_at update should fail';
  exception
    when insufficient_privilege then null;
    when sqlstate '42501' then null;
  end;

  perform public.remove_client(qd_client_id);
  select deleted_at, deleted_by into v_deleted_at, v_deleted_by
  from public.clients
  where id = qd_client_id;
  assert v_deleted_at is not null, 'remove_client should set deleted_at';
  assert v_deleted_by = owner_id, 'remove_client should set deleted_by to caller';

  -- Updating a removed client changes no rows.
  update public.clients
  set full_name = 'Should Not Stick'
  where id = qd_client_id;
  get diagnostics v_count = row_count;
  assert v_count = 0, 'updating a removed client should change no rows';
  assert (select full_name from public.clients where id = qd_client_id) = 'Ana Melgar',
    'removed client name should be unchanged';

  -- remove_client on another business's client, or an already removed one, raises Q0040.
  begin
    perform public.remove_client(other_client_id);
    raise exception 'remove_client on another business should fail';
  exception
    when sqlstate 'Q0040' then null;
  end;

  begin
    perform public.remove_client(qd_removed_id);
    raise exception 'remove_client on already removed should fail';
  exception
    when sqlstate 'Q0040' then null;
  end;

  begin
    perform public.remove_client(qd_client_id);
    raise exception 'remove_client on just-removed should fail';
  exception
    when sqlstate 'Q0040' then null;
  end;

  -- Check constraints reject a bad row.
  begin
    insert into public.clients (full_name)
    values ('No Phone Or Email');
    raise exception 'client without phone and email should fail';
  exception
    when check_violation then null;
  end;

  begin
    insert into public.clients (full_name, phone, city)
    values ('Partial Address', '+13015550888', 'Bowie');
    raise exception 'partial address should fail';
  exception
    when check_violation then null;
  end;

  begin
    insert into public.clients (full_name, phone, street, city, state, zip)
    values ('Bad State', '+13015550887', '1 Oak St', 'Bowie', 'md', '20715');
    raise exception 'lowercase state should fail';
  exception
    when check_violation then null;
  end;

  begin
    insert into public.clients (full_name, phone, street, city, state, zip)
    values ('Bad Zip', '+13015550886', '1 Oak St', 'Bowie', 'MD', '207');
    raise exception 'short zip should fail';
  exception
    when check_violation then null;
  end;

  -- Direct writes from authenticated fail.
  begin
    insert into public.memberships (user_id, business_id, role)
    values (crew_id, qd_id, 'member');
    raise exception 'direct membership insert should fail';
  exception
    when insufficient_privilege then null;
    when sqlstate '42501' then null;
  end;

  begin
    update public.memberships set role = 'owner' where user_id = owner_id;
    raise exception 'direct membership update should fail';
  exception
    when insufficient_privilege then null;
    when sqlstate '42501' then null;
  end;

  begin
    delete from public.memberships where user_id = owner_id;
    raise exception 'direct membership delete should fail';
  exception
    when insufficient_privilege then null;
    when sqlstate '42501' then null;
  end;

  begin
    insert into public.invites (business_id, code, created_by, expires_at)
    values (qd_id, 'HHHHHHHH', owner_id, now() + interval '7 days');
    raise exception 'direct invite insert should fail';
  exception
    when insufficient_privilege then null;
    when sqlstate '42501' then null;
  end;

  -- anon sees zero rows / has no access.
  perform set_config('role', 'anon', true);
  begin
    select count(*) into v_count from public.users;
    assert v_count = 0, 'anon should see 0 users if select is granted';
  exception
    when insufficient_privilege then null;
    when sqlstate '42501' then null;
  end;

  begin
    select count(*) into v_count from public.businesses;
    assert v_count = 0, 'anon should see 0 businesses if select is granted';
  exception
    when insufficient_privilege then null;
    when sqlstate '42501' then null;
  end;

  begin
    select count(*) into v_count from public.memberships;
    assert v_count = 0, 'anon should see 0 memberships if select is granted';
  exception
    when insufficient_privilege then null;
    when sqlstate '42501' then null;
  end;

  begin
    select count(*) into v_count from public.invites;
    assert v_count = 0, 'anon should see 0 invites if select is granted';
  exception
    when insufficient_privilege then null;
    when sqlstate '42501' then null;
  end;

  begin
    select count(*) into v_count from public.clients;
    assert v_count = 0, 'anon should see 0 clients if select is granted';
  exception
    when insufficient_privilege then null;
    when sqlstate '42501' then null;
  end;

  begin
    select count(*) into v_count from public.appointments;
    assert v_count = 0, 'anon should see 0 appointments if select is granted';
  exception
    when insufficient_privilege then null;
    when sqlstate '42501' then null;
  end;

  begin
    select count(*) into v_count from public.client_rows;
    assert v_count = 0, 'anon should see 0 client_rows if select is granted';
  exception
    when insufficient_privilege then null;
    when sqlstate '42501' then null;
  end;

  begin
    select count(*) into v_count from public.pricing_settings;
    assert v_count = 0, 'anon should see 0 pricing_settings if select is granted';
  exception
    when insufficient_privilege then null;
    when sqlstate '42501' then null;
  end;

  begin
    select count(*) into v_count from public.price_items;
    assert v_count = 0, 'anon should see 0 price_items if select is granted';
  exception
    when insufficient_privilege then null;
    when sqlstate '42501' then null;
  end;

  raise notice 'rls_check: all assertions passed';

  perform set_config('role', 'postgres', true);
end;
$assert$;

drop function public._test_as_user(uuid);

rollback;
