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
  qd_project_id uuid := '00000000-0000-4000-8000-000000000401';
  qd_james_project uuid := '00000000-0000-4000-8000-000000000403';
  qd_priya_project uuid := '00000000-0000-4000-8000-000000000405';
  qd_removed_client_project uuid := '00000000-0000-4000-8000-000000000406';
  qd_archived_id uuid := '00000000-0000-4000-8000-000000000426';
  other_project_id uuid := '00000000-0000-4000-8000-000000000441';
  qd_job_id uuid := '00000000-0000-4000-8000-000000000501';
  qd_job_no_labor uuid := '00000000-0000-4000-8000-000000000503';
  qd_archived_job uuid := '00000000-0000-4000-8000-000000000510';
  other_job_id uuid := '00000000-0000-4000-8000-000000000511';
  qd_line_id uuid := '00000000-0000-4000-8000-000000000601';
  qd_custom_line uuid := '00000000-0000-4000-8000-000000000603';
  qd_deleted_item_line uuid := '00000000-0000-4000-8000-000000000606';
  other_line_id uuid := '00000000-0000-4000-8000-000000000640';
  qd_composite_item uuid := '00000000-0000-4000-8000-000000000305';
  v_count int;
  v_id uuid;
  v_id2 uuid;
  v_labor bigint;
  v_overhead int;
  v_total bigint;
  v_name text;
  v_desc text;
  v_type public.pricing_type;
  v_price bigint;
  v_qty numeric;
  v_item_id uuid;
  v_rate bigint;
  v_hours numeric;
  v_positions uuid[];
  v_role public.user_role;
  v_session_id uuid;
  v_deleted_at timestamptz;
  v_deleted_by uuid;
  v_appt_id uuid;
  v_archived_at timestamptz;
  v_archived_by uuid;
  v_title text;
  v_removed boolean;
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
  assert v_count = 33, 'owner should see 33 Quality Deck price items';
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

  -- Projects / project_rows: isolation, RPCs, constraints, no direct writes.
  perform public._test_as_user(other_id);
  select count(*) into v_count from public.projects;
  assert v_count = 2, 'Other Co should see only its own projects';
  assert not exists (
    select 1 from public.projects
    where id in (
      qd_project_id, qd_james_project, qd_priya_project,
      qd_removed_client_project, qd_archived_id
    )
  ), 'Other Co must not see Quality Deck projects';
  select count(*) into v_count from public.project_rows;
  assert v_count = 2, 'Other Co should see only its own project_rows';
  assert not exists (
    select 1 from public.project_rows where id = qd_project_id
  ), 'Other Co must not see Quality Deck project_rows';
  begin
    perform public.archive_project(qd_project_id);
    raise exception 'archive_project on another business should fail';
  exception
    when sqlstate 'Q0070' then null;
  end;
  begin
    perform public.unarchive_project(qd_project_id);
    raise exception 'unarchive_project on another business should fail';
  exception
    when sqlstate 'Q0070' then null;
  end;
  begin
    perform public.create_project(
      qd_client_id, 'Sneaky', '1 Oak St', 'Bowie', 'MD', '20715'
    );
    raise exception 'create_project for another business client should fail';
  exception
    when sqlstate 'Q0040' then null;
  end;

  perform public._test_as_user(owner_id);
  select count(*) into v_count from public.projects;
  assert v_count = 30, 'owner should see 25 active + 5 archived Quality Deck projects';
  assert not exists (
    select 1 from public.projects where id = other_project_id
  ), 'owner must not see Other Co projects';
  select count(*) into v_count from public.project_rows;
  assert v_count = 30, 'owner should see 30 project_rows';

  assert (
    select client_name from public.project_rows where id = qd_project_id
  ) = 'Ana Melgar', 'project_rows should show the client name';
  assert (
    select client_removed from public.project_rows
    where id = qd_removed_client_project
  ) is true, 'project_rows should mark a removed client';
  assert (
    select appointment_starts_at from public.project_rows
    where id = qd_james_project
  ) is not null, 'James''s project should show his active appointment';
  assert (
    select appointment_starts_at from public.project_rows
    where id = qd_priya_project
  ) is null, 'Priya''s removed appointment must not appear on project_rows';
  assert (
    select appointment_starts_at from public.project_rows
    where id = qd_removed_client_project
  ) is null, 'a removed client''s project should have no appointment';

  begin
    perform public.create_project(
      other_client_id, 'No', '1 Oak St', 'Bowie', 'MD', '20715'
    );
    raise exception 'create_project for another business client should fail';
  exception
    when sqlstate 'Q0040' then null;
  end;

  begin
    perform public.create_project(
      qd_removed_id, 'No', '1 Oak St', 'Bowie', 'MD', '20715'
    );
    raise exception 'create_project for a removed client should fail';
  exception
    when sqlstate 'Q0040' then null;
  end;

  begin
    insert into public.projects (
      client_id, title, site_street, site_city, site_state, site_zip
    ) values (
      qd_client_megan, 'Direct', '1 Oak St', 'Bowie', 'MD', '20715'
    );
    raise exception 'direct project insert should fail';
  exception
    when insufficient_privilege then null;
    when sqlstate '42501' then null;
  end;

  begin
    update public.projects set title = 'Hacked' where id = qd_project_id;
    raise exception 'direct project update should fail';
  exception
    when insufficient_privilege then null;
    when sqlstate '42501' then null;
  end;

  begin
    delete from public.projects where id = qd_project_id;
    raise exception 'direct project delete should fail';
  exception
    when insufficient_privilege then null;
    when sqlstate '42501' then null;
  end;

  v_id := public.create_project(
    qd_client_megan, '  Megan – 9 Test St  ', '  9 Test St  ', '  Bowie  ',
    'md', '20715'
  );
  assert v_id is not null, 'create_project should return an id';
  select title into v_title from public.projects where id = v_id;
  assert v_title = 'Megan – 9 Test St', 'create_project should trim the title';
  assert (
    select site_state from public.projects where id = v_id
  ) = 'MD', 'create_project should upper-case the state';
  assert (
    select archived_at from public.projects where id = v_id
  ) is null, 'a new project should be active';

  perform public.archive_project(v_id);
  select archived_at, archived_by into v_archived_at, v_archived_by
  from public.projects
  where id = v_id;
  assert v_archived_at is not null, 'archive_project should set archived_at';
  assert v_archived_by = owner_id, 'archive_project should set archived_by';

  begin
    perform public.archive_project(v_id);
    raise exception 'second archive_project should fail';
  exception
    when sqlstate 'Q0071' then null;
  end;

  perform public.unarchive_project(v_id);
  select archived_at, archived_by into v_archived_at, v_archived_by
  from public.projects
  where id = v_id;
  assert v_archived_at is null, 'unarchive_project should clear archived_at';
  assert v_archived_by is null, 'unarchive_project should clear archived_by';

  begin
    perform public.unarchive_project(v_id);
    raise exception 'second unarchive_project should fail';
  exception
    when sqlstate 'Q0072' then null;
  end;

  begin
    perform public.create_project(
      qd_client_megan, '   ', '1 Oak St', 'Bowie', 'MD', '20715'
    );
    raise exception 'blank title should fail';
  exception
    when check_violation then null;
  end;

  begin
    perform public.create_project(
      qd_client_megan, 'No Street', '', 'Bowie', 'MD', '20715'
    );
    raise exception 'missing site street should fail';
  exception
    when check_violation then null;
  end;

  begin
    perform public.create_project(
      qd_client_megan, 'Bad State', '1 Oak St', 'Bowie', 'M', '20715'
    );
    raise exception 'bad state should fail';
  exception
    when check_violation then null;
  end;

  begin
    perform public.create_project(
      qd_client_megan, 'Bad Zip', '1 Oak St', 'Bowie', 'MD', '207'
    );
    raise exception 'bad zip should fail';
  exception
    when check_violation then null;
  end;

  -- Jobs / line items: isolation, RPCs, copied prices, totals, labor, overhead.
  perform public._test_as_user(other_id);
  select count(*) into v_count from public.jobs;
  assert v_count = 1, 'Other Co should see only its own job';
  assert not exists (select 1 from public.jobs where id = qd_job_id),
    'Other Co must not see Quality Deck jobs';
  select count(*) into v_count from public.line_items;
  assert v_count = 2, 'Other Co should see only its own line items';
  assert not exists (select 1 from public.line_items where id = qd_line_id),
    'Other Co must not see Quality Deck line items';

  begin
    insert into public.jobs (project_id, title, job_type)
    values (qd_project_id, 'Sneaky', 'deck');
    raise exception 'Other Co insert into Quality Deck jobs should fail';
  exception
    when insufficient_privilege then null;
    when sqlstate '42501' then null;
  end;

  update public.jobs set title = 'Hacked' where id = qd_job_id;
  get diagnostics v_count = row_count;
  assert v_count = 0, 'Other Co must not update Quality Deck jobs';

  delete from public.jobs where id = qd_job_id;
  get diagnostics v_count = row_count;
  assert v_count = 0, 'Other Co must not delete Quality Deck jobs';

  begin
    perform public.add_custom_line(
      qd_job_id, 'Nope', null, 'fixed', 1, 100
    );
    raise exception 'Other Co add_custom_line on Quality Deck should fail';
  exception
    when sqlstate 'Q0074' then null;
  end;

  begin
    perform public.update_line(qd_line_id, 10, null, null, null, null, null);
    raise exception 'Other Co update_line on Quality Deck should fail';
  exception
    when sqlstate 'Q0075' then null;
  end;

  begin
    perform public.reorder_lines(qd_job_id, array[qd_line_id]);
    raise exception 'Other Co reorder_lines on Quality Deck should fail';
  exception
    when sqlstate 'Q0074' then null;
  end;

  begin
    perform public.delete_line(qd_line_id);
    raise exception 'Other Co delete_line on Quality Deck should fail';
  exception
    when sqlstate 'Q0075' then null;
  end;

  begin
    perform public.add_price_list_line(other_job_id, qd_item_id, 1);
    raise exception 'add_price_list_line with another business item should fail';
  exception
    when sqlstate 'Q0060' then null;
  end;

  perform public._test_as_user(owner_id);
  select count(*) into v_count from public.jobs;
  assert v_count = 10, 'owner should see 10 Quality Deck jobs';
  assert not exists (select 1 from public.jobs where id = other_job_id),
    'owner must not see Other Co jobs';
  assert not exists (select 1 from public.line_items where id = other_line_id),
    'owner must not see Other Co line items';

  -- Archived project: writes raise Q0073; after unarchive they work.
  begin
    insert into public.jobs (project_id, title, job_type)
    values (qd_archived_id, 'No', 'deck');
    get diagnostics v_count = row_count;
    if v_count > 0 then
      raise exception 'insert job on archived project should change no rows';
    end if;
  exception
    when insufficient_privilege then null;
    when sqlstate '42501' then null;
  end;

  update public.jobs set title = 'No' where id = qd_archived_job;
  get diagnostics v_count = row_count;
  assert v_count = 0, 'update job on archived project should change no rows';

  delete from public.jobs where id = qd_archived_job;
  get diagnostics v_count = row_count;
  assert v_count = 0, 'delete job on archived project should change no rows';

  begin
    perform public.add_custom_line(
      qd_archived_job, 'No', null, 'fixed', 1, 100
    );
    raise exception 'add_custom_line on archived should fail';
  exception
    when sqlstate 'Q0073' then null;
  end;

  begin
    perform public.update_line(
      '00000000-0000-4000-8000-000000000635',
      10, null, null, null, null, null
    );
    raise exception 'update_line on archived should fail';
  exception
    when sqlstate 'Q0073' then null;
  end;

  begin
    perform public.reorder_lines(
      qd_archived_job,
      array[
        '00000000-0000-4000-8000-000000000635'::uuid,
        '00000000-0000-4000-8000-000000000636'::uuid,
        '00000000-0000-4000-8000-000000000637'::uuid
      ]
    );
    raise exception 'reorder_lines on archived should fail';
  exception
    when sqlstate 'Q0073' then null;
  end;

  begin
    perform public.delete_line('00000000-0000-4000-8000-000000000637');
    raise exception 'delete_line on archived should fail';
  exception
    when sqlstate 'Q0073' then null;
  end;

  begin
    perform public.update_project(
      qd_archived_id, 'No', '1 Oak St', 'Bowie', 'MD', '20715'
    );
    raise exception 'update_project on archived should fail';
  exception
    when sqlstate 'Q0073' then null;
  end;

  begin
    perform public.set_project_overhead(qd_archived_id, 1000);
    raise exception 'set_project_overhead on archived should fail';
  exception
    when sqlstate 'Q0073' then null;
  end;

  perform public.unarchive_project(qd_archived_id);
  v_id := public.add_custom_line(
    qd_archived_job, 'Temp', null, 'fixed', 1, 100
  );
  assert v_id is not null, 'add_custom_line after unarchive should succeed';
  perform public.delete_line(v_id);
  perform public.archive_project(qd_archived_id);

  -- Direct insert / update / delete on line_items fails.
  begin
    insert into public.line_items (
      job_id, position, is_custom, name, pricing_type, quantity, saved_price_cents
    ) values (
      qd_job_id, 99, true, 'Direct', 'fixed', 1, 100
    );
    raise exception 'direct line_items insert should fail';
  exception
    when insufficient_privilege then null;
    when sqlstate '42501' then null;
  end;

  begin
    update public.line_items set name = 'Hacked' where id = qd_line_id;
    raise exception 'direct line_items update should fail';
  exception
    when insufficient_privilege then null;
    when sqlstate '42501' then null;
  end;

  begin
    delete from public.line_items where id = qd_custom_line;
    raise exception 'direct line_items delete should fail';
  exception
    when insufficient_privilege then null;
    when sqlstate '42501' then null;
  end;

  -- add_price_list_line copies; later edits / deletes leave the line.
  v_id := public.add_price_list_line(qd_job_no_labor, qd_composite_item, 10);
  select name, description, pricing_type, saved_price_cents, quantity, price_item_id
  into v_name, v_desc, v_type, v_price, v_qty, v_item_id
  from public.line_items
  where id = v_id;
  assert v_name = 'New Composite Deck - Trex Enhance or Select', 'copied name';
  assert v_desc is not null, 'copied description';
  assert v_type = 'per_sq_ft', 'copied pricing type';
  assert v_price = 9500, 'copied price';
  assert v_qty = 10, 'quantity stored';
  assert v_item_id = qd_composite_item, 'price_item_id set';

  update public.price_items
  set name = 'Changed', description = 'Changed', price_cents = 999
  where id = qd_composite_item;
  select name, description, saved_price_cents
  into v_name, v_desc, v_price
  from public.line_items
  where id = v_id;
  assert v_name = 'New Composite Deck - Trex Enhance or Select', 'editing a price item must not change the line name';
  assert v_desc is distinct from 'Changed', 'editing a price item must not change the line description';
  assert v_price = 9500, 'editing a price item must not change the saved price';

  delete from public.price_items where id = qd_composite_item;
  select name, saved_price_cents, price_item_id
  into v_name, v_price, v_item_id
  from public.line_items
  where id = v_id;
  assert v_name = 'New Composite Deck - Trex Enhance or Select', 'deleting a price item must not change the line name';
  assert v_price = 9500, 'deleting a price item must not change the saved price';
  assert v_item_id is null, 'deleting a price item should set price_item_id to null';

  -- Seeded line whose item was deleted already has a null price_item_id.
  assert (
    select price_item_id from public.line_items where id = qd_deleted_item_line
  ) is null, 'seeded deleted-item line should have a null price_item_id';
  assert (
    select name from public.line_items where id = qd_deleted_item_line
  ) = 'Old fascia', 'seeded deleted-item line should keep its copied name';

  -- Restore the composite item so later assertions about the catalog
  -- are not needed; this script rolls back anyway.
  insert into public.price_items (
    id, name, description, pricing_type, price_cents
  ) values (
    qd_composite_item,
    'New Composite Deck - Trex Enhance or Select',
    'restored',
    'per_sq_ft',
    9500
  );

  -- Fixed lines always have quantity 1.
  v_id := public.add_price_list_line(
    qd_job_no_labor, '00000000-0000-4000-8000-000000000306', 99
  );
  assert (
    select quantity from public.line_items where id = v_id
  ) = 1, 'fixed price-list line quantity should be 1';
  v_id2 := public.add_custom_line(
    qd_job_no_labor, 'Fixed custom', null, 'fixed', 50, 1000
  );
  assert (
    select quantity from public.line_items where id = v_id2
  ) = 1, 'fixed custom line quantity should be 1';

  -- update_line field_locked.
  begin
    perform public.update_line(
      qd_line_id, 192.5, null, null, 'New name', null, null
    );
    raise exception 'price-list update with a name should fail';
  exception
    when sqlstate 'Q0077' then null;
  end;

  begin
    perform public.update_line(
      qd_line_id, 192.5, null, null, null, 'fixed', null
    );
    raise exception 'price-list update with a type should fail';
  exception
    when sqlstate 'Q0077' then null;
  end;

  begin
    perform public.update_line(
      qd_line_id, 192.5, null, null, null, null, 100
    );
    raise exception 'price-list update with a price should fail';
  exception
    when sqlstate 'Q0077' then null;
  end;

  begin
    perform public.update_line(
      qd_custom_line, 1, null, 100, 'Haul-away', 'fixed', 25000
    );
    raise exception 'custom update with an override should fail';
  exception
    when sqlstate 'Q0077' then null;
  end;

  -- total_cents rounding cases.
  v_id := public.add_custom_line(
    qd_job_no_labor, 'A', null, 'per_sq_ft', 192.5, 450
  );
  assert (
    select total_cents from public.line_items where id = v_id
  ) = 86625, '192.5 × $4.50 should be $866.25';

  v_id := public.add_custom_line(
    qd_job_no_labor, 'B', null, 'per_unit', 3, 33
  );
  assert (
    select total_cents from public.line_items where id = v_id
  ) = 99, '3 × $0.33 should be $0.99';

  v_id := public.add_custom_line(
    qd_job_no_labor, 'C', null, 'per_unit', 1.25, 1
  );
  assert (
    select total_cents from public.line_items where id = v_id
  ) = 1, '1.25 × $0.01 should be $0.01';

  v_id := public.add_price_list_line(
    qd_job_no_labor, '00000000-0000-4000-8000-000000000301', 10
  );
  perform public.update_line(v_id, 10, null, 3000, null, null, null);
  assert (
    select total_cents from public.line_items where id = v_id
  ) = 30000, 'override price should be used in total_cents';

  -- reorder_lines mismatch changes nothing; a valid reorder sticks.
  select array_agg(id order by position) into v_positions
  from public.line_items
  where job_id = qd_job_id;

  begin
    perform public.reorder_lines(qd_job_id, v_positions[1:2]);
    raise exception 'reorder with a missing id should fail';
  exception
    when sqlstate 'Q0078' then null;
  end;

  begin
    perform public.reorder_lines(
      qd_job_id, v_positions || other_line_id
    );
    raise exception 'reorder with an extra id should fail';
  exception
    when sqlstate 'Q0078' then null;
  end;

  begin
    perform public.reorder_lines(
      qd_job_id,
      array[other_line_id] || v_positions[2:cardinality(v_positions)]
    );
    raise exception 'reorder with a foreign id should fail';
  exception
    when sqlstate 'Q0078' then null;
  end;

  assert (
    select array_agg(id order by position)
    from public.line_items
    where job_id = qd_job_id
  ) = v_positions, 'failed reorder should change nothing';

  perform public.reorder_lines(
    qd_job_id,
    array[v_positions[cardinality(v_positions)]]
      || v_positions[1:cardinality(v_positions) - 1]
  );
  assert (
    select id from public.line_items
    where job_id = qd_job_id and position = 0
  ) = v_positions[cardinality(v_positions)], 'valid reorder should stick';

  -- Deleting a job deletes its lines.
  insert into public.jobs (project_id, title, job_type)
  values (qd_priya_project, 'To delete', 'deck')
  returning id into v_id;
  perform public.add_custom_line(v_id, 'Gone', null, 'fixed', 1, 100);
  delete from public.jobs where id = v_id;
  assert not exists (select 1 from public.jobs where id = v_id),
    'job delete should remove the job';
  assert not exists (select 1 from public.line_items where job_id = v_id),
    'deleting a job should delete its lines';

  -- Labor pair and labor_total_cents.
  begin
    update public.jobs set labor_hours = 1 where id = qd_job_no_labor;
    raise exception 'setting only labor_hours should fail';
  exception
    when check_violation then null;
  end;

  begin
    update public.jobs set labor_rate_cents = 6500 where id = qd_job_no_labor;
    raise exception 'setting only labor_rate_cents should fail';
  exception
    when check_violation then null;
  end;

  update public.jobs
  set labor_hours = 12.5, labor_rate_cents = 6500
  where id = qd_job_no_labor;
  assert (
    select labor_total_cents from public.jobs where id = qd_job_no_labor
  ) = 81250, '12.5 hrs × $65.00 should be $812.50';

  -- set_project_overhead.
  perform public.set_project_overhead(qd_priya_project, 1250);
  assert (
    select overhead_bps from public.projects where id = qd_priya_project
  ) = 1250, 'set_project_overhead should store the value';
  perform public.set_project_overhead(qd_priya_project, null);
  assert (
    select overhead_bps from public.projects where id = qd_priya_project
  ) is null, 'set_project_overhead null should clear the value';

  begin
    perform public.set_project_overhead(qd_priya_project, 10001);
    raise exception 'overhead 10001 should fail';
  exception
    when sqlstate 'Q0079' then null;
  end;

  -- Changing pricing_settings leaves copied labor and overhead.
  select labor_rate_cents into v_rate
  from public.jobs where id = qd_job_id;
  select overhead_bps into v_overhead
  from public.projects where id = qd_project_id;
  update public.pricing_settings
  set labor_rate_cents = 8000, overhead_bps = 2000;
  assert (
    select labor_rate_cents from public.jobs where id = qd_job_id
  ) = v_rate, 'changing the business labor rate must not change a job';
  assert (
    select overhead_bps from public.projects where id = qd_project_id
  ) = v_overhead, 'changing the business overhead must not change a project';

  -- update_project.
  perform public.update_project(
    qd_priya_project, '  Shah updated  ', '  9 Test St  ', '  Laurel  ',
    'md', '20707'
  );
  assert (
    select title from public.projects where id = qd_priya_project
  ) = 'Shah updated', 'update_project should trim the title';
  assert (
    select site_state from public.projects where id = qd_priya_project
  ) = 'MD', 'update_project should upper-case the state';

  -- After Ana is removed, her projects stay and are marked (removed),
  -- with no appointment (remove_client also removes it).
  assert (
    select client_removed from public.project_rows where id = qd_project_id
  ) is true, 'a removed client''s project should stay and mark client_removed';
  assert (
    select appointment_starts_at from public.project_rows
    where id = qd_project_id
  ) is null, 'a removed client''s appointment should not appear on project_rows';

  -- job_photos: members of the business can read/write; 10-per-kind limit.
  perform public._test_as_user(owner_id);

  insert into public.job_photos (
    job_id, kind, storage_path, width, height
  ) values (
    qd_job_id, 'before',
    '00000000-0000-4000-8000-000000000011/' || qd_job_id || '/rls-before.jpg',
    100, 80
  );

  assert (
    select count(*) from public.job_photos where job_id = qd_job_id
  ) = 1, 'owner should see the job photo they inserted';

  perform public._test_as_user(other_id);
  assert (
    select count(*) from public.job_photos
  ) = 0, 'other business should see 0 job_photos';

  begin
    insert into public.job_photos (
      job_id, kind, storage_path, width, height
    ) values (
      qd_job_id, 'before',
      'other/rls.jpg', 10, 10
    );
    assert false, 'other business should not insert a Quality Deck photo';
  exception
    when sqlstate '42501' then null;
    when insufficient_privilege then null;
  end;

  perform public._test_as_user(owner_id);
  for v_count in 2..10 loop
    insert into public.job_photos (
      job_id, kind, storage_path, width, height
    ) values (
      qd_job_id, 'before',
      '00000000-0000-4000-8000-000000000011/' || qd_job_id || '/rls-' || v_count || '.jpg',
      100, 80
    );
  end loop;

  begin
    insert into public.job_photos (
      job_id, kind, storage_path, width, height
    ) values (
      qd_job_id, 'before',
      '00000000-0000-4000-8000-000000000011/' || qd_job_id || '/rls-11.jpg',
      100, 80
    );
    assert false, 'an 11th before photo should be rejected';
  exception
    when sqlstate 'Q0080' then null;
  end;

  insert into public.jobs (project_id, title, job_type)
  values (qd_project_id, 'Photo cascade', 'deck')
  returning id into v_id;

  insert into public.job_photos (
    job_id, kind, storage_path, width, height
  ) values (
    v_id, 'after',
    '00000000-0000-4000-8000-000000000011/' || v_id || '/cascade.jpg',
    10, 10
  );

  delete from public.jobs where id = v_id;
  assert not exists (
    select 1 from public.job_photos where job_id = v_id
  ), 'deleting a job should delete its photos';

  -- proposal_exports: members can read their business's rows only.
  perform set_config('role', 'postgres', true);
  insert into public.proposal_exports (
    business_id, project_id, version, proposal_number, storage_path,
    total_cents, created_by
  ) values (
    qd_id,
    qd_project_id,
    1,
    'QD-2026-0001',
    '00000000-0000-4000-8000-000000000011/' || qd_project_id || '/v1-rls.pdf',
    1000,
    owner_id
  );

  perform public._test_as_user(owner_id);
  assert (
    select count(*) from public.proposal_exports
  ) = 1, 'owner should see their proposal export';

  perform public._test_as_user(other_id);
  assert (
    select count(*) from public.proposal_exports
  ) = 0, 'other business should see 0 proposal_exports';

  begin
    perform public.next_proposal_export(qd_project_id);
    assert false, 'authenticated should not call next_proposal_export';
  exception
    when insufficient_privilege then null;
    when sqlstate '42501' then null;
  end;

  perform set_config('role', 'postgres', true);
  select pe.version into v_count
  from public.next_proposal_export(qd_project_id) as pe;
  assert v_count = 2, 'next export version should be 2 after an existing row';

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

  begin
    select count(*) into v_count from public.projects;
    assert v_count = 0, 'anon should see 0 projects if select is granted';
  exception
    when insufficient_privilege then null;
    when sqlstate '42501' then null;
  end;

  begin
    select count(*) into v_count from public.project_rows;
    assert v_count = 0, 'anon should see 0 project_rows if select is granted';
  exception
    when insufficient_privilege then null;
    when sqlstate '42501' then null;
  end;

  begin
    select count(*) into v_count from public.jobs;
    assert v_count = 0, 'anon should see 0 jobs if select is granted';
  exception
    when insufficient_privilege then null;
    when sqlstate '42501' then null;
  end;

  begin
    select count(*) into v_count from public.line_items;
    assert v_count = 0, 'anon should see 0 line_items if select is granted';
  exception
    when insufficient_privilege then null;
    when sqlstate '42501' then null;
  end;

  begin
    select count(*) into v_count from public.job_photos;
    assert v_count = 0, 'anon should see 0 job_photos if select is granted';
  exception
    when insufficient_privilege then null;
    when sqlstate '42501' then null;
  end;

  begin
    select count(*) into v_count from public.proposal_exports;
    assert v_count = 0, 'anon should see 0 proposal_exports if select is granted';
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
