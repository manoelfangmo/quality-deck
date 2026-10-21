import 'package:clock/clock.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:mockito/mockito.dart';
import 'package:timezone/data/latest.dart' as tzdata;

import 'package:app/core/routing/app_routes.dart';
import 'package:app/core/utils/providers.dart';
import 'package:app/features/business/presentation/controllers/current_business.dart';
import 'package:app/features/clients/data/clients_repository.dart';
import 'package:app/features/estimates/data/jobs_repository.dart';
import 'package:app/features/projects/data/projects_repository.dart';
import 'package:app/features/projects/domain/project_view.dart';
import 'package:app/features/projects/presentation/controllers/projects_table.dart';
import 'package:app/features/projects/presentation/project_page.dart';
import 'package:app/features/projects/presentation/projects_page.dart';

import '../../../helpers/fixtures.dart';
import '../../../helpers/photo_overrides.dart';
import '../../../mocks.dart';

void main() {
  late MockProjectsRepository projects;
  late MockClientsRepository clients;
  late MockJobsRepository jobs;

  setUpAll(tzdata.initializeTimeZones);

  setUp(() {
    projects = MockProjectsRepository();
    clients = MockClientsRepository();
    jobs = MockJobsRepository();
    when(projects.fetchAll(view: ProjectView.active)).thenAnswer(
      (_) async => [melgarOak, removedClientRow],
    );
    when(
      projects.fetchAll(view: ProjectView.archived),
    ).thenAnswer((_) async => [archivedMelgar]);
    when(projects.fetchOne(melgarOak.id)).thenAnswer((_) async => melgarOak);
    when(clients.search(any, limit: anyNamed('limit'))).thenAnswer(
      (_) async => [anaMelgar],
    );
    when(jobs.fetchForProject(any)).thenAnswer((_) async => []);
  });

  Future<GoRouter> pumpPage(WidgetTester tester) async {
    tester.view.physicalSize = const Size(1800, 900);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    final router = GoRouter(
      initialLocation: AppRoutes.projects,
      routes: [
        GoRoute(
          path: AppRoutes.projects,
          builder: (context, state) =>
              const Scaffold(body: ProjectsPage()),
          routes: [
            GoRoute(
              path: ':${AppRoutes.projectIdParam}',
              builder: (context, state) => ProjectPage(
                projectId: state.pathParameters[AppRoutes.projectIdParam]!,
              ),
            ),
          ],
        ),
      ],
    );

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          projectsRepositoryProvider.overrideWithValue(projects),
          clientsRepositoryProvider.overrideWithValue(clients),
          jobsRepositoryProvider.overrideWithValue(jobs),
          currentBusinessProvider.overrideWith((ref) async => qualityDeck),
          clockProvider.overrideWithValue(
            Clock.fixed(DateTime.utc(2026, 10, 20, 18)),
          ),
          projectRowsProvider(ProjectView.active).overrideWith(
            (ref) => ref.watch(projectsRepositoryProvider).fetchAll(
              view: ProjectView.active,
            ),
          ),
          projectRowsProvider(ProjectView.archived).overrideWith(
            (ref) => ref.watch(projectsRepositoryProvider).fetchAll(
              view: ProjectView.archived,
            ),
          ),
          ...jobPhotoTestOverrides(),
        ],
        child: MaterialApp.router(routerConfig: router),
      ),
    );
    await tester.pumpAndSettle();
    return router;
  }

  testWidgets('Active shows Archive and the Created column', (tester) async {
    await pumpPage(tester);

    expect(find.text('Created'), findsOneWidget);
    await tester.tap(find.byIcon(Icons.more_horiz).first);
    await tester.pumpAndSettle();
    expect(find.text('Archive'), findsOneWidget);
    expect(find.text('Unarchive'), findsNothing);
  });

  testWidgets('Archived shows Unarchive and the Archived column', (tester) async {
    await pumpPage(tester);

    await tester.tap(find.text('Archived'));
    await tester.pumpAndSettle();

    expect(find.text('Archived'), findsWidgets);
    expect(find.text('Created'), findsNothing);
    await tester.tap(find.byIcon(Icons.more_horiz).first);
    await tester.pumpAndSettle();
    expect(find.text('Unarchive'), findsOneWidget);
    expect(find.text('Archive'), findsNothing);
  });

  testWidgets('a row tap goes to ProjectRoute with the project id in the url', (tester) async {
    final router = await pumpPage(tester);

    await tester.tap(find.text('Melgar – 12 Oak St'));
    await tester.pumpAndSettle();

    expect(router.state.uri.path, '/projects/${melgarOak.id}');
  });

  testWidgets('a removed client shows (removed)', (tester) async {
    await pumpPage(tester);

    expect(find.text('Old Client One (removed)'), findsOneWidget);
  });
}
