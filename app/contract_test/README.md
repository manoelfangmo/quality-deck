# Writing contract tests

This file is the source of truth for Field Notes contract tests.
It is written for an AI implementing tests, and for a human reviewing them.

A contract test proves that a **data-layer method still matches a real backend**:
request shape, auth/RLS, RPC/view/function behavior, and response mapping onto
domain types. It is not a unit test and not a UI integration test.

## What each kind of test owns

| Kind | Hits a real backend? | What it exercises | Where it lives |
| --- | --- | --- | --- |
| Unit | No. Mocks / in-memory data. | Application logic, widgets, mapping, providers. | `app/test/` |
| Contract | Yes. Local backend in CI. | One repository method against DB / RPC / Edge Function. | `app/contract_test/` |

If the code under test never talks to the backend, it is not a contract test.
If the code under test is a widget or a Riverpod provider, it is not a contract test.

## When to add one

Write a contract test when you:

- Add or change a repository method that calls a table, view, RPC, or Edge Function.
- Change RPC parameter names, view columns, JSON keys, or RLS that the client relies on.
- Add a create/seed path that other contract tests will use.

Do **not** write a contract test for:

- Widget rendering, form validation, or navigation.
- Provider / service logic that can be unit-tested with a mocked repository.
- Calendar-provider redirects, email inboxes, OTP, or anything that needs a browser.
- Read-modify-write that you cannot restore (see Cleanup).

## Hard rules

1. **Real backend, real repository.** Construct the production repository with a real client. Do not mock the repository, the SDK, or HTTP.
2. **No app, no widget, no Riverpod.** Do not call `Supabase.initialize()`, `runApp`, or `ProviderContainer`. Construct `SupabaseClient(url, anonKey)` with `AuthFlowType.implicit` so the test is plain Dart on a VM — no Chrome, no `flutter drive`. PKCE needs async storage that only `Supabase.initialize()` installs; without implicit flow, `signUp` asserts.
3. **One file per repository.** Name it `<repository>_repository_test.dart`. Group tests by method: `group('FooRepository.bar', ...)`.
4. **Tag every file.**
   ```dart
   @Tags(<String>['contract'])
   library;
   ```
   Register the tag in the Flutter package's `dart_test.yaml` so the runner does not warn:
   ```yaml
   tags:
     contract:
       description: Hits a real backend; requires --dart-define-from-file
   ```
5. **Keep them out of `test/`.** `flutter test` (unit CI) must not pick them up. Run them with an explicit path:
   ```sh
   flutter test contract_test/ \
     --dart-define-from-file contract_test.env
   ```
6. **Sign in as a seeded user** whose password is known. RPCs and RLS resolve the actor from `auth.uid()`, so the session **is** the test fixture.
7. **Unique data every run.** Stamp emails / names with `DateTime.now().microsecondsSinceEpoch` so reruns and parallel files do not collide.
8. **Clean up everything you create or mutate.** Created auth users: service-role `auth.admin.deleteUser`. Mutated seed rows: snapshot in `setUpAll`, restore in `tearDown`. Swallow cleanup errors and log them; never fail the test in teardown.
9. **Assert on domain types** returned by the repository (`Client`, `Business`, `PriceItem`), not raw JSON and not SQL.
10. **Arrange through the same public API when you can.** If the arrange step is itself a repository method, test that method in its own file first so a break there is obvious rather than inferred three layers up.

## This repo's layout

```
app/contract_test/
  README.md                              # this playbook
  helpers.dart                           # sign-in + arrange helpers
  clean_up.dart                          # service-role teardown / restore
  test_env.dart                          # SERVICE_ROLE_KEY reader
  auth_repository_test.dart              # create path other tests depend on
  business_repository_test.dart          # RPC create / redeem / remove + rename
  invites_repository_test.dart           # view + create / revoke RPCs
  clients_repository_test.dart           # table insert / update + remove RPC
  pricing_repository_test.dart           # snapshot seed row, mutate, restore
  price_items_repository_test.dart       # catalog read + write / delete
  appointments_repository_test.dart      # RPC add / update / remove
  projects_repository_test.dart          # view read + create / archive / unarchive RPCs
app/example.contract_test.env            # committed shape; real file is gitignored
app/dart_test.yaml                       # registers the `contract` tag
.github/workflows/contract-tests.yml
```

