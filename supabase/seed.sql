-- Seeded accounts (passwords documented in the README):
--   owner@qualitydeck.test   / password123   Quality Deck owner (Moises (dev))
--   crew@qualitydeck.test    / password123   Quality Deck member
--   other@example.test       / password123   Other Co owner (isolation)
--   nobusiness@example.test  / password123   signed up, no membership
--   joiner@example.test      / password123   signed up, no membership (RLS redeem tests)
--
-- Invite codes for Quality Deck:
--   QDACTIVE  active
--   QDEXPIRD  expired
--   QDUSED22  used
--   QDREVOKD  revoked

create extension if not exists pgcrypto;

-- Fixed ids so tests can reference them.
-- users
--   owner      00000000-0000-4000-8000-000000000001
--   crew       00000000-0000-4000-8000-000000000002
--   other      00000000-0000-4000-8000-000000000003
--   nobusiness 00000000-0000-4000-8000-000000000004
--   joiner     00000000-0000-4000-8000-000000000005
-- businesses
--   Quality Deck 00000000-0000-4000-8000-000000000011
--   Other Co     00000000-0000-4000-8000-000000000012
-- invites
--   QDACTIVE 00000000-0000-4000-8000-000000000021
--   QDEXPIRD 00000000-0000-4000-8000-000000000022
--   QDUSED22 00000000-0000-4000-8000-000000000023
--   QDREVOKD 00000000-0000-4000-8000-000000000024

insert into auth.users (
  instance_id,
  id,
  aud,
  role,
  email,
  encrypted_password,
  email_confirmed_at,
  raw_app_meta_data,
  raw_user_meta_data,
  created_at,
  updated_at,
  confirmation_token,
  email_change,
  email_change_token_new,
  recovery_token,
  is_sso_user,
  is_anonymous
)
values
  (
    '00000000-0000-0000-0000-000000000000',
    '00000000-0000-4000-8000-000000000001',
    'authenticated',
    'authenticated',
    'owner@qualitydeck.test',
    crypt('password123', gen_salt('bf')),
    now(),
    '{"provider":"email","providers":["email"]}',
    '{"full_name":"Moises (dev)"}',
    now(),
    now(),
    '',
    '',
    '',
    '',
    false,
    false
  ),
  (
    '00000000-0000-0000-0000-000000000000',
    '00000000-0000-4000-8000-000000000002',
    'authenticated',
    'authenticated',
    'crew@qualitydeck.test',
    crypt('password123', gen_salt('bf')),
    now(),
    '{"provider":"email","providers":["email"]}',
    '{"full_name":"Crew Member"}',
    now(),
    now(),
    '',
    '',
    '',
    '',
    false,
    false
  ),
  (
    '00000000-0000-0000-0000-000000000000',
    '00000000-0000-4000-8000-000000000003',
    'authenticated',
    'authenticated',
    'other@example.test',
    crypt('password123', gen_salt('bf')),
    now(),
    '{"provider":"email","providers":["email"]}',
    '{"full_name":"Other Owner"}',
    now(),
    now(),
    '',
    '',
    '',
    '',
    false,
    false
  ),
  (
    '00000000-0000-0000-0000-000000000000',
    '00000000-0000-4000-8000-000000000004',
    'authenticated',
    'authenticated',
    'nobusiness@example.test',
    crypt('password123', gen_salt('bf')),
    now(),
    '{"provider":"email","providers":["email"]}',
    '{"full_name":"No Business"}',
    now(),
    now(),
    '',
    '',
    '',
    '',
    false,
    false
  ),
  (
    '00000000-0000-0000-0000-000000000000',
    '00000000-0000-4000-8000-000000000005',
    'authenticated',
    'authenticated',
    'joiner@example.test',
    crypt('password123', gen_salt('bf')),
    now(),
    '{"provider":"email","providers":["email"]}',
    '{"full_name":"Pending Joiner"}',
    now(),
    now(),
    '',
    '',
    '',
    '',
    false,
    false
  );

insert into auth.identities (
  user_id,
  provider_id,
  identity_data,
  provider,
  last_sign_in_at,
  created_at,
  updated_at
)
select
  id,
  email,
  jsonb_build_object('sub', id::text, 'email', email),
  'email',
  now(),
  now(),
  now()
