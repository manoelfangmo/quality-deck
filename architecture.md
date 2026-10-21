# Application architecture

This guide explains how the Field Notes app is structured. The **projects** feature is the main example, with **estimates** and **scheduling** covering the two places the app does something unusual: price snapshots and Google Calendar sync. Open those features while you read.

Setup, environment files, and how to run the app and the local Supabase stack are in the [README](README.md). The tables themselves are described in the Part 1 data model doc.

## The idea

The app is Flutter built for the web and used mostly in Safari on Moises's iPhone and iPad. It is online only: there is no local database and no offline queue.

Each product area is a **feature**. A feature owns its screens, its state, its business rules, and its database access. Shared infrastructure lives in `app/lib/core/`. That includes routing, theme, the Supabase client, money and length value types, address formatting, and widgets used by many features.

Inside a feature, code is split into four layers. A widget never talks to Supabase. A repository never builds UI.

```
presentation   screens, widgets, and the state those widgets watch
      │
      ▼
application    coordinates more than one repository, or more than one step
      │
      ▼
data           Supabase queries, RPC calls, storage uploads
      │
      ▼
domain         the types those layers pass around
```

Dependencies point downward. `domain` imports none of the other three. `data` imports `domain`. `application` imports `data` and `domain`. `presentation` may use all three.

## Where the code lives

```
app/lib/
├── main.dart                 # starts Supabase, then runs App
├── app.dart                  # MaterialApp.router wired to goRouterProvider
├── core/
│   ├── constants/            # theme, breakpoints, environment (Supabase URL / anon key)
│   ├── database/             # table, column, RPC and bucket names (ClientsTable, ProjectsTable, Rpc, …)
│   ├── domain/               # types shared by several features: Money, Length, Address, PriceUnit, AppUser
│   ├── routing/              # GoRouter, AppRoutes, route base classes
│   ├── utils/                # providers.dart (Supabase client, clock), extensions, toasts, autosave debouncer
│   └── widgets/              # buttons, search field, tap-to-call/email/maps, empty/error states, reorder list
└── features/
    ├── auth/                 # AU: sign-in, sign-up, sign-out
    ├── business/             # AU: onboarding, members, invites
    ├── clients/              # CL: client list, search, client page, duplicate check
    ├── projects/             # PJ, JB: pipeline, project page, jobs, status history
    ├── scheduling/           # SC: appointments, Google Calendar connection and sync state
    ├── onsite/               # ON: notes, measurements, deck details, photos
    ├── pricing/              # PR: price categories and items
    ├── estimates/            # ES: line items and totals on a job
    └── settings/             # members, invites, calendar connection, sign-out

supabase/
├── config.toml
├── migrations/               # schema, RLS policies, triggers, RPC functions
├── functions/
│   └── calendar-sync/        # the one Edge Function: talks to Google Calendar
└── seed.sql                  # Quality Deck + Other Co, owners/members, invite codes
```

Every feature uses the same four folders. A small feature can leave out `application/` when nothing needs to coordinate more than one repository. `settings` is `presentation/` only: it composes `business` widgets for members and invites, reads the calendar connection through `scheduling`'s repository, and signs out through `auth`'s.

`app/lib/core/domain/` is for types that more than one feature needs. `Address` is used by clients, projects and scheduling. `Money` and `PriceUnit` are used by pricing and estimates. `Length` is used by onsite and estimates. A type used by only one feature stays in that feature's `domain/`.

## One business, walled off

Every table carries `business_id`, and every RLS policy limits rows to the signed-in user's business through one SQL helper, `current_business_id()`, which reads `memberships.business_id` for `auth.uid()`. `users` holds only who someone is; `memberships` holds which business they belong to and their role. A user without a membership row is signed up but not in a business yet. Part 1 is one business per user (`memberships.user_id` is the primary key). Nothing in Dart assumes a particular business or that a user always has one.

