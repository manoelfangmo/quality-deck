# Field Notes

Flutter web app (Safari on iPhone and iPad) with Supabase for auth, Postgres, and RLS. Setup details that change as features land live here.

## Run locally

```sh
supabase start
cd app
flutter run -d chrome --dart-define-from-file development.env --web-port=3000
```

`supabase start` uses the default local ports (API `54321`, Postgres `54322`). Stop any other local Supabase project that is already bound to those ports first.

`app/development.env` holds the local API URL and anon key from `supabase status`.

## Seeded accounts

Password for every seeded user: `password123`

| Email | Who |
| --- | --- |
| `owner@qualitydeck.test` | Quality Deck owner (Moises (dev)) |
| `crew@qualitydeck.test` | Quality Deck member |
| `other@example.test` | Other Co owner (isolation only) |
| `nobusiness@example.test` | Signed up, no membership (lands on onboarding) |
| `joiner@example.test` | Signed up, no membership (RLS redeem tests) |

Quality Deck invite codes:

| Code | Status |
| --- | --- |
| `QDACTIVE` | Active |
| `QDEXPIRD` | Expired |
| `QDUSED22` | Used |
| `QDREVOKD` | Revoked |

Reset the database (applies migrations, then seed):

```sh
supabase db reset
```

Then run the tenancy assertions:

```sh
docker exec -i supabase_db_field-notes psql -U postgres -v ON_ERROR_STOP=1 < supabase/tests/rls_check.sql
```

## Contract tests

Repository methods that talk to Postgres are covered by contract tests against
local Supabase, not mocks. The playbook is [app/contract_test/README.md](app/contract_test/README.md).

```sh
cp app/example.contract_test.env app/contract_test.env
cd app
flutter test contract_test/ --dart-define-from-file contract_test.env
```

`app/example.contract_test.env` already has the local-demo URL, anon key, and
service-role key from `supabase status`.

## Auth settings

Recorded here so the hosted project matches local `supabase/config.toml`:

| Setting | Local | Hosted |
| --- | --- | --- |
| Email + password sign-up | On (`enable_signup = true`) | On |
| Email confirmations | Off (`[auth.email] enable_confirmations = false`) | **On** |
| Minimum password length | 8 | 8 |
| Session timebox | 720h (30 days); inactivity timeout unset | 720h if the plan offers it |
| Refresh token rotation | On | On |
| JWT expiry | 3600s (default) | Default |

The app also stores sign-in time under the local key `qd_signed_in_at` and signs out once `clock.now()` is more than 30 days later, so AU-1.2 still holds if the hosted plan does not offer session time-boxing.

Site URL (local): `http://127.0.0.1:3000`

Redirect allow-list must include the confirmation landing URL:

- `http://127.0.0.1:3000/onboarding`
- `http://localhost:3000/onboarding`
- the hosted origin + `/onboarding`

Sign-up passes `emailRedirectTo` as the app's `/onboarding` URL so the confirmation link returns into the app.

## Architecture

See [architecture.md](architecture.md).