from auth.users
where id in (
  '00000000-0000-4000-8000-000000000001',
  '00000000-0000-4000-8000-000000000002',
  '00000000-0000-4000-8000-000000000003',
  '00000000-0000-4000-8000-000000000004',
  '00000000-0000-4000-8000-000000000005'
);

insert into public.businesses (id, name, owner_id)
values
  (
    '00000000-0000-4000-8000-000000000011',
    'Quality Deck',
    '00000000-0000-4000-8000-000000000001'
  ),
  (
    '00000000-0000-4000-8000-000000000012',
    'Other Co',
    '00000000-0000-4000-8000-000000000003'
  );

insert into public.memberships (user_id, business_id, role)
values
  (
    '00000000-0000-4000-8000-000000000001',
    '00000000-0000-4000-8000-000000000011',
    'owner'
  ),
  (
    '00000000-0000-4000-8000-000000000002',
    '00000000-0000-4000-8000-000000000011',
    'member'
  ),
  (
    '00000000-0000-4000-8000-000000000003',
    '00000000-0000-4000-8000-000000000012',
    'owner'
  );

insert into public.invites (
  id, business_id, code, created_by, created_at, expires_at, used_at, used_by, revoked_at
)
values
  (
    '00000000-0000-4000-8000-000000000021',
    '00000000-0000-4000-8000-000000000011',
    'QDACTIVE',
    '00000000-0000-4000-8000-000000000001',
    now(),
    now() + interval '7 days',
    null,
    null,
    null
  ),
  (
    '00000000-0000-4000-8000-000000000022',
    '00000000-0000-4000-8000-000000000011',
    'QDEXPIRD',
    '00000000-0000-4000-8000-000000000001',
    now() - interval '8 days',
    now() - interval '1 day',
    null,
    null,
    null
  ),
  (
    '00000000-0000-4000-8000-000000000023',
    '00000000-0000-4000-8000-000000000011',
    'QDUSED22',
    '00000000-0000-4000-8000-000000000001',
    now() - interval '2 days',
    now() + interval '5 days',
    now() - interval '1 day',
    '00000000-0000-4000-8000-000000000002',
    null
  ),
  (
    '00000000-0000-4000-8000-000000000024',
    '00000000-0000-4000-8000-000000000011',
    'QDREVOKD',
    '00000000-0000-4000-8000-000000000001',
    now(),
    now() + interval '7 days',
    null,
    null,
    now() - interval '1 hour'
  );

-- ---------------------------------------------------------------------------
-- Clients
-- Quality Deck: 30 active (enough for three pages at 10/page) plus 2 removed.
-- Mix of phone-only, email-only, both, with and without an address.
-- Other Co: 3 clients for isolation checks.
--
-- ids
--   QD active  00000000-0000-4000-8000-000000000101 .. 130
--   QD removed 00000000-0000-4000-8000-000000000131, 132
--   Other Co   00000000-0000-4000-8000-000000000141, 142, 143
-- ---------------------------------------------------------------------------