The app never sends `business_id`. Inserts leave it out and a column default of `current_business_id()` fills it in; RPCs read it from the caller. Repositories never filter by it either: RLS already did. If a query seems to need `.eq('business_id', …)`, the policy is wrong.

`AppUser` in `core/domain/` is the signed-in user with an optional `Membership` (business id and role). `currentUserProvider` in `auth` loads it after sign-in, is `keepAlive`, and reloads when the tab becomes visible and every 5 minutes so a removed member is signed out promptly.

## Projects, folder by folder

```
features/projects/
├── domain/
│   ├── client_ref.dart               # the client fields a project shows (name, phone, email)
│   ├── project.dart                  # project record: title, site address, status, archived_at
│   ├── project_status.dart           # lead / onsite_scheduled / onsite_done / proposal_sent / won / lost
│   ├── project_status_event.dart     # one row of status history (PJ-3)
│   ├── job.dart                      # one priced scope inside a project
│   ├── job_type.dart                 # deck / patio / hardscaping
│   ├── job_status.dart               # proposed / accepted / declined / in_progress / complete
│   └── suggested_title.dart          # "Melgar – Deck – 123 Oak St"
├── data/
│   ├── projects_repository.dart      # projects, status history, archive / restore
│   ├── jobs_repository.dart          # jobs, reorder, accept / decline
│   └── models.dart                   # CreateProjectCommand, CreateJobCommand, …
├── application/
│   └── project_service.dart          # create a project (with first job, optional visit); create from visit
└── presentation/
    ├── projects_page.dart            # home tab: this week's appointments, then the pipeline
    ├── project_page.dart             # client card, appointments, onsite, jobs
    ├── routes.dart                   # ProjectRoute(projectId)
    ├── controllers/                  # Riverpod notifiers and combined providers
    ├── models/                       # state that exists only for the UI
    ├── validators/
    └── widgets/
```

Open `projects_page.dart` first. It is the home screen (PJ-4). The top section watches `upcomingAppointmentsProvider` from `scheduling`; the pipeline below it watches `pipelineProvider`. The page itself fetches nothing.

## Reading data: the pipeline

The pipeline needs projects filtered by status, job type and a search term, each row with its client, job count and next appointment. The filters come from UI state. The rows come from the repository. A controller combines them.

```
PipelineList
  watches pipelineProvider
    watches pipelineFilterControllerProvider    → status, job type, search text (UI state)
    watches projectRowsProvider(filter)         → ProjectsRepository.fetchPipeline
  builds List<ProjectRow>
```

```dart
@riverpod
Future<List<ProjectRow>> pipeline(Ref ref) async {
  final filter = ref.watch(pipelineFilterControllerProvider);
  return ref.watch(projectRowsProvider(filter.toQuery()).future);
}
```

`projectRowsProvider` is a **family** provider: each distinct filter is its own cache, so flipping between "Won" and "All" does not refetch. The widget handles loading, data, and error in one place:

```dart
Widget build(BuildContext context, WidgetRef ref) {
  final rows = ref.watch(pipelineProvider);

  return rows.when(
    data: (rows) => _buildList(context, rows),
    loading: () => const Center(child: CircularProgressIndicator()),
    error: (err, stack) => ErrorRetry(
      onRetry: () => ref.invalidate(projectRowsProvider),
    ),
  );
}
```

The repository is the only class that knows table names, columns, and view names. The pipeline reads the `project_rows` view, which joins the client, counts jobs and picks the next scheduled appointment in SQL, so the list is one query:

```dart
Future<List<ProjectRow>> fetchPipeline(PipelineQuery query) async {
  var q = _supabase
      .from(ProjectRowsView.name)
      .select()
      .isFilter(ProjectRowsView.archivedAt, null);

  if (query.status != null) q = q.eq(ProjectRowsView.status, query.status!.toDb());
  if (query.jobType != null) q = q.contains(ProjectRowsView.jobTypes, [query.jobType!.toDb()]);
  if (query.search.isNotEmpty) q = q.ilike(ProjectRowsView.searchText, '%${query.search}%');

  final rows = await q.order(ProjectRowsView.statusChangedAt, ascending: false);
  return rows.map(ProjectRow.fromJson).toList();
}
```

