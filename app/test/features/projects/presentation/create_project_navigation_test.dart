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
import 'package:app/features/projects/data/projects_repository.dart';
import 'package:app/features/projects/domain/project_view.dart';
import 'package:app/features/projects/presentation/controllers/project.dart';
import 'package:app/features/projects/presentation/controllers/projects_table.dart';
import 'package:app/features/projects/presentation/project_page.dart';
import 'package:app/features/projects/presentation/projects_page.dart';

import '../../../helpers/fixtures.dart';
import '../../../mocks.dart';

void main() {
  late MockProjectsRepository projects;
  late MockClientsRepository clients;

  setUpAll(tzdata.initializeTimeZones);

  setUp(() {
    projects = MockProjectsRepository();
    clients = MockClientsRepository();
    when(
      projects.fetchAll(view: ProjectView.active),
    ).thenAnswer((_) async => [melgarOak]);
    when(
      projects.fetchAll(view: ProjectView.archived),
    ).thenAnswer((_) async => []);
    when(projects.create(any)).thenAnswer((_) async => 'new-project');
    when(projects.fetchOne('new-project')).thenAnswer((_) async => melgarOak);
    when(clients.search(any, limit: anyNamed('limit'))).thenAnswer(
      (_) async => [anaMelgar],
    );
  });

  testWidgets('create closes the sheet and opens the new project', (tester) async {
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
          currentBusinessProvider.overrideWith((ref) async => qualityDeck),
          clockProvider.overrideWithValue(
            Clock.fixed(DateTime.utc(2026, 10, 20, 18)),
          ),
          projectRowsProvider(ProjectView.active).overrideWith(
            (ref) => ref
                .watch(projectsRepositoryProvider)
                .fetchAll(view: ProjectView.active),
          ),
          projectProvider('new-project').overrideWith(
            (ref) async => melgarOak,
          ),
        ],
        child: MaterialApp.router(routerConfig: router),
      ),
    );
    await tester.pumpAndSettle();

    await tester.tap(find.widgetWithText(FilledButton, 'Add project'));
    await tester.pumpAndSettle();
    expect(find.text('New project'), findsOneWidget);

    await tester.tap(find.widgetWithText(ListTile, 'Ana Melgar'));
    await tester.pumpAndSettle();

    await tester.tap(find.widgetWithText(FilledButton, 'Create project'));
    await tester.pumpAndSettle();

    expect(find.text('New project'), findsNothing);
    expect(router.state.uri.path, '/projects/new-project');

    await tester.tap(find.byType(BackButton));
    await tester.pumpAndSettle();

    expect(router.state.uri.path, AppRoutes.projects);
    expect(find.text('Active'), findsOneWidget);
  });
}