insert into public.clients (
  id, business_id, full_name, email, phone, street, city, state, zip,
  last_activity_at, created_by, deleted_at, deleted_by
)
values
  -- Quality Deck active. last_activity_at is newest-first (row 1 is page 1).
  (
    '00000000-0000-4000-8000-000000000101',
    '00000000-0000-4000-8000-000000000011',
    'Ana Melgar', 'ana.melgar@example.test', '+13015550101',
    '12 Oak St', 'Bowie', 'MD', '20715',
    now() - interval '1 hour', '00000000-0000-4000-8000-000000000001',
    null, null
  ),
  (
    '00000000-0000-4000-8000-000000000102',
    '00000000-0000-4000-8000-000000000011',
    'James Whitaker', null, '+13015550102',
    null, null, null, null,
    now() - interval '2 hours', '00000000-0000-4000-8000-000000000001',
    null, null
  ),
  (
    '00000000-0000-4000-8000-000000000103',
    '00000000-0000-4000-8000-000000000011',
    'Priya Shah', 'priya.shah@example.test', null,
    null, null, null, null,
    now() - interval '3 hours', '00000000-0000-4000-8000-000000000001',
    null, null
  ),
  (
    '00000000-0000-4000-8000-000000000104',
    '00000000-0000-4000-8000-000000000011',
    'Luis Ortega', 'luis.ortega@example.test', '+13015550104',
    '88 Maple Ave', 'Laurel', 'MD', '20707',
    now() - interval '4 hours', '00000000-0000-4000-8000-000000000001',
    null, null
  ),
  (
    '00000000-0000-4000-8000-000000000105',
    '00000000-0000-4000-8000-000000000011',
    'Megan Brooks', 'megan.brooks@example.test', '+13015550105',
    null, null, null, null,
    now() - interval '5 hours', '00000000-0000-4000-8000-000000000001',
    null, null
  ),
  (
    '00000000-0000-4000-8000-000000000106',
    '00000000-0000-4000-8000-000000000011',
    'Chris Nguyen', null, '+13015550106',
    '4 Pine Rd', 'Crofton', 'MD', '21114',
    now() - interval '6 hours', '00000000-0000-4000-8000-000000000001',
    null, null
  ),
  (
    '00000000-0000-4000-8000-000000000107',
    '00000000-0000-4000-8000-000000000011',
    'Taylor Reed', 'taylor.reed@example.test', null,
    '21 Birch Ln', 'Bowie', 'MD', '20716',
    now() - interval '7 hours', '00000000-0000-4000-8000-000000000001',
    null, null
  ),
  (
    '00000000-0000-4000-8000-000000000108',
    '00000000-0000-4000-8000-000000000011',
    'Jordan Hale', 'jordan.hale@example.test', '+13015550108',
    '9 Cedar Ct', 'Greenbelt', 'MD', '20770',
    now() - interval '8 hours', '00000000-0000-4000-8000-000000000001',
    null, null
  ),
  (
    '00000000-0000-4000-8000-000000000109',
    '00000000-0000-4000-8000-000000000011',
    'Sam Patel', null, '+13015550109',
    null, null, null, null,
    now() - interval '9 hours', '00000000-0000-4000-8000-000000000001',
    null, null
  ),
  (
    '00000000-0000-4000-8000-000000000110',
    '00000000-0000-4000-8000-000000000011',
    'Riley Chen', 'riley.chen@example.test', null,
    null, null, null, null,
    now() - interval '10 hours', '00000000-0000-4000-8000-000000000001',
    null, null
  ),
  (
    '00000000-0000-4000-8000-000000000111',
    '00000000-0000-4000-8000-000000000011',
    'Avery Scott', 'avery.scott@example.test', '+13015550111',
    '15 Walnut St', 'Severna Park', 'MD', '21146',
    now() - interval '11 hours', '00000000-0000-4000-8000-000000000001',
    null, null
  ),
  (
    '00000000-0000-4000-8000-000000000112',
    '00000000-0000-4000-8000-000000000011',
    'Cameron Dale', null, '+13015550112',
    null, null, null, null,
    now() - interval '12 hours', '00000000-0000-4000-8000-000000000001',
    null, null
  ),
  (
    '00000000-0000-4000-8000-000000000113',
    '00000000-0000-4000-8000-000000000011',
    'Morgan Ellis', 'morgan.ellis@example.test', null,
    null, null, null, null,
    now() - interval '13 hours', '00000000-0000-4000-8000-000000000001',
    null, null
  ),
  (
    '00000000-0000-4000-8000-000000000114',
    '00000000-0000-4000-8000-000000000011',
    'Quinn Barker', 'quinn.barker@example.test', '+13015550114',
    null, null, null, null,
    now() - interval '14 hours', '00000000-0000-4000-8000-000000000001',
    null, null
  ),
  (
    '00000000-0000-4000-8000-000000000115',
    '00000000-0000-4000-8000-000000000011',
    'Harper Knox', null, '+13015550115',
    '77 Elm St', 'Annapolis', 'MD', '21401',
    now() - interval '15 hours', '00000000-0000-4000-8000-000000000001',
    null, null
  ),
  (
    '00000000-0000-4000-8000-000000000116',
    '00000000-0000-4000-8000-000000000011',
    'Drew Salazar', 'drew.salazar@example.test', '+13015550116',
    '3 Holly Way', 'Bowie', 'MD', '20720',
    now() - interval '16 hours', '00000000-0000-4000-8000-000000000001',
    null, null
  ),
  (
    '00000000-0000-4000-8000-000000000117',
    '00000000-0000-4000-8000-000000000011',
    'Jamie Cole', 'jamie.cole@example.test', null,
    '54 Spruce Dr', 'College Park', 'MD', '20740',
    now() - interval '17 hours', '00000000-0000-4000-8000-000000000001',
    null, null
  ),
  (
    '00000000-0000-4000-8000-000000000118',
    '00000000-0000-4000-8000-000000000011',
    'Alex Rivera', null, '+13015550118',
    null, null, null, null,
    now() - interval '18 hours', '00000000-0000-4000-8000-000000000001',
    null, null
  ),
  (
    '00000000-0000-4000-8000-000000000119',
    '00000000-0000-4000-8000-000000000011',
    'Casey Moon', 'casey.moon@example.test', '+13015550119',
    null, null, null, null,
    now() - interval '19 hours', '00000000-0000-4000-8000-000000000001',
    null, null
  ),
  (
    '00000000-0000-4000-8000-000000000120',
    '00000000-0000-4000-8000-000000000011',
    'Skyler Dunn', 'skyler.dunn@example.test', null,
    null, null, null, null,
    now() - interval '20 hours', '00000000-0000-4000-8000-000000000001',
    null, null
  ),
  (
    '00000000-0000-4000-8000-000000000121',
    '00000000-0000-4000-8000-000000000011',
    'Reese Alvarez', 'reese.alvarez@example.test', '+13015550121',
    '18 Poplar Ave', 'Hyattsville', 'MD', '20781',
    now() - interval '21 hours', '00000000-0000-4000-8000-000000000001',
    null, null
  ),
  (
    '00000000-0000-4000-8000-000000000122',
    '00000000-0000-4000-8000-000000000011',
    'Parker Singh', null, '+13015550122',
    '6 Ivy Pl', 'Bowie', 'MD', '20715',
    now() - interval '22 hours', '00000000-0000-4000-8000-000000000001',
    null, null
  ),
  (
    '00000000-0000-4000-8000-000000000123',
    '00000000-0000-4000-8000-000000000011',
    'Logan Bates', 'logan.bates@example.test', null,
    null, null, null, null,
    now() - interval '23 hours', '00000000-0000-4000-8000-000000000001',
    null, null
  ),
  (
    '00000000-0000-4000-8000-000000000124',
    '00000000-0000-4000-8000-000000000011',
    'Kendall Frost', 'kendall.frost@example.test', '+13015550124',
    '41 Ash Ct', 'Glenn Dale', 'MD', '20769',
    now() - interval '24 hours', '00000000-0000-4000-8000-000000000001',
    null, null
  ),
  (
    '00000000-0000-4000-8000-000000000125',
    '00000000-0000-4000-8000-000000000011',
    'Rowan Blake', null, '+13015550125',
    null, null, null, null,
    now() - interval '25 hours', '00000000-0000-4000-8000-000000000001',
    null, null
  ),
  (
    '00000000-0000-4000-8000-000000000126',
    '00000000-0000-4000-8000-000000000011',
    'Finley Ames', 'finley.ames@example.test', '+13015550126',
    null, null, null, null,
    now() - interval '26 hours', '00000000-0000-4000-8000-000000000001',
    null, null
  ),
  (
    '00000000-0000-4000-8000-000000000127',
    '00000000-0000-4000-8000-000000000011',
    'Hayden Cruz', 'hayden.cruz@example.test', null,
    '29 Magnolia Blvd', 'Odenton', 'MD', '21113',
    now() - interval '27 hours', '00000000-0000-4000-8000-000000000001',
    null, null
  ),
  (
    '00000000-0000-4000-8000-000000000128',
    '00000000-0000-4000-8000-000000000011',
    'Emerson Walsh', null, '+13015550128',
    '8 Dogwood Ter', 'Bowie', 'MD', '20721',
    now() - interval '28 hours', '00000000-0000-4000-8000-000000000001',
    null, null
  ),
  (
    '00000000-0000-4000-8000-000000000129',
    '00000000-0000-4000-8000-000000000011',
    'Peyton Brooks', 'peyton.brooks@example.test', '+13015550129',
    '102 Sycamore St', 'Upper Marlboro', 'MD', '20774',
    now() - interval '29 hours', '00000000-0000-4000-8000-000000000001',
    null, null
  ),
  (
    '00000000-0000-4000-8000-000000000130',
    '00000000-0000-4000-8000-000000000011',
    'Dakota Lane', 'dakota.lane@example.test', '+13015550130',
    null, null, null, null,
    now() - interval '30 hours', '00000000-0000-4000-8000-000000000001',
    null, null
  ),
  -- Quality Deck removed (hidden from the table, still readable by RLS)
  (
    '00000000-0000-4000-8000-000000000131',
    '00000000-0000-4000-8000-000000000011',
    'Old Client One', 'old.one@example.test', '+13015550901',
    '1 Retired Rd', 'Bowie', 'MD', '20715',
    now() - interval '40 hours', '00000000-0000-4000-8000-000000000001',
    now() - interval '2 hours', '00000000-0000-4000-8000-000000000001'
  ),
  (
    '00000000-0000-4000-8000-000000000132',
    '00000000-0000-4000-8000-000000000011',
    'Old Client Two', null, '+13015550902',
    null, null, null, null,
    now() - interval '41 hours', '00000000-0000-4000-8000-000000000001',
    now() - interval '3 hours', '00000000-0000-4000-8000-000000000001'
  ),
  -- Other Co
  (
    '00000000-0000-4000-8000-000000000141',
    '00000000-0000-4000-8000-000000000012',
    'Other Client A', 'other.a@example.test', '+12025550141',
    '10 Main St', 'Arlington', 'VA', '22201',
    now() - interval '1 hour', '00000000-0000-4000-8000-000000000003',
    null, null
  ),
  (
    '00000000-0000-4000-8000-000000000142',
    '00000000-0000-4000-8000-000000000012',
    'Other Client B', null, '+12025550142',
    null, null, null, null,
    now() - interval '2 hours', '00000000-0000-4000-8000-000000000003',
    null, null
  ),
  (
    '00000000-0000-4000-8000-000000000143',
    '00000000-0000-4000-8000-000000000012',
    'Other Client C', 'other.c@example.test', null,
    '5 King St', 'Alexandria', 'VA', '22314',
    now() - interval '3 hours', '00000000-0000-4000-8000-000000000003',
    null, null
  );

