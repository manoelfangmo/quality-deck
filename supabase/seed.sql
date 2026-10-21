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
-- Projects
-- Quality Deck: 25 active (enough for three pages at 10/page) plus 5 archived.
-- Two clients have two projects each (Ana, James). One project belongs to a
-- removed client. Mix of upcoming / past / no client appointment.
-- Other Co: one active, one archived.
--
-- ids
--   QD active    00000000-0000-4000-8000-000000000401 .. 425
--   QD archived  00000000-0000-4000-8000-000000000426 .. 430
--   Other Co     00000000-0000-4000-8000-000000000441, 442
-- ---------------------------------------------------------------------------

insert into public.projects (
  id, business_id, client_id, title,
  site_street, site_city, site_state, site_zip,
  created_by, archived_at, archived_by, created_at
)
values
  -- Quality Deck active, newest first (401 is page 1).
  (
    '00000000-0000-4000-8000-000000000401',
    '00000000-0000-4000-8000-000000000011',
    '00000000-0000-4000-8000-000000000101',
    'Melgar – 12 Oak St',
    '12 Oak St', 'Bowie', 'MD', '20715',
    '00000000-0000-4000-8000-000000000001',
    null, null, now() - interval '1 hour'
  ),
  (
    '00000000-0000-4000-8000-000000000402',
    '00000000-0000-4000-8000-000000000011',
    '00000000-0000-4000-8000-000000000101',
    'Melgar – 14 Oak St',
    '14 Oak St', 'Bowie', 'MD', '20715',
    '00000000-0000-4000-8000-000000000001',
    null, null, now() - interval '2 hours'
  ),
  (
    '00000000-0000-4000-8000-000000000403',
    '00000000-0000-4000-8000-000000000011',
    '00000000-0000-4000-8000-000000000102',
    'Whitaker – 200 Pine St',
    '200 Pine St', 'Bowie', 'MD', '20715',
    '00000000-0000-4000-8000-000000000001',
    null, null, now() - interval '3 hours'
  ),
  (
    '00000000-0000-4000-8000-000000000404',
    '00000000-0000-4000-8000-000000000011',
    '00000000-0000-4000-8000-000000000102',
    'Whitaker – 202 Pine St',
    '202 Pine St', 'Bowie', 'MD', '20715',
    '00000000-0000-4000-8000-000000000001',
    null, null, now() - interval '4 hours'
  ),
  (
    '00000000-0000-4000-8000-000000000405',
    '00000000-0000-4000-8000-000000000011',
    '00000000-0000-4000-8000-000000000103',
    'Shah – 5 Maple St',
    '5 Maple St', 'Laurel', 'MD', '20707',
    '00000000-0000-4000-8000-000000000001',
    null, null, now() - interval '5 hours'
  ),
  (
    '00000000-0000-4000-8000-000000000406',
    '00000000-0000-4000-8000-000000000011',
    '00000000-0000-4000-8000-000000000131',
    'One – 1 Retired Rd',
    '1 Retired Rd', 'Bowie', 'MD', '20715',
    '00000000-0000-4000-8000-000000000001',
    null, null, now() - interval '6 hours'
  ),
  (
    '00000000-0000-4000-8000-000000000407',
    '00000000-0000-4000-8000-000000000011',
    '00000000-0000-4000-8000-000000000104',
    'Ortega – 88 Maple Ave',
    '88 Maple Ave', 'Laurel', 'MD', '20707',
    '00000000-0000-4000-8000-000000000001',
    null, null, now() - interval '7 hours'
  ),
  (
    '00000000-0000-4000-8000-000000000408',
    '00000000-0000-4000-8000-000000000011',
    '00000000-0000-4000-8000-000000000106',
    'Nguyen – 4 Pine Rd',
    '4 Pine Rd', 'Crofton', 'MD', '21114',
    '00000000-0000-4000-8000-000000000001',
    null, null, now() - interval '8 hours'
  ),
  (
    '00000000-0000-4000-8000-000000000409',
    '00000000-0000-4000-8000-000000000011',
    '00000000-0000-4000-8000-000000000107',
    'Reed – 21 Birch Ln',
    '21 Birch Ln', 'Bowie', 'MD', '20716',
    '00000000-0000-4000-8000-000000000001',
    null, null, now() - interval '9 hours'
  ),
  (
    '00000000-0000-4000-8000-000000000410',
    '00000000-0000-4000-8000-000000000011',
    '00000000-0000-4000-8000-000000000108',
    'Hale – 9 Cedar Ct',
    '9 Cedar Ct', 'Greenbelt', 'MD', '20770',
    '00000000-0000-4000-8000-000000000001',
    null, null, now() - interval '10 hours'
  ),
  (
    '00000000-0000-4000-8000-000000000411',
    '00000000-0000-4000-8000-000000000011',
    '00000000-0000-4000-8000-000000000111',
    'Scott – 15 Walnut St',
    '15 Walnut St', 'Severna Park', 'MD', '21146',
    '00000000-0000-4000-8000-000000000001',
    null, null, now() - interval '11 hours'
  ),
  (
    '00000000-0000-4000-8000-000000000412',
    '00000000-0000-4000-8000-000000000011',
    '00000000-0000-4000-8000-000000000115',
    'Knox – 77 Elm St',
    '77 Elm St', 'Annapolis', 'MD', '21401',
    '00000000-0000-4000-8000-000000000001',
    null, null, now() - interval '12 hours'
  ),
  (
    '00000000-0000-4000-8000-000000000413',
    '00000000-0000-4000-8000-000000000011',
    '00000000-0000-4000-8000-000000000116',
    'Salazar – 3 Holly Way',
    '3 Holly Way', 'Bowie', 'MD', '20720',
    '00000000-0000-4000-8000-000000000001',
    null, null, now() - interval '13 hours'
  ),
  (
    '00000000-0000-4000-8000-000000000414',
    '00000000-0000-4000-8000-000000000011',
    '00000000-0000-4000-8000-000000000117',
    'Cole – 54 Spruce Dr',
    '54 Spruce Dr', 'College Park', 'MD', '20740',
    '00000000-0000-4000-8000-000000000001',
    null, null, now() - interval '14 hours'
  ),
  (
    '00000000-0000-4000-8000-000000000415',
    '00000000-0000-4000-8000-000000000011',
    '00000000-0000-4000-8000-000000000121',
    'Alvarez – 18 Poplar Ave',
    '18 Poplar Ave', 'Hyattsville', 'MD', '20781',
    '00000000-0000-4000-8000-000000000001',
    null, null, now() - interval '15 hours'
  ),
  (
    '00000000-0000-4000-8000-000000000416',
    '00000000-0000-4000-8000-000000000011',
    '00000000-0000-4000-8000-000000000122',
    'Singh – 6 Ivy Pl',
    '6 Ivy Pl', 'Bowie', 'MD', '20715',
    '00000000-0000-4000-8000-000000000001',
    null, null, now() - interval '16 hours'
  ),
  (
    '00000000-0000-4000-8000-000000000417',
    '00000000-0000-4000-8000-000000000011',
    '00000000-0000-4000-8000-000000000124',
    'Frost – 41 Ash Ct',
    '41 Ash Ct', 'Glenn Dale', 'MD', '20769',
    '00000000-0000-4000-8000-000000000001',
    null, null, now() - interval '17 hours'
  ),
  (
    '00000000-0000-4000-8000-000000000418',
    '00000000-0000-4000-8000-000000000011',
    '00000000-0000-4000-8000-000000000127',
    'Cruz – 29 Magnolia Blvd',
    '29 Magnolia Blvd', 'Odenton', 'MD', '21113',
    '00000000-0000-4000-8000-000000000001',
    null, null, now() - interval '18 hours'
  ),
  (
    '00000000-0000-4000-8000-000000000419',
    '00000000-0000-4000-8000-000000000011',
    '00000000-0000-4000-8000-000000000128',
    'Walsh – 8 Dogwood Ter',
    '8 Dogwood Ter', 'Bowie', 'MD', '20721',
    '00000000-0000-4000-8000-000000000001',
    null, null, now() - interval '19 hours'
  ),
  (
    '00000000-0000-4000-8000-000000000420',
    '00000000-0000-4000-8000-000000000011',
    '00000000-0000-4000-8000-000000000129',
    'Brooks – 102 Sycamore St',
    '102 Sycamore St', 'Upper Marlboro', 'MD', '20774',
    '00000000-0000-4000-8000-000000000001',
    null, null, now() - interval '20 hours'
  ),
  (
    '00000000-0000-4000-8000-000000000421',
    '00000000-0000-4000-8000-000000000011',
    '00000000-0000-4000-8000-000000000105',
    'Brooks – 50 New Site',
    '50 New Site', 'Bowie', 'MD', '20715',
    '00000000-0000-4000-8000-000000000001',
    null, null, now() - interval '21 hours'
  ),
  (
    '00000000-0000-4000-8000-000000000422',
    '00000000-0000-4000-8000-000000000011',
    '00000000-0000-4000-8000-000000000109',
    'Patel – 11 Site St',
    '11 Site St', 'Bowie', 'MD', '20715',
    '00000000-0000-4000-8000-000000000001',
    null, null, now() - interval '22 hours'
  ),
  (
    '00000000-0000-4000-8000-000000000423',
    '00000000-0000-4000-8000-000000000011',
    '00000000-0000-4000-8000-000000000110',
    'Chen – 22 Site St',
    '22 Site St', 'Bowie', 'MD', '20716',
    '00000000-0000-4000-8000-000000000001',
    null, null, now() - interval '23 hours'
  ),
  (
    '00000000-0000-4000-8000-000000000424',
    '00000000-0000-4000-8000-000000000011',
    '00000000-0000-4000-8000-000000000112',
    'Dale – 33 Site St',
    '33 Site St', 'Laurel', 'MD', '20707',
    '00000000-0000-4000-8000-000000000001',
    null, null, now() - interval '24 hours'
  ),
  (
    '00000000-0000-4000-8000-000000000425',
    '00000000-0000-4000-8000-000000000011',
    '00000000-0000-4000-8000-000000000113',
    'Ellis – 44 Site St',
    '44 Site St', 'Bowie', 'MD', '20720',
    '00000000-0000-4000-8000-000000000001',
    null, null, now() - interval '25 hours'
  ),
  -- Quality Deck archived, most recently archived first (426).
  (
    '00000000-0000-4000-8000-000000000426',
    '00000000-0000-4000-8000-000000000011',
    '00000000-0000-4000-8000-000000000114',
    'Barker – 9 Archived Way',
    '9 Archived Way', 'Bowie', 'MD', '20715',
    '00000000-0000-4000-8000-000000000001',
    now() - interval '1 day',
    '00000000-0000-4000-8000-000000000001',
    now() - interval '10 days'
  ),
  (
    '00000000-0000-4000-8000-000000000427',
    '00000000-0000-4000-8000-000000000011',
    '00000000-0000-4000-8000-000000000118',
    'Rivera – 8 Archived Way',
    '8 Archived Way', 'Bowie', 'MD', '20716',
    '00000000-0000-4000-8000-000000000001',
    now() - interval '2 days',
    '00000000-0000-4000-8000-000000000001',
    now() - interval '11 days'
  ),
  (
    '00000000-0000-4000-8000-000000000428',
    '00000000-0000-4000-8000-000000000011',
    '00000000-0000-4000-8000-000000000119',
    'Moon – 7 Archived Way',
    '7 Archived Way', 'Laurel', 'MD', '20707',
    '00000000-0000-4000-8000-000000000001',
    now() - interval '3 days',
    '00000000-0000-4000-8000-000000000001',
    now() - interval '12 days'
  ),
  (
    '00000000-0000-4000-8000-000000000429',
    '00000000-0000-4000-8000-000000000011',
    '00000000-0000-4000-8000-000000000120',
    'Dunn – 6 Archived Way',
    '6 Archived Way', 'Bowie', 'MD', '20720',
    '00000000-0000-4000-8000-000000000001',
    now() - interval '4 days',
    '00000000-0000-4000-8000-000000000001',
    now() - interval '13 days'
  ),
  (
    '00000000-0000-4000-8000-000000000430',
    '00000000-0000-4000-8000-000000000011',
    '00000000-0000-4000-8000-000000000126',
    'Ames – 5 Archived Way',
    '5 Archived Way', 'Bowie', 'MD', '20715',
    '00000000-0000-4000-8000-000000000001',
    now() - interval '5 days',
    '00000000-0000-4000-8000-000000000001',
    now() - interval '14 days'
  ),
  -- Other Co
  (
    '00000000-0000-4000-8000-000000000441',
    '00000000-0000-4000-8000-000000000012',
    '00000000-0000-4000-8000-000000000141',
    'A – 10 Main St',
    '10 Main St', 'Arlington', 'VA', '22201',
    '00000000-0000-4000-8000-000000000003',
    null, null, now() - interval '2 hours'
  ),
  (
    '00000000-0000-4000-8000-000000000442',
    '00000000-0000-4000-8000-000000000012',
    '00000000-0000-4000-8000-000000000142',
    'B – 20 Side St',
    '20 Side St', 'Arlington', 'VA', '22201',
    '00000000-0000-4000-8000-000000000003',
    now() - interval '1 day',
    '00000000-0000-4000-8000-000000000003',
    now() - interval '8 days'
  );