`Project` is the domain type. `ProjectRow` is the presentation type: exactly what one row of the list draws. Domain types describe the business. Presentation models describe what one screen needs to render.

A project never stores the client's name, phone or email. `Project.client` is a `ClientRef` read through a join (`select('*, client:clients(id, full_name, phone, email)')`), so a fix on the client page shows on every project at once (CL-3, PJ-1). The site address is the opposite: it is copied onto the project when the project is created and is the project's own from then on.

A simpler read skips the controller. The client page watches `clientProjectsProvider(clientId)`, which calls `ProjectsRepository.fetchForClient` directly. Use a controller when the widget needs data assembled from more than one provider. Use the repository provider when one query is the whole story.

## Writing data: two patterns

### One repository, one call

Archiving a project is a single update. The project page's menu calls the repository, then invalidates what showed the old value:

```dart
await ref.read(projectsRepositoryProvider).archive(projectId);
ref.invalidate(projectRowsProvider);
ref.invalidate(clientProjectsProvider);
```

Moving a project's status by hand calls `ProjectsRepository.setStatus(projectId, status)` the same way, through the `set_project_status` RPC, which writes the `project_status_events` row in the same transaction. Accepting or declining a job is `JobsRepository.decide(jobId, JobStatus.accepted)`. The project's move to Won or Lost is not Dart's job: a trigger on `jobs` does it and logs the event with reason `job_decision` (JB-2). After a job decision, invalidate the project too, because its status may have changed underneath it.

`ref.watch` subscribes and rebuilds. `ref.read` fires an action and does not subscribe. `ref.invalidate` drops the cached value so the next watch refetches.

### Several steps, or data from another feature

Creating a project needs a client (which `clients` owns), a first job (JB-1: every project has at least one), and sometimes an onsite visit booked in the same step (PJ-1), which `scheduling` owns. That belongs in `ProjectService`:

```dart
Future<String> createProject(CreateProjectForm form) async {
  final projectId = await ref.read(projectServiceProvider).createProject(
        clientId: form.clientId,
        title: form.title.trim(),
        siteAddress: form.siteAddress,
        firstJob: form.firstJob,
        visit: form.visit, // null unless "Book onsite visit" was filled in
      );
  ref.invalidate(projectRowsProvider);
  ref.invalidate(clientProjectsProvider);
  ref.invalidate(upcomingAppointmentsProvider);
  return projectId;
}
```

The service builds a `CreateProjectCommand` and calls one RPC, `create_project`, which inserts the project and its first job and, when a visit is given, the appointment, all in one transaction. The starting status (Lead, or Onsite scheduled) is decided in SQL. If a visit was booked, the service then asks `scheduling` to sync it (see below); a sync failure does not undo the project.

`createProjectFromVisit(appointmentId)` (PJ-2) is the same shape: the RPC reads the appointment's client, copies the client's address onto the project, links the appointment, and starts the project at Onsite scheduled or Onsite done depending on whether the visit has passed.

Put logic in `application/` when it:

- calls more than one repository, or
- runs several repository calls that must succeed as one user action, or
- decides something from data owned by another feature.

When the steps must all succeed or all fail, make them one RPC and let the service call it once. Dart cannot hold a Postgres transaction open.

## Estimates: prices are copied, not referenced

`features/estimates/` owns line items on a job. The rule that shapes it is ES-7: editing or deactivating a price item never changes an estimate that already uses it.

A line item therefore copies the price item's name, unit, price and minimum charge when it is added, through the `add_line_item` RPC, which also refuses inactive items (PR-4). After that, the line keeps `price_item_id` only for reference. `override_unit_price_cents` holds a per-job override (ES-4); clearing it is the reset. A custom line (ES-5) has no `price_item_id` at all.