-- ---------------------------------------------------------------------------
-- Appointments
-- Quality Deck: upcoming (with notes), past, one removed, the rest none.
-- Other Co: one client with an appointment.
--
-- ids
--   QD upcoming  00000000-0000-4000-8000-000000000201  Ana Melgar
--   QD past      00000000-0000-4000-8000-000000000202  James Whitaker
--   QD removed   00000000-0000-4000-8000-000000000203  Priya Shah
--   Other Co     00000000-0000-4000-8000-000000000241  Other Client A
-- ---------------------------------------------------------------------------

insert into public.appointments (
  id, business_id, client_id, starts_at, duration_minutes, notes,
  created_by, deleted_at, deleted_by
)
values
  (
    '00000000-0000-4000-8000-000000000201',
    '00000000-0000-4000-8000-000000000011',
    '00000000-0000-4000-8000-000000000101',
    now() + interval '3 days',
    60,
    'Measure back deck',
    '00000000-0000-4000-8000-000000000001',
    null,
    null
  ),
  (
    '00000000-0000-4000-8000-000000000202',
    '00000000-0000-4000-8000-000000000011',
    '00000000-0000-4000-8000-000000000102',
    now() - interval '10 days',
    90,
    null,
    '00000000-0000-4000-8000-000000000001',
    null,
    null
  ),
  (
    '00000000-0000-4000-8000-000000000203',
    '00000000-0000-4000-8000-000000000011',
    '00000000-0000-4000-8000-000000000103',
    now() - interval '20 days',
    60,
    'Removed visit',
    '00000000-0000-4000-8000-000000000001',
    now() - interval '1 day',
    '00000000-0000-4000-8000-000000000001'
  ),
  (
    '00000000-0000-4000-8000-000000000241',
    '00000000-0000-4000-8000-000000000012',
    '00000000-0000-4000-8000-000000000141',
    now() + interval '2 days',
    60,
    null,
    '00000000-0000-4000-8000-000000000003',
    null,
    null
  );