-- ---------------------------------------------------------------------------
-- Pricing
-- Quality Deck: labor $65.00/hr, overhead 12.5%, 33 items from the
-- 3/10/2020 price sheet (all five pricing types).
-- Other Co: settings not set, three items.
--
-- ids
--   QD items   00000000-0000-4000-8000-000000000301 .. 333
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
  created_by
)
values
  -- New deck options (retail per sq ft)
  (
    '00000000-0000-4000-8000-000000000301',
    '00000000-0000-4000-8000-000000000011',
    'New Composite Deck - Trex Transcend',
    'Based on an installed per-square-foot price of the decking and rail. Itemized — refer to the calculator for exact prices and options.',
    'per_sq_ft',
    11000,
    '00000000-0000-4000-8000-000000000001'
  ),
  (
    '00000000-0000-4000-8000-000000000302',
    '00000000-0000-4000-8000-000000000011',
    'New Composite Deck - TimberTech Edge',
    'Based on an installed per-square-foot price of the decking and rail. Itemized — refer to the calculator for exact prices and options.',
    'per_sq_ft',
    10000,
    '00000000-0000-4000-8000-000000000001'
  ),
  (
    '00000000-0000-4000-8000-000000000303',
    '00000000-0000-4000-8000-000000000011',
    'New KDAT Green Certified Wood Deck',
    'Based on an installed per-square-foot price of the decking and rail. Itemized — refer to the calculator for exact prices and options.',
    'per_sq_ft',
    7500,
    '00000000-0000-4000-8000-000000000001'
  ),
  (
    '00000000-0000-4000-8000-000000000304',
    '00000000-0000-4000-8000-000000000011',
    'New Pressure Treated Wood Deck',
    'Based on an installed per-square-foot price of the decking and rail. Itemized — refer to the calculator for exact prices and options.',
    'per_sq_ft',
    6000,
    '00000000-0000-4000-8000-000000000001'
  ),
  (
    '00000000-0000-4000-8000-000000000305',
    '00000000-0000-4000-8000-000000000011',
    'New Composite Deck - Trex Enhance or Select',
    E'Based on an installed per-square-foot price of the decking and rail.\nItemized — refer to the calculator for exact prices and options.',
    'per_sq_ft',
    9500,
    '00000000-0000-4000-8000-000000000001'
  ),
  (
    '00000000-0000-4000-8000-000000000306',
    '00000000-0000-4000-8000-000000000011',
    'Add Grit to Sealant - minimum',
    'Job minimum when grit for a No Slip sealant is under $25. Pair with the per-sq-ft grit item.',
    'fixed',
    2500,
    '00000000-0000-4000-8000-000000000001'
  ),
  -- Board replacement options (retail per sq ft)
  (
    '00000000-0000-4000-8000-000000000307',
    '00000000-0000-4000-8000-000000000011',
    'Gold Package - Trex Transcend',
    'New composite boards on deck flat surfaces, stair treads, and top rail or milling, plus one coat of patented Deck Solution protective coating on balusters, rail posts, fascia, stringers, and risers if applicable. No rails: $40/SF.',
    'per_sq_ft',
    2000,
    '00000000-0000-4000-8000-000000000001'
  ),
  (
    '00000000-0000-4000-8000-000000000308',
    '00000000-0000-4000-8000-000000000011',
    'Gold Package - Azek/TimberTech Edge',
    'New composite boards on deck flat surfaces, stair treads, and top rail or milling, plus one coat of patented Deck Solution protective coating on balusters, rail posts, fascia, stringers, and risers if applicable. No rails: $36/SF.',
    'per_sq_ft',
    1800,
    '00000000-0000-4000-8000-000000000001'
  ),
  (
    '00000000-0000-4000-8000-000000000309',
    '00000000-0000-4000-8000-000000000011',
    'Gold Package - Trex Enhance or Select',
    'New composite boards on deck flat surfaces, stair treads, and top rail or milling, plus one coat of patented Deck Solution protective coating on balusters, rail posts, fascia, stringers, and risers if applicable. No rails: $34/SF.',
    'per_sq_ft',
    1700,
    '00000000-0000-4000-8000-000000000001'
  ),
  (
    '00000000-0000-4000-8000-000000000310',
    '00000000-0000-4000-8000-000000000011',
    'Silver Package - KDAT Green Certified',
    'New KDAT pine boards on deck flat surfaces, stair treads, and top rail or milling, plus one coat of patented Deck Solution protective coating on balusters, rail posts, fascia, stringers, and risers if applicable. No rails: $32/SF.',
    'per_sq_ft',
    1600,
    '00000000-0000-4000-8000-000000000001'
  ),
  (
    '00000000-0000-4000-8000-000000000311',
    '00000000-0000-4000-8000-000000000011',
    'Bronze Package - Standard Lumber',
    'New pressure-treated pine boards on deck flat surfaces, stair treads, and top rail or milling, plus one coat of patented Deck Solution protective coating on balusters, rail posts, fascia, stringers, and risers if applicable. No rails: $30/SF.',
    'per_sq_ft',
    1500,
    '00000000-0000-4000-8000-000000000001'
  ),
  -- Revitalizing deck options
  (
    '00000000-0000-4000-8000-000000000312',
    '00000000-0000-4000-8000-000000000011',
    'Deck Solution Package',
    'On the flat surfaces (decking and top rail): sand flat surfaces, apply one coat of primer, and apply two coats of patented Deck Solution protective coating.',
    'per_sq_ft',
    1600,
    '00000000-0000-4000-8000-000000000001'
  ),
  (
    '00000000-0000-4000-8000-000000000313',
    '00000000-0000-4000-8000-000000000011',
    'Premium Wash & Stain',
    'Wash to remove grease, sap, and residue, then apply one coat of stain and a protective layer.',
    'per_sq_ft',
    1100,
    '00000000-0000-4000-8000-000000000001'
  ),
  -- Options and miscellaneous
  (
    '00000000-0000-4000-8000-000000000314',
    '00000000-0000-4000-8000-000000000011',
    'New Pressure Treated Railings',
    'Includes protective coating. Sold in 6 or 8 foot sections.',
    'per_linear_ft',
    6000,
    '00000000-0000-4000-8000-000000000001'
  ),
  (
    '00000000-0000-4000-8000-000000000315',
    '00000000-0000-4000-8000-000000000011',
    'Add Grit to Sealant (No Slip)',
    '$0.50/SF. Add the minimum charge item when the area total is under $25.',
    'per_sq_ft',
    50,
    '00000000-0000-4000-8000-000000000001'
  ),
  (
    '00000000-0000-4000-8000-000000000316',
    '00000000-0000-4000-8000-000000000011',
    'Deck Solution on 6x6 Posts',
    '$2 per foot of post height.',
    'per_linear_ft',
    200,
    '00000000-0000-4000-8000-000000000001'
  ),
  (
    '00000000-0000-4000-8000-000000000317',
    '00000000-0000-4000-8000-000000000011',
    'Deck Solution on 4x4 Posts',
    '$1 per foot of post height.',
    'per_linear_ft',
    100,
    '00000000-0000-4000-8000-000000000001'
  ),
  (
    '00000000-0000-4000-8000-000000000318',
    '00000000-0000-4000-8000-000000000011',
    'Pressure Treated Pine Boards (under 20 ft)',
    'Replacement boards.',
    'per_linear_ft',
    1000,
    '00000000-0000-4000-8000-000000000001'
  ),
  (
    '00000000-0000-4000-8000-000000000319',
    '00000000-0000-4000-8000-000000000011',
    'Pressure Treated Pine Boards (over 20 ft)',
    'Replacement boards.',
    'per_linear_ft',
    1200,
    '00000000-0000-4000-8000-000000000001'
  ),
  (
    '00000000-0000-4000-8000-000000000320',
    '00000000-0000-4000-8000-000000000011',
    'KDAT Pine Boards (under 20 ft)',
    'Replacement boards.',
    'per_linear_ft',
    1200,
    '00000000-0000-4000-8000-000000000001'
  ),
  (
    '00000000-0000-4000-8000-000000000321',
    '00000000-0000-4000-8000-000000000011',
    'KDAT Pine Boards (over 20 ft)',
    'Replacement boards.',
    'per_linear_ft',
    1500,
    '00000000-0000-4000-8000-000000000001'
  ),
  (
    '00000000-0000-4000-8000-000000000322',
    '00000000-0000-4000-8000-000000000011',
    '4x4 Pressure Treated Posts',
    null,
    'per_unit',
    5000,
    '00000000-0000-4000-8000-000000000001'
  ),
  (
    '00000000-0000-4000-8000-000000000323',
    '00000000-0000-4000-8000-000000000011',
    '6x6 Pressure Treated Posts',
    null,
    'per_unit',
    10000,
    '00000000-0000-4000-8000-000000000001'
  ),
  (
    '00000000-0000-4000-8000-000000000324',
    '00000000-0000-4000-8000-000000000011',
    'Pressure Treated Balusters',
    null,
    'per_unit',
    400,
    '00000000-0000-4000-8000-000000000001'
  ),
  (
    '00000000-0000-4000-8000-000000000325',
    '00000000-0000-4000-8000-000000000011',
    '2x12 Pressure Treated Joists',
    null,
    'per_linear_ft',
    1000,
    '00000000-0000-4000-8000-000000000001'
  ),
  (
    '00000000-0000-4000-8000-000000000326',
    '00000000-0000-4000-8000-000000000011',
    'Stringers (up to 6 steps)',
    null,
    'per_unit',
    7500,
    '00000000-0000-4000-8000-000000000001'
  ),
  (
    '00000000-0000-4000-8000-000000000327',
    '00000000-0000-4000-8000-000000000011',
    'Custom Stringer (6+ steps)',
    'Custom-made stringer for more than 6 steps.',
    'per_unit',
    50000,
    '00000000-0000-4000-8000-000000000001'
  ),
  (
    '00000000-0000-4000-8000-000000000328',
    '00000000-0000-4000-8000-000000000011',
    'Replacement 6x6 Post with New Footer',
    'New pressure-treated 6x6 post with a new concrete footer.',
    'per_unit',
    70000,
    '00000000-0000-4000-8000-000000000001'
  ),
  (
    '00000000-0000-4000-8000-000000000329',
    '00000000-0000-4000-8000-000000000011',
    'Replacement 6x6 Post with Existing Footer',
    'Uses the existing concrete footer. Up to 16 feet high.',
    'per_unit',
    45000,
    '00000000-0000-4000-8000-000000000001'
  ),
  (
    '00000000-0000-4000-8000-000000000330',
    '00000000-0000-4000-8000-000000000011',
    'Vinyl Privacy Lattice',
    '4x8 diamond sheets in White, Cedar, and Redwood.',
    'per_sq_ft',
    500,
    '00000000-0000-4000-8000-000000000001'
  ),
  (
    '00000000-0000-4000-8000-000000000331',
    '00000000-0000-4000-8000-000000000011',
    'Wood Lattice',
    'We coat it.',
    'per_sq_ft',
    500,
    '00000000-0000-4000-8000-000000000001'
  ),
  (
    '00000000-0000-4000-8000-000000000332',
    '00000000-0000-4000-8000-000000000011',
    'Coating Only (No Sanding)',
    'Additional areas. Coating only, no sanding.',
    'per_sq_ft',
    500,
    '00000000-0000-4000-8000-000000000001'
  ),
  (
    '00000000-0000-4000-8000-000000000333',
    '00000000-0000-4000-8000-000000000011',
    'Build New Wood Steps',
    null,
    'per_step',
    9000,
    '00000000-0000-4000-8000-000000000001'
  ),
  -- Other Co
  (
    '00000000-0000-4000-8000-000000000341',
    '00000000-0000-4000-8000-000000000012',
    'Hourly labor',
    null,
    'fixed',
    7500,
    '00000000-0000-4000-8000-000000000003'
  ),
  (
    '00000000-0000-4000-8000-000000000342',
    '00000000-0000-4000-8000-000000000012',
    'Fence panel',
    '6-foot cedar',
    'per_unit',
    8500,
    '00000000-0000-4000-8000-000000000003'
  ),
  (
    '00000000-0000-4000-8000-000000000343',
    '00000000-0000-4000-8000-000000000012',
    'Sod',
    null,
    'per_sq_ft',
    85,
    '00000000-0000-4000-8000-000000000003'
  );