The tests import `package:app/...`. Repositories take a `SupabaseClient` in the
constructor, which is what makes this possible without Riverpod.
`AuthRepository` also needs `LocalSettings` and a `Clock` — pass
`MemoryLocalStore` and `const Clock()`, never the web store.

The backend lives in this same repo under `supabase/`. There is no second
repository to check out.

Env vars:

```
SUPABASE_URL=
SUPABASE_ANON_KEY=
SUPABASE_SERVICE_ROLE_KEY=
```

Copy `app/example.contract_test.env` to `app/contract_test.env` (gitignored).
Values come from `supabase status` against the local stack started from this
repo's `supabase/` directory.

Seeded users (must exist in `supabase/seed.sql`; tests never create these):

| Role | Email | Password | Id |
| --- | --- | --- | --- |
| Quality Deck owner | `owner@qualitydeck.test` | `password123` | `00000000-0000-4000-8000-000000000001` |
| Quality Deck member | `crew@qualitydeck.test` | `password123` | `00000000-0000-4000-8000-000000000002` |
| Other Co owner | `other@example.test` | `password123` | `00000000-0000-4000-8000-000000000003` |
| Signed up, no membership | `nobusiness@example.test` | `password123` | `00000000-0000-4000-8000-000000000004` |
| Signed up, no membership | `joiner@example.test` | `password123` | `00000000-0000-4000-8000-000000000005` |

Quality Deck id: `00000000-0000-4000-8000-000000000011`.

Do **not** redeem seed invite `QDACTIVE`, rename Other Co, or remove the seeded
crew member. Those rows are shared fixtures.

## Helpers

`helpers.dart` owns sign-in and arrange. `clean_up.dart` owns teardown.

**Authenticated client** — anon key + password grant, not the service role.
Repository calls must run as the user so RLS is part of the contract.

```dart
Future<SupabaseClient> signInAsSeededOwner() {
  return signInAs(SeedUsers.ownerEmail, SeedUsers.password);
}
```

`signInAs` builds `SupabaseClient` from `Environment.supabaseUrl` /
`Environment.supabaseAnonKey` with `AuthFlowType.implicit`, then calls
`AuthRepository.signIn`. Implicit flow is required: `signUp` uses PKCE
unless async storage is installed, and that storage only appears after
`Supabase.initialize()` — which these tests must not call.

Fail `setUpAll` loudly if URL / anon / service-role keys are missing. A
contract test that silently skips is worse than a red test.

**Service-role client** — only in cleanup helpers, never passed into a
repository under test. Needed for `auth.admin.deleteUser` and for writes that
RLS or a non-writable view would block.

```dart
final _admin = SupabaseClient(TestEnv.supabaseUrl, TestEnv.serviceRoleKey);
```

## Lifecycle

```dart
void main() {
  late SupabaseClient supabase;
  late FooRepository repository;
  late ContractCleanup cleanup;

  setUpAll(() async {
    supabase = await signInAsSeededOwner();
    repository = FooRepository(supabase);
    cleanup = ContractCleanup();
    // snapshot shared seed rows here if this file mutates them
  });

  tearDown(() async {
    await cleanup.teardown();
  });

  tearDownAll(() async {
    await cleanup.dispose();
    await supabase.auth.signOut();
    await supabase.dispose();
  });
}
```

- `setUpAll`: one signed-in client for the file. Signing in per-test is wasted time.
- `tearDown`: restore after **each** test so tests in the same file cannot pollute each other.
- `tearDownAll`: dispose admin + user clients so the process does not hang.

Auth tests that sign in as different users (or create users) use a fresh client
per test and `cleanup.trackSession`.