The math lives in two places on purpose. `line_total_cents` and `minimum_applied` are generated columns in Postgres, which are the numbers the database and Part 2 trust. `LineItem.total` in `domain/` computes the same thing from the same fields, so the quantity field can show a new total while the update is still in flight (ES-3). A test in `estimates/domain/` holds the two formulas to the same answers.

```dart
Money get effectiveUnitPrice => overrideUnitPrice ?? savedUnitPrice;

Money get total {
  final raw = effectiveUnitPrice * quantity;
  return raw < minimumCharge ? minimumCharge : raw;
}

bool get minimumApplied => effectiveUnitPrice * quantity < minimumCharge;
```

`Money` is integer cents with arithmetic, rounding and formatting; there are no `double` dollars anywhere in the app. Job and project totals are read from the `job_totals` and `project_totals` views, never summed in a widget.

ES-8 (fill a quantity from a measurement) is the one place `estimates` reads `onsite`: the add-line sheet watches `projectMeasurementsProvider(projectId)` and offers the area entries whose unit matches. The line keeps `measurement_id` so Part 2 can see where the number came from.

## Scheduling and Google Calendar

`features/scheduling/` owns appointments and the calendar connection. Sync is one way, app to Google (SOW Sections 4 and 10), and it never runs in the browser: the Google refresh token must not reach the client.

```
App                         Postgres                          Edge Function
──────────────────────────  ────────────────────────────────  ──────────────────────────
book / move / cancel  ───►  RPC writes the appointment,
                            sync_state = pending,
                            sync_action = create|update|cancel
invoke calendar-sync  ───────────────────────────────────────► reads the row, builds title,
                                                               location, description,
                                                               calls Google
                            sync_state = synced | failed  ◄─── writes the result
refetch appointment   ───►
```

`AppointmentService.book` (and `reschedule`, `cancel`) calls the RPC, then invokes `calendar-sync` with the appointment id, then invalidates the appointment. The row is never marked synced until Google answered (SC-7). A failed sync leaves `sync_state = failed` and `sync_error` set; the appointment tile shows the error and a Retry button that invokes the function again with the same id. Retry is safe to repeat: the function reads `sync_action` and `google_event_id` and does whatever is still owed.