-- ---------------------------------------------------------------------------
-- Jobs and line items
-- Quality Deck: five active projects (one to three jobs each, all three
-- types), three to eight lines covering every pricing type, some custom,
-- some with overrides, one whose price item is then deleted. About half
-- the jobs have labor; one at a rate other than $65. Three projects have
-- overhead; one at a percentage other than 12.5%. One archived project
-- with jobs and lines.
-- Other Co: one project with a job and two lines.
--
-- ids
--   QD jobs    00000000-0000-4000-8000-000000000501 .. 510
--   Other Co   00000000-0000-4000-8000-000000000511
--   QD lines   00000000-0000-4000-8000-000000000601 .. 639
--   Other Co   00000000-0000-4000-8000-000000000640, 641
--   temp item  00000000-0000-4000-8000-000000000399  (deleted after copy)
-- ---------------------------------------------------------------------------

update public.projects
set overhead_bps = 1250
where id in (
  '00000000-0000-4000-8000-000000000401',
  '00000000-0000-4000-8000-000000000403'
);

update public.projects
set overhead_bps = 1500
where id = '00000000-0000-4000-8000-000000000402';

insert into public.price_items (
  id, business_id, name, description, pricing_type, price_cents, created_by
)
values (
  '00000000-0000-4000-8000-000000000399',
  '00000000-0000-4000-8000-000000000011',
  'Old fascia',
  'Discontinued profile',
  'per_linear_ft',
  600,
  '00000000-0000-4000-8000-000000000001'
);