-- ---------------------------------------------------------------------------
-- Pricing
-- Quality Deck: labor $65.00/hr, overhead 12.5%, 25 items (all five types;
-- about half with a description, including one long multi-line).
-- Other Co: settings not set, three items.
--
-- ids
--   QD items   00000000-0000-4000-8000-000000000301 .. 325
--   Other Co   00000000-0000-4000-8000-000000000341, 342, 343
-- ---------------------------------------------------------------------------

insert into public.pricing_settings (
  business_id, labor_rate_cents, overhead_bps, updated_by, updated_at
)
values
  (
    '00000000-0000-4000-8000-000000000011',
    6500,
    1250,
    '00000000-0000-4000-8000-000000000001',
    now() - interval '2 days'
  ),
  (
    '00000000-0000-4000-8000-000000000012',
    null,
    null,
    null,
    now()
  );

insert into public.price_items (
  id, business_id, name, description, pricing_type, price_cents,
  created_by, updated_at
)
values
  (
    '00000000-0000-4000-8000-000000000301',
    '00000000-0000-4000-8000-000000000011',
    'Aluminum railing',
    'Powder-coated, includes brackets',
    'per_linear_ft',
    3800,
    '00000000-0000-4000-8000-000000000001',
    now() - interval '1 day'
  ),
  (
    '00000000-0000-4000-8000-000000000302',
    '00000000-0000-4000-8000-000000000011',
    'Baluster',
    null,
    'per_unit',
    800,
    '00000000-0000-4000-8000-000000000001',
    now() - interval '2 days'
  ),
  (
    '00000000-0000-4000-8000-000000000303',
    '00000000-0000-4000-8000-000000000011',
    'Box step',
    'Built-in storage under the tread',
    'per_step',
    12000,
    '00000000-0000-4000-8000-000000000001',
    now() - interval '3 days'
  ),
  (
    '00000000-0000-4000-8000-000000000304',
    '00000000-0000-4000-8000-000000000011',
    'Cable railing',
    null,
    'per_linear_ft',
    5500,
    '00000000-0000-4000-8000-000000000001',
    now() - interval '4 days'
  ),
  (
    '00000000-0000-4000-8000-000000000305',
    '00000000-0000-4000-8000-000000000011',
    'Composite decking',
    E'Trex Enhance boards in the color selected on site,\nhidden fasteners, color-matched plugs, and waste factor.\n\nDoes not include railings, stairs, or permit fees.\nThose are listed separately.',
    'per_sq_ft',
    450,
    '00000000-0000-4000-8000-000000000001',
    now() - interval '5 days'
  ),
  (
    '00000000-0000-4000-8000-000000000306',
    '00000000-0000-4000-8000-000000000011',
    'Demo existing deck',
    'Haul-away included',
    'fixed',
    80000,
    '00000000-0000-4000-8000-000000000001',
    now() - interval '6 days'
  ),
  (
    '00000000-0000-4000-8000-000000000307',
    '00000000-0000-4000-8000-000000000011',
    'Design consult',
    null,
    'fixed',
    15000,
    '00000000-0000-4000-8000-000000000001',
    now() - interval '7 days'
  ),
  (
    '00000000-0000-4000-8000-000000000308',
    '00000000-0000-4000-8000-000000000011',
    'Dumpster rental',
    '10-yard, one week',
    'fixed',
    45000,
    '00000000-0000-4000-8000-000000000001',
    now() - interval '8 days'
  ),
  (
    '00000000-0000-4000-8000-000000000309',
    '00000000-0000-4000-8000-000000000011',
    'Fascia board',
    null,
    'per_linear_ft',
    600,
    '00000000-0000-4000-8000-000000000001',
    now() - interval '9 days'
  ),
  (
    '00000000-0000-4000-8000-000000000310',
    '00000000-0000-4000-8000-000000000011',
    'Landing step',
    null,
    'per_step',
    8500,
    '00000000-0000-4000-8000-000000000001',
    now() - interval '10 days'
  ),
  (
    '00000000-0000-4000-8000-000000000311',
    '00000000-0000-4000-8000-000000000011',
    'Lighting fixture',
    'Low-voltage post cap or riser light',
    'per_unit',
    4500,
    '00000000-0000-4000-8000-000000000001',
    now() - interval '11 days'
  ),
  (
    '00000000-0000-4000-8000-000000000312',
    '00000000-0000-4000-8000-000000000011',
    'Patio pavers',
    null,
    'per_sq_ft',
    800,
    '00000000-0000-4000-8000-000000000001',
    now() - interval '12 days'
  ),
  (
    '00000000-0000-4000-8000-000000000313',
    '00000000-0000-4000-8000-000000000011',
    'Permit filing',
    'County application and pickup',
    'fixed',
    35000,
    '00000000-0000-4000-8000-000000000001',
    now() - interval '13 days'
  ),
  (
    '00000000-0000-4000-8000-000000000314',
    '00000000-0000-4000-8000-000000000011',
    'Picture frame border',
    null,
    'per_linear_ft',
    1200,
    '00000000-0000-4000-8000-000000000001',
    now() - interval '14 days'
  ),
  (
    '00000000-0000-4000-8000-000000000315',
    '00000000-0000-4000-8000-000000000011',
    'Post cap',
    'Copper or composite',
    'per_unit',
    1500,
    '00000000-0000-4000-8000-000000000001',
    now() - interval '15 days'
  ),
  (
    '00000000-0000-4000-8000-000000000316',
    '00000000-0000-4000-8000-000000000011',
    'Post footing',
    null,
    'per_unit',
    8500,
    '00000000-0000-4000-8000-000000000001',
    now() - interval '16 days'
  ),
  (
    '00000000-0000-4000-8000-000000000317',
    '00000000-0000-4000-8000-000000000011',
    'Pressure-treated decking',
    'Ground-contact rated, includes fasteners',
    'per_sq_ft',
    325,
    '00000000-0000-4000-8000-000000000001',
    now() - interval '17 days'
  ),
  (
    '00000000-0000-4000-8000-000000000318',
    '00000000-0000-4000-8000-000000000011',
    'Site cleanup',
    null,
    'fixed',
    20000,
    '00000000-0000-4000-8000-000000000001',
    now() - interval '18 days'
  ),
  (
    '00000000-0000-4000-8000-000000000319',
    '00000000-0000-4000-8000-000000000011',
    'Stair lighting',
    'Riser-mounted LED',
    'per_step',
    4000,
    '00000000-0000-4000-8000-000000000001',
    now() - interval '19 days'
  ),
  (
    '00000000-0000-4000-8000-000000000320',
    '00000000-0000-4000-8000-000000000011',
    'Stair stringer',
    null,
    'per_linear_ft',
    2500,
    '00000000-0000-4000-8000-000000000001',
    now() - interval '20 days'
  ),
  (
    '00000000-0000-4000-8000-000000000321',
    '00000000-0000-4000-8000-000000000011',
    'Stair tread (composite)',
    'Includes riser and hidden fasteners',
    'per_step',
    9500,
    '00000000-0000-4000-8000-000000000001',
    now() - interval '21 days'
  ),
  (
    '00000000-0000-4000-8000-000000000322',
    '00000000-0000-4000-8000-000000000011',
    'Staining',
    null,
    'per_sq_ft',
    175,
    '00000000-0000-4000-8000-000000000001',
    now() - interval '22 days'
  ),
  (
    '00000000-0000-4000-8000-000000000323',
    '00000000-0000-4000-8000-000000000011',
    'Waterproof membrane',
    'Under-deck drainage, taped seams',
    'per_sq_ft',
    200,
    '00000000-0000-4000-8000-000000000001',
    now() - interval '23 days'
  ),
  (
    '00000000-0000-4000-8000-000000000324',
    '00000000-0000-4000-8000-000000000011',
    'Wrap-around step',
    null,
    'per_step',
    15000,
    '00000000-0000-4000-8000-000000000001',
    now() - interval '24 days'
  ),
  (
    '00000000-0000-4000-8000-000000000325',
    '00000000-0000-4000-8000-000000000011',
    'Ledger flashing',
    'Includes fasteners and hidden clips',
    'per_unit',
    2500,
    '00000000-0000-4000-8000-000000000001',
    now() - interval '25 days'
  ),
  -- Other Co
  (
    '00000000-0000-4000-8000-000000000341',
    '00000000-0000-4000-8000-000000000012',
    'Hourly labor',
    null,
    'fixed',
    7500,
    '00000000-0000-4000-8000-000000000003',
    now() - interval '1 day'
  ),
  (
    '00000000-0000-4000-8000-000000000342',
    '00000000-0000-4000-8000-000000000012',
    'Fence panel',
    '6-foot cedar',
    'per_unit',
    8500,
    '00000000-0000-4000-8000-000000000003',
    now() - interval '2 days'
  ),
  (
    '00000000-0000-4000-8000-000000000343',
    '00000000-0000-4000-8000-000000000012',
    'Sod',
    null,
    'per_sq_ft',
    85,
    '00000000-0000-4000-8000-000000000003',
    now() - interval '3 days'
  );