## Cleanup patterns

Pick one. Do not invent a fourth. Extend `ContractCleanup` before writing a new class.

### A. Created auth users — track and delete

Use when the test (or an arrange helper) calls `signUp` / `createUser`.

Track the id **immediately** after create, before any assertion. If the
assertion fails, teardown still runs. Delete invites that reference the user
(`used_by`) and any business they own **before** `auth.admin.deleteUser` —
`businesses.owner_id` and `invites.used_by` have no `ON DELETE`.

### B. Mutated seed rows — snapshot and restore

Use when the test writes over a shared seeded business. Snapshot the domain
object (or the raw row) in `setUpAll`. Restore through the **tables**, not
through a repository method that would change `updated_by`.

Today: `snapshotQualityDeckName` / `snapshotQualityDeckPricing`.

### C. Non-writable view — admin writes the underlying table

Use when the repository reads a view but the test must arrange rows.
Service-role writes the base table; the repository still reads the view.

**Do not** arrange through SQL in the test file. Keep admin writes inside
`ContractCleanup` so every test uses the same restore path.

## What to test (arrange → act → assert)

One behavior per `test()`. Name it with the contract, not the implementation:
`returns null when the only appointment was removed`, not `calls maybeSingle`.

### Read of catalog / seed data

No create. Assert non-empty and a couple of invariants (Quality Deck row
present, Other Co hidden by RLS). Do not snapshot the whole catalog.

Canonical: `PriceItemsRepository.fetchAll`, `ClientsRepository.fetchAll`.

### Create that returns an id

Stamp the email, call the repository, `cleanup.trackUser(id)` (or the matching
`track*`), assert the id is a UUID.

Canonical: `AuthRepository.signUp`.

### Write then read back

Call the update, then fetch through the **same repository**, then compare field
by field against the command. For dates, compare year/month/day/hour/minute,
not `DateTime` equality (timezone / precision will flake).

Canonical: `ClientsRepository.update`, `PricingRepository.updateLaborRate`.

### Seed + create + read (RLS / `auth.uid()`)

Create a row as the signed-in owner, then read. Assert the created id is in
the result. Do not assert list length against the seed count — other files may
have inserted rows, and leftover rows from a crashed run may still be there.

Canonical: `ClientsRepository.fetchAll` after `create`.

### Null / empty contract

Read a seed row that is missing (or soft-deleted), then assert the repository
returns `null` (or hides the row). This is a contract: `maybeSingle` on a
filtered query must not throw.

Canonical: `AppointmentsRepository.fetchForClient` for Priya Shah (removed
appointment). `AuthRepository.fetchCurrentUser` with no session.

### Collections you just wrote

Compare as sets of ids, not list equality. Order is not part of the contract
unless the repository documents an order.

## What not to assert

- Raw JSON keys or PostgREST error strings (those are implementation).
- Exact list length against a shared seed user.
- Wall-clock timestamps, `DateTime` identity, or generated UUID values beyond "is a UUID".
- Other repository methods "while you're here". One method per group.
- UI strings, routes, or provider names.

## Isolation and parallelism

`flutter test contract_test/` runs files in parallel.

- Files may share the seeded owner **only if they mutate different tables**.
  Today: `pricing_repository_test` mutates `pricing_settings`;
  `business_repository_test` mutates `businesses.name` for Quality Deck;
  the others only insert new rows or new users.
- A second file that mutates the same seed row will flake. Use a freshly
  created user, or serialize those files.
- Do not redeem `QDACTIVE`, remove the seeded crew member, or edit seed
  clients / price items / appointments.
- Tests inside one file share one session. Restore in `tearDown`, not only in
  `tearDownAll`.

## File template