insert into public.jobs (
  id, business_id, project_id, title, job_type, description,
  labor_hours, labor_rate_cents, created_by, created_at
)
values
  (
    '00000000-0000-4000-8000-000000000501',
    '00000000-0000-4000-8000-000000000011',
    '00000000-0000-4000-8000-000000000401',
    'Back deck',
    'deck',
    'Replace rotted boards and railing',
    12.5, 6500,
    '00000000-0000-4000-8000-000000000001',
    now() - interval '3 days'
  ),
  (
    '00000000-0000-4000-8000-000000000502',
    '00000000-0000-4000-8000-000000000011',
    '00000000-0000-4000-8000-000000000401',
    'Front steps',
    'deck',
    null,
    8, 7000,
    '00000000-0000-4000-8000-000000000001',
    now() - interval '2 days'
  ),
  (
    '00000000-0000-4000-8000-000000000503',
    '00000000-0000-4000-8000-000000000011',
    '00000000-0000-4000-8000-000000000401',
    'Side patio',
    'patio',
    'Pavers off the kitchen',
    null, null,
    '00000000-0000-4000-8000-000000000001',
    now() - interval '1 day'
  ),
  (
    '00000000-0000-4000-8000-000000000504',
    '00000000-0000-4000-8000-000000000011',
    '00000000-0000-4000-8000-000000000402',
    'Walkway',
    'hardscaping',
    null,
    4, 6500,
    '00000000-0000-4000-8000-000000000001',
    now() - interval '2 days'
  ),
  (
    '00000000-0000-4000-8000-000000000505',
    '00000000-0000-4000-8000-000000000011',
    '00000000-0000-4000-8000-000000000402',
    'Landing',
    'deck',
    null,
    null, null,
    '00000000-0000-4000-8000-000000000001',
    now() - interval '1 day'
  ),
  (
    '00000000-0000-4000-8000-000000000506',
    '00000000-0000-4000-8000-000000000011',
    '00000000-0000-4000-8000-000000000403',
    'Main deck',
    'deck',
    'Full rebuild',
    10, 6500,
    '00000000-0000-4000-8000-000000000001',
    now() - interval '1 day'
  ),
  (
    '00000000-0000-4000-8000-000000000507',
    '00000000-0000-4000-8000-000000000011',
    '00000000-0000-4000-8000-000000000404',
    'Repair',
    'patio',
    null,
    null, null,
    '00000000-0000-4000-8000-000000000001',
    now() - interval '2 days'
  ),
  (
    '00000000-0000-4000-8000-000000000508',
    '00000000-0000-4000-8000-000000000011',
    '00000000-0000-4000-8000-000000000404',
    'Border',
    'hardscaping',
    null,
    6, 6500,
    '00000000-0000-4000-8000-000000000001',
    now() - interval '1 day'
  ),
  (
    '00000000-0000-4000-8000-000000000509',
    '00000000-0000-4000-8000-000000000011',
    '00000000-0000-4000-8000-000000000405',
    'Stairs',
    'deck',
    null,
    null, null,
    '00000000-0000-4000-8000-000000000001',
    now() - interval '1 day'
  ),
  (
    '00000000-0000-4000-8000-000000000510',
    '00000000-0000-4000-8000-000000000011',
    '00000000-0000-4000-8000-000000000426',
    'Archived deck',
    'deck',
    'Finished last season',
    5, 6500,
    '00000000-0000-4000-8000-000000000001',
    now() - interval '12 days'
  ),
  (
    '00000000-0000-4000-8000-000000000511',
    '00000000-0000-4000-8000-000000000012',
    '00000000-0000-4000-8000-000000000441',
    'Front fence',
    'hardscaping',
    null,
    null, null,
    '00000000-0000-4000-8000-000000000003',
    now() - interval '1 day'
  );