The function builds the event title ("Onsite visit – [client]"), location (the project's site address, else the client's address) and description (the client's phone) from the current rows at sync time, so a client fix goes out on the next reschedule (CL-3). It invites `invitee_email`; when the client has no email the app warns first and the event goes on Moises's calendar only (SC-8).

The rules that keep appointments consistent are in SQL: the project must belong to the appointment's client (a composite foreign key), check-ins need a project that is Won (SC-3), and booking an onsite visit on a Lead project moves it to Onsite scheduled (SC-2).

`calendar-sync` is the only Edge Function. It exists because it holds a secret and calls a third party. Business rules still belong in SQL functions, not in Edge Functions.

## Onsite capture

`features/onsite/` owns notes, measurements, deck details and photos. All four require a project (ON-1); an optional `appointment_id` tags each to the visit it came from (ON-6). These are what Part 2's AI draft reads, so they are structured rows, not free text.

Notes autosave (ON-1). `NoteEditorController` holds the text and writes through `AutosaveDebouncer` from `core/utils/` 800 ms after the last keystroke and again when the editor loses focus or the route is popped. A dropped signal loses at most the last pause's worth of typing. The editor shows "Saving…" and "Saved" from the controller's state, and a failed save keeps the text on screen with Retry.

Measurements are entered in feet and inches and stored in inches. `Length` in `core/domain/` parses and formats `16' 6"`; the square-foot or linear-foot `quantity` is a generated column, and `Measurement.quantity` mirrors it for the live preview, as with line totals.

Photos (ON-4) are resized in the browser before upload so they finish on a cell connection: longest edge 2048 px, JPEG quality 0.8. `PhotoUploadController` uploads several at once to the `project-photos` storage bucket under `{business_id}/{project_id}/{photo_id}.jpg`, reports progress per file, and inserts the `photos` row only after the upload succeeds. Deleting removes the row and the file through `PhotosRepository.delete`. Storage policies mirror the table's RLS on the path's first segment.

## What each layer is allowed to do

| Layer | Put it here | Leave it out |
| --- | --- | --- |
| `presentation/` | Widgets, route classes, form state, validators, UI-only models | Supabase calls, multi-step workflows |
| `application/` | Services that order repository calls or combine features | Widgets, `BuildContext` |
| `data/` | Repositories, command objects, storage uploads, Edge Function invocations | UI state, navigation |
| `domain/` | Entities, value objects, pure rules (`LineItem.total`, `suggestedTitle`) | Flutter, Supabase, Riverpod |

Table, view, column, RPC and bucket names are not string literals scattered through repositories. They live on classes in `app/lib/core/database/`, for example `ProjectsTable.siteStreet`, `ProjectRowsView.nextAppointmentAt`, `Rpc.createProject` and `Buckets.projectPhotos`.

A repository or service method with more than two or three parameters takes one **command** object, defined next to the repository in `data/models.dart`. `CreateProjectCommand` is the projects example: the service builds it, and `toJson()` keys are the RPC's argument names (`Rpc.pClientId` and the rest).

## Riverpod

State and dependency injection both go through Riverpod code generation. Annotate a function or class, then run build_runner. The generated `*.g.dart` file creates the provider (`pipeline` becomes `pipelineProvider`).

| Annotation | What you get | Field Notes example |
| --- | --- | --- |
| `@riverpod` on a `Future` function | Async provider, disposed when nothing watches it | `clientProjects`, `projectMeasurements` |
| `@riverpod` with an extra argument | Family provider, one cache per argument | `projectRows(filter)`, `jobLineItems(jobId)` |
| `@riverpod` on a class extending the generated notifier | Mutable state, usually a form or view selection | `PipelineFilterController`, `NoteEditorController` |
| `@Riverpod(keepAlive: true)` | Provider that survives after the last listener | `supabase`, `currentUser`, `projectService` |

Widgets that read providers extend `ConsumerWidget` or `ConsumerStatefulWidget`.

Repositories and services are constructed by providers, not by `new` at the call site:

```dart
@riverpod
ProjectsRepository projectsRepository(Ref ref) {
  final SupabaseClient supabase = ref.read(supabaseProvider);
  return ProjectsRepository(supabase);
}
```

`supabaseProvider` in `app/lib/core/utils/providers.dart` is the one Supabase client. Features depend on that provider. They do not call `Supabase.instance` themselves.

`clockProvider` in the same file returns the current time. Anything that asks "is this visit in the past" or "what is today" reads `clockProvider`, never `DateTime.now()`, so tests can freeze time. That includes the this-week appointment list and the create-from-visit status choice.

After you add or change a `@riverpod`, `@freezed`, `@JsonSerializable`, or `@GenerateNiceMocks` annotation, regenerate from the project root:

```sh
dart run build_runner build --delete-conflicting-outputs
```

Do not edit `*.g.dart`, `*.freezed.dart`, or `*.mocks.dart`. Change the source file and regenerate.

## Tests

Tests live in `app/test/`, mirroring `app/lib/`, and run with `flutter test`. Nothing in the suite talks to a running Supabase stack or to Google.

Test doubles come from **mockito**, not from hand-written fakes. `app/test/mocks.dart` carries one annotation for the whole suite and re-exports what `build_runner` generates:

```dart
@GenerateNiceMocks([
  MockSpec<AuthRepository>(),
  MockSpec<ClientsRepository>(),
  MockSpec<ProjectsRepository>(),
  MockSpec<AppointmentsRepository>(),
])
export 'mocks.mocks.dart';
```

When a new repository or service needs a double, add a `MockSpec` there and regenerate. Do not write a class that `implements` a repository by hand.

`GenerateNiceMocks` returns a harmless default from every member you do not stub, so a test only sets up the calls it is about. Inject the mock by overriding the provider that builds the real one:

```dart
final repository = MockAppointmentsRepository();
final container = ProviderContainer(
  overrides: [appointmentsRepositoryProvider.overrideWithValue(repository)],
);

when(repository.sync(any)).thenThrow(const AppException.calendarSyncFailed());

await container.read(appointmentServiceProvider).book(command);

verify(repository.sync(command.appointmentId)).called(1);
```

Two Riverpod behaviours trip people up in tests:

- An async provider does not start until something listens to it. Call `container.listen(provider, (_, _) {})` before awaiting `provider.future`, and pass `onError` when the test expects a failure.
- A provider that throws is retried ten times with a growing backoff, which outlasts the test timeout. Give `ProviderContainer` a `retry: (count, error) => null` when asserting on an error.

Pure rules get plain unit tests with no container: `LineItem.total`, `Length.parse`, `suggestedTitle`, and the start-status rule for create-from-visit.

## Domain models

`Project`, `Job`, `LineItem` and the rest are Freezed classes with `fromJson`. Freezed gives you `copyWith`, equality, and exhaustive cases on the status enums.

JSON field renaming is configured for the project (`field_rename: snake` in `build.yaml`), so `siteStreet` in Dart matches `site_street` from Postgres without a manual map at every call. Money arrives as integer cents and is wrapped in `Money` by a `JsonConverter`; lengths arrive as inches and are wrapped in `Length`. Timestamps arrive as UTC and are converted to local time in `fromJson`; command objects convert back to UTC in `toJson()`. Appointment times are shown in the business's time zone (`businesses.timezone`), not the device's.

Computed facts that depend only on the entity live on the domain type: `Appointment.isPast(now)`, `Appointment.end`, `Job.isDecided`, `Project.siteAddressLine`. Widgets read these. They do not reimplement the math.

## Routing

Signed-in sections are branches of one `StatefulShellRoute` in `app/lib/core/routing/go_router.dart`. Each branch has its own navigator key, so switching from Projects to Pricing keeps each tab's scroll position and filters. The branches are `/projects`, `/clients`, and `/pricing`, in that order, and the bar draws them in the same order. The shell widget is `HomePage`, which draws a bottom navigation bar on a phone and a navigation rail on an iPad or desktop.

Path strings live in `AppRoutes` (`app/lib/core/routing/app_routes.dart`). The router's `redirect` does two things:

- sends signed-out users to sign-in, from any page (AU-1)
- sends signed-in users without a business to onboarding, and signed-in users with a business away from the public pages and onboarding

`AppRoutes.publicRoutes` lists the pages that work without a session: sign-in, sign-up, and check-email. The router is built once in a provider and refreshed through `refreshListenable` when `currentUserProvider` changes. It is never rebuilt on each change.

Routes that take parameters are classes in the feature, not inline `GoRoute`s. Each extends `ParamAppRoute` or `SimpleAppRoute` from `app/lib/core/routing/routing_interfaces.dart` and lives in that feature's `presentation/routes.dart`. `ProjectRoute(projectId)` and `ClientRoute(clientId)` are pushed onto whichever branch the user is in, so opening a project from the Clients tab keeps you in Clients. Settings is a `SimpleAppRoute` reached from the app bar.

## Mobile first

Every screen must work in Safari on an iPhone with no sideways scrolling, and with touch targets of at least 44 × 44 points. Build each page at phone width first; `core/constants/breakpoints.dart` defines where the iPad layout takes over (the project page shows its sections side by side above 900 px). Phone and email are tap-to-call and tap-to-email links and addresses open Maps, through `ContactLink` in `core/widgets/` rather than per-feature `url_launcher` calls. Reordering (jobs, line items) uses `ReorderList` from `core/widgets/`, which drags on an iPad and shows move up and down buttons on a phone (ES-6).

## How a new feature should look

1. Create `app/lib/features/<name>/domain/` with the entities. Use `@freezed` when the type is sent to or from JSON, or when the UI copies it. If another feature needs the type, put it in `app/lib/core/domain/` instead.
2. Create `data/<name>_repository.dart`. Take `SupabaseClient` in the constructor. Expose a `@riverpod` provider that reads `supabaseProvider`. Add a `Future` provider per read the UI needs. Add table and column constants to `app/lib/core/database/`.
3. Add an `application/` service only when a user action needs more than one repository call or another feature's data.
4. Build the page as a `ConsumerWidget` that composes smaller widgets. Each widget watches the provider it renders.
5. Keep form drafts and view selections in a notifier under `presentation/controllers/`. Submit through the service or, for a single call, through the repository. Then `ref.invalidate` every provider that displayed the old value.
6. Add a class in `presentation/routes.dart` for a page that takes arguments, and the path to `AppRoutes`. A new main tab means a shell branch in `go_router.dart` and a destination in `HomePage`.

Features are built in this order, so each one only depends on what already exists:

1. `auth`, `business`, `clients`
2. `pricing`, handed to Moises to start entering prices
3. `projects` (projects and jobs)
4. `scheduling`, which needs only clients and can run alongside step 3
5. `onsite`
6. `estimates`, which needs pricing and jobs

## Backend

The app talks to Supabase directly. There is no application server; queries, RPCs and storage calls are made from repositories, and the one Edge Function is invoked from `AppointmentsRepository`. Locally the stack runs through the Supabase CLI (`supabase start`).

Schema, RLS policies, triggers and SQL functions live in `supabase/migrations/`. Apply them with `supabase db reset` locally. Rules the database must enforce belong in SQL, called with `supabase.rpc(...)` or run as triggers:

- `create_business` and `redeem_invite` are the only paths that create a membership. `create_invite`, `revoke_invite`, and `remove_member` are owner-only. The client never writes `memberships`, `businesses`, or `invites` directly.
- `create_project` and `create_project_from_visit` create a project with its first job and any visit in one transaction.
- `set_project_status` changes a status by hand; a trigger on `projects.status` writes every `project_status_events` row, so no path can change status without a time stamp (PJ-3).
- A trigger on `jobs.status` moves the project to Won when any job is accepted and Lost when every job is declined (JB-2).
- `book_appointment`, `reschedule_appointment` and `cancel_appointment` write the row and mark it `pending`; only `calendar-sync` marks it `synced` or `failed`. Canceled appointments are kept (SC-5).
- `add_line_item` copies the price item's values and refuses inactive items (PR-4, ES-7).

Clients have no direct `DELETE` on `projects`, `appointments` or `price_items`: projects archive, appointments cancel, price items deactivate. Photos and line items are the only rows the app deletes.

Each function raises a stable token with an application-defined SQLSTATE in class `Q0`, listed at the top of the migration that adds it. Repositories map those codes to an `AppException` with copy a widget can show (for example, "Check-ins can be booked once a job is accepted"). `supabase/tests/rls_check.sql` is the manual script that signs in as users of two different businesses and confirms neither can read the other's rows.

`calendar-sync` reads the Google refresh token from `google_calendar_connections` with the service role key, which only Edge Functions hold. Set `GOOGLE_CLIENT_ID` and `GOOGLE_CLIENT_SECRET` with `supabase secrets set`; the README covers the local `.env` for `supabase functions serve`.

Data export (SOW Section 8) is a SQL script in `supabase/scripts/export_business.sql` that dumps every table filtered by one `business_id`, plus the photos under that business's prefix in the `project-photos` bucket.