```dart
@Tags(<String>['contract'])
library;

import 'package:flutter_test/flutter_test.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'package:app/features/foo/data/foo_repository.dart';

import 'clean_up.dart';
import 'helpers.dart';

void main() {
  SupabaseClient? supabase;
  late FooRepository repository;
  late ContractCleanup cleanup;

  setUpAll(() async {
    supabase = await signInAsSeededOwner();
    repository = FooRepository(supabase!);
    cleanup = ContractCleanup();
  });

  tearDown(() async {
    await cleanup.teardown();
  });

  tearDownAll(() async {
    await cleanup.dispose();
    await supabase?.auth.signOut();
    await supabase?.dispose();
  });

  group('FooRepository.bar', () {
    test('persists bar and returns it on the next fetch', () async {
      final int stamp = uniqueStamp();

      await repository.bar(/* unique command using stamp */);

      final result = await repository.fetchBar();
      expect(result, isNotNull);
      expect(result!.someField, 'expected-$stamp');
    });
  });
}
```

## Workflow for an AI adding a test

Copy this checklist and complete it in order.

```
- [ ] 1. Read the repository method and note every backend call (table / view / rpc / function) and the domain type it returns.
- [ ] 2. Decide the contract: happy path, empty/null path, and nothing else unless RLS is the point of the method.
- [ ] 3. Choose cleanup A, B, or C. Extend ContractCleanup before writing a new class.
- [ ] 4. Add arrange helpers to helpers.dart only if another file will reuse them.
- [ ] 5. Create or extend `<repository>_repository_test.dart` with the template above.
- [ ] 6. Arrange with unique stamps. Track/snapshot before the first assertion.
- [ ] 7. Act through the repository. Assert on the domain type from a follow-up fetch (or the method's return value).
- [ ] 8. Run only that file against local Supabase.
- [ ] 9. Re-run it. A second pass must pass (cleanup actually restored / deleted).
```

Step 1 — find the call:

```text
_supabase.rpc(Rpc.createBusiness, ...)              → session (auth.uid()) is the input
_supabase.from(ClientRowsView.name).select          → view; deleted clients are hidden
_supabase.from(ClientsTable.name).insert            → table write; business_id from RLS default
```

Step 8 — local run (from `app/`):

```sh
# start backend (repo root)
supabase start
# copy example.contract_test.env → contract_test.env if you have not
cd app
flutter test contract_test/foo_repository_test.dart \
  --dart-define-from-file contract_test.env
```

If `signUp` fails with a generic "Database error creating new user", the
real error is in the Postgres container logs, not the test output.

## CI requirements

Contract tests are a separate workflow from unit tests. They must:

1. Check out **this repo** (app and `supabase/` are in the same tree). The job
   tests the schema in that checkout — never a different branch's migrations.
2. `supabase start` that checkout.
3. Export `SUPABASE_URL`, the anon key, and the service-role key from
   `supabase status -o env`.
4. Verify seed (`select count(*) from auth.users` ≥ 5).
5. Run `flutter test contract_test/` with those values as `--dart-define`s.
6. On failure, dump `docker logs` for `supabase_*` containers.
7. `supabase stop` in `if: always()`.

No Chrome, no chromedriver, no `flutter drive`. Timeout the job (~20 min) and
the test step (~10 min).

See `.github/workflows/contract-tests.yml`.

## Canonical files in this repo

| File | Pattern it demonstrates |
| --- | --- |
| `auth_repository_test.dart` | Create + UUID assert; independent coverage of the seeding path |
| `business_repository_test.dart` | Fresh user + RPC; snapshot/rename seed business |
| `invites_repository_test.dart` | View read + create/revoke RPC |
| `clients_repository_test.dart` | Table write then view read; RLS hides Other Co |
| `pricing_repository_test.dart` | Snapshot seed row, mutate, read back, restore |
| `price_items_repository_test.dart` | Catalog read + create/update/delete |
| `appointments_repository_test.dart` | Arrange via `ClientsRepository`, then RPC bound to `auth.uid()` |
| `helpers.dart` | Direct `SupabaseClient`, seeded sign-in, reusable arrange |
| `clean_up.dart` | User delete, row snapshot/restore |
| `.github/workflows/contract-tests.yml` | Local Supabase, same-repo schema, no browser |