insert into public.line_items (
  id, business_id, job_id, position, is_custom, price_item_id,
  name, description, pricing_type, quantity, saved_price_cents,
  override_price_cents, created_by
)
values
  -- 501 Back deck (6)
  (
    '00000000-0000-4000-8000-000000000601',
    '00000000-0000-4000-8000-000000000011',
    '00000000-0000-4000-8000-000000000501',
    0, false, '00000000-0000-4000-8000-000000000305',
    'Composite decking',
    E'Trex Enhance boards in the color selected on site,\nhidden fasteners, color-matched plugs, and waste factor.\n\nDoes not include railings, stairs, or permit fees.\nThose are listed separately.',
    'per_sq_ft', 192.5, 450, null,
    '00000000-0000-4000-8000-000000000001'
  ),
  (
    '00000000-0000-4000-8000-000000000602',
    '00000000-0000-4000-8000-000000000011',
    '00000000-0000-4000-8000-000000000501',
    1, false, '00000000-0000-4000-8000-000000000301',
    'Aluminum railing',
    'Powder-coated, includes brackets',
    'per_linear_ft', 42, 3800, 3500,
    '00000000-0000-4000-8000-000000000001'
  ),
  (
    '00000000-0000-4000-8000-000000000603',
    '00000000-0000-4000-8000-000000000011',
    '00000000-0000-4000-8000-000000000501',
    2, true, null,
    'Haul-away',
    'Debris from demo',
    'fixed', 1, 25000, null,
    '00000000-0000-4000-8000-000000000001'
  ),
  (
    '00000000-0000-4000-8000-000000000604',
    '00000000-0000-4000-8000-000000000011',
    '00000000-0000-4000-8000-000000000501',
    3, false, '00000000-0000-4000-8000-000000000316',
    'Post footing',
    null,
    'per_unit', 8, 8500, null,
    '00000000-0000-4000-8000-000000000001'
  ),
  (
    '00000000-0000-4000-8000-000000000605',
    '00000000-0000-4000-8000-000000000011',
    '00000000-0000-4000-8000-000000000501',
    4, false, '00000000-0000-4000-8000-000000000303',
    'Box step',
    'Built-in storage under the tread',
    'per_step', 3, 12000, null,
    '00000000-0000-4000-8000-000000000001'
  ),
  (
    '00000000-0000-4000-8000-000000000606',
    '00000000-0000-4000-8000-000000000011',
    '00000000-0000-4000-8000-000000000501',
    5, false, '00000000-0000-4000-8000-000000000399',
    'Old fascia',
    'Discontinued profile',
    'per_linear_ft', 24, 600, null,
    '00000000-0000-4000-8000-000000000001'
  ),
  -- 502 Front steps (4)
  (
    '00000000-0000-4000-8000-000000000607',
    '00000000-0000-4000-8000-000000000011',
    '00000000-0000-4000-8000-000000000502',
    0, false, '00000000-0000-4000-8000-000000000321',
    'Stair tread (composite)',
    'Includes riser and hidden fasteners',
    'per_step', 6, 9500, null,
    '00000000-0000-4000-8000-000000000001'
  ),
  (
    '00000000-0000-4000-8000-000000000608',
    '00000000-0000-4000-8000-000000000011',
    '00000000-0000-4000-8000-000000000502',
    1, true, null,
    'Extra hardware',
    null,
    'per_unit', 12, 1500, null,
    '00000000-0000-4000-8000-000000000001'
  ),
  (
    '00000000-0000-4000-8000-000000000609',
    '00000000-0000-4000-8000-000000000011',
    '00000000-0000-4000-8000-000000000502',
    2, false, '00000000-0000-4000-8000-000000000318',
    'Site cleanup',
    null,
    'fixed', 1, 20000, null,
    '00000000-0000-4000-8000-000000000001'
  ),
  (
    '00000000-0000-4000-8000-000000000610',
    '00000000-0000-4000-8000-000000000011',
    '00000000-0000-4000-8000-000000000502',
    3, false, '00000000-0000-4000-8000-000000000320',
    'Stair stringer',
    null,
    'per_linear_ft', 20, 2500, 2200,
    '00000000-0000-4000-8000-000000000001'
  ),
  -- 503 Side patio (3)
  (
    '00000000-0000-4000-8000-000000000611',
    '00000000-0000-4000-8000-000000000011',
    '00000000-0000-4000-8000-000000000503',
    0, false, '00000000-0000-4000-8000-000000000312',
    'Patio pavers',
    null,
    'per_sq_ft', 120, 800, null,
    '00000000-0000-4000-8000-000000000001'
  ),
  (
    '00000000-0000-4000-8000-000000000612',
    '00000000-0000-4000-8000-000000000011',
    '00000000-0000-4000-8000-000000000503',
    1, true, null,
    'Edging stone',
    null,
    'per_linear_ft', 30, 900, null,
    '00000000-0000-4000-8000-000000000001'
  ),
  (
    '00000000-0000-4000-8000-000000000613',
    '00000000-0000-4000-8000-000000000011',
    '00000000-0000-4000-8000-000000000503',
    2, false, '00000000-0000-4000-8000-000000000307',
    'Design consult',
    null,
    'fixed', 1, 15000, null,
    '00000000-0000-4000-8000-000000000001'
  ),
  -- 504 Walkway (4)
  (
    '00000000-0000-4000-8000-000000000614',
    '00000000-0000-4000-8000-000000000011',
    '00000000-0000-4000-8000-000000000504',
    0, false, '00000000-0000-4000-8000-000000000312',
    'Patio pavers',
    null,
    'per_sq_ft', 80, 800, null,
    '00000000-0000-4000-8000-000000000001'
  ),
  (
    '00000000-0000-4000-8000-000000000615',
    '00000000-0000-4000-8000-000000000011',
    '00000000-0000-4000-8000-000000000504',
    1, false, '00000000-0000-4000-8000-000000000302',
    'Baluster',
    null,
    'per_unit', 20, 800, null,
    '00000000-0000-4000-8000-000000000001'
  ),
  (
    '00000000-0000-4000-8000-000000000616',
    '00000000-0000-4000-8000-000000000011',
    '00000000-0000-4000-8000-000000000504',
    2, true, null,
    'Base prep',
    'Gravel and sand',
    'fixed', 1, 40000, null,
    '00000000-0000-4000-8000-000000000001'
  ),
  (
    '00000000-0000-4000-8000-000000000617',
    '00000000-0000-4000-8000-000000000011',
    '00000000-0000-4000-8000-000000000504',
    3, false, '00000000-0000-4000-8000-000000000310',
    'Landing step',
    null,
    'per_step', 2, 8500, null,
    '00000000-0000-4000-8000-000000000001'
  ),
  -- 505 Landing (3)
  (
    '00000000-0000-4000-8000-000000000618',
    '00000000-0000-4000-8000-000000000011',
    '00000000-0000-4000-8000-000000000505',
    0, false, '00000000-0000-4000-8000-000000000317',
    'Pressure-treated decking',
    'Ground-contact rated, includes fasteners',
    'per_sq_ft', 40, 325, null,
    '00000000-0000-4000-8000-000000000001'
  ),
  (
    '00000000-0000-4000-8000-000000000619',
    '00000000-0000-4000-8000-000000000011',
    '00000000-0000-4000-8000-000000000505',
    1, false, '00000000-0000-4000-8000-000000000306',
    'Demo existing deck',
    'Haul-away included',
    'fixed', 1, 80000, null,
    '00000000-0000-4000-8000-000000000001'
  ),
  (
    '00000000-0000-4000-8000-000000000620',
    '00000000-0000-4000-8000-000000000011',
    '00000000-0000-4000-8000-000000000505',
    2, true, null,
    'Custom rail cap',
    null,
    'per_linear_ft', 16, 1800, null,
    '00000000-0000-4000-8000-000000000001'
  ),
  -- 506 Main deck (5)
  (
    '00000000-0000-4000-8000-000000000621',
    '00000000-0000-4000-8000-000000000011',
    '00000000-0000-4000-8000-000000000506',
    0, false, '00000000-0000-4000-8000-000000000305',
    'Composite decking',
    E'Trex Enhance boards in the color selected on site,\nhidden fasteners, color-matched plugs, and waste factor.\n\nDoes not include railings, stairs, or permit fees.\nThose are listed separately.',
    'per_sq_ft', 250, 450, 425,
    '00000000-0000-4000-8000-000000000001'
  ),
  (
    '00000000-0000-4000-8000-000000000622',
    '00000000-0000-4000-8000-000000000011',
    '00000000-0000-4000-8000-000000000506',
    1, false, '00000000-0000-4000-8000-000000000304',
    'Cable railing',
    null,
    'per_linear_ft', 50, 5500, null,
    '00000000-0000-4000-8000-000000000001'
  ),
  (
    '00000000-0000-4000-8000-000000000623',
    '00000000-0000-4000-8000-000000000011',
    '00000000-0000-4000-8000-000000000506',
    2, false, '00000000-0000-4000-8000-000000000313',
    'Permit filing',
    'County application and pickup',
    'fixed', 1, 35000, null,
    '00000000-0000-4000-8000-000000000001'
  ),
  (
    '00000000-0000-4000-8000-000000000624',
    '00000000-0000-4000-8000-000000000011',
    '00000000-0000-4000-8000-000000000506',
    3, false, '00000000-0000-4000-8000-000000000315',
    'Post cap',
    'Copper or composite',
    'per_unit', 6, 1500, null,
    '00000000-0000-4000-8000-000000000001'
  ),
  (
    '00000000-0000-4000-8000-000000000625',
    '00000000-0000-4000-8000-000000000011',
    '00000000-0000-4000-8000-000000000506',
    4, true, null,
    'Temporary stairs',
    null,
    'per_step', 4, 5000, null,
    '00000000-0000-4000-8000-000000000001'
  ),
  -- 507 Repair (3)
  (
    '00000000-0000-4000-8000-000000000626',
    '00000000-0000-4000-8000-000000000011',
    '00000000-0000-4000-8000-000000000507',
    0, false, '00000000-0000-4000-8000-000000000322',
    'Staining',
    null,
    'per_sq_ft', 60, 175, null,
    '00000000-0000-4000-8000-000000000001'
  ),
  (
    '00000000-0000-4000-8000-000000000627',
    '00000000-0000-4000-8000-000000000011',
    '00000000-0000-4000-8000-000000000507',
    1, true, null,
    'Crack fill',
    null,
    'fixed', 1, 7500, null,
    '00000000-0000-4000-8000-000000000001'
  ),
  (
    '00000000-0000-4000-8000-000000000628',
    '00000000-0000-4000-8000-000000000011',
    '00000000-0000-4000-8000-000000000507',
    2, false, '00000000-0000-4000-8000-000000000311',
    'Lighting fixture',
    'Low-voltage post cap or riser light',
    'per_unit', 4, 4500, null,
    '00000000-0000-4000-8000-000000000001'
  ),
  -- 508 Border (3)
  (
    '00000000-0000-4000-8000-000000000629',
    '00000000-0000-4000-8000-000000000011',
    '00000000-0000-4000-8000-000000000508',
    0, false, '00000000-0000-4000-8000-000000000314',
    'Picture frame border',
    null,
    'per_linear_ft', 36, 1200, null,
    '00000000-0000-4000-8000-000000000001'
  ),
  (
    '00000000-0000-4000-8000-000000000630',
    '00000000-0000-4000-8000-000000000011',
    '00000000-0000-4000-8000-000000000508',
    1, false, '00000000-0000-4000-8000-000000000308',
    'Dumpster rental',
    '10-yard, one week',
    'fixed', 1, 45000, null,
    '00000000-0000-4000-8000-000000000001'
  ),
  (
    '00000000-0000-4000-8000-000000000631',
    '00000000-0000-4000-8000-000000000011',
    '00000000-0000-4000-8000-000000000508',
    2, true, null,
    'River rock',
    null,
    'per_sq_ft', 18, 650, null,
    '00000000-0000-4000-8000-000000000001'
  ),
  -- 509 Stairs (3)
  (
    '00000000-0000-4000-8000-000000000632',
    '00000000-0000-4000-8000-000000000011',
    '00000000-0000-4000-8000-000000000509',
    0, false, '00000000-0000-4000-8000-000000000321',
    'Stair tread (composite)',
    'Includes riser and hidden fasteners',
    'per_step', 8, 9500, null,
    '00000000-0000-4000-8000-000000000001'
  ),
  (
    '00000000-0000-4000-8000-000000000633',
    '00000000-0000-4000-8000-000000000011',
    '00000000-0000-4000-8000-000000000509',
    1, false, '00000000-0000-4000-8000-000000000319',
    'Stair lighting',
    'Riser-mounted LED',
    'per_step', 8, 4000, null,
    '00000000-0000-4000-8000-000000000001'
  ),
  (
    '00000000-0000-4000-8000-000000000634',
    '00000000-0000-4000-8000-000000000011',
    '00000000-0000-4000-8000-000000000509',
    2, true, null,
    'Handrail kit',
    null,
    'fixed', 1, 18000, null,
    '00000000-0000-4000-8000-000000000001'
  ),
  -- 510 Archived deck (3)
  (
    '00000000-0000-4000-8000-000000000635',
    '00000000-0000-4000-8000-000000000011',
    '00000000-0000-4000-8000-000000000510',
    0, false, '00000000-0000-4000-8000-000000000317',
    'Pressure-treated decking',
    'Ground-contact rated, includes fasteners',
    'per_sq_ft', 100, 325, null,
    '00000000-0000-4000-8000-000000000001'
  ),
  (
    '00000000-0000-4000-8000-000000000636',
    '00000000-0000-4000-8000-000000000011',
    '00000000-0000-4000-8000-000000000510',
    1, false, '00000000-0000-4000-8000-000000000301',
    'Aluminum railing',
    'Powder-coated, includes brackets',
    'per_linear_ft', 28, 3800, null,
    '00000000-0000-4000-8000-000000000001'
  ),
  (
    '00000000-0000-4000-8000-000000000637',
    '00000000-0000-4000-8000-000000000011',
    '00000000-0000-4000-8000-000000000510',
    2, true, null,
    'Stain leftover',
    null,
    'fixed', 1, 5000, null,
    '00000000-0000-4000-8000-000000000001'
  ),
  -- 511 Other Co (2)
  (
    '00000000-0000-4000-8000-000000000640',
    '00000000-0000-4000-8000-000000000012',
    '00000000-0000-4000-8000-000000000511',
    0, false, '00000000-0000-4000-8000-000000000342',
    'Fence panel',
    '6-foot cedar',
    'per_unit', 8, 8500, null,
    '00000000-0000-4000-8000-000000000003'
  ),
  (
    '00000000-0000-4000-8000-000000000641',
    '00000000-0000-4000-8000-000000000012',
    '00000000-0000-4000-8000-000000000511',
    1, true, null,
    'Gate hardware',
    null,
    'fixed', 1, 12000, null,
    '00000000-0000-4000-8000-000000000003'
  );

delete from public.price_items
where id = '00000000-0000-4000-8000-000000000399';


