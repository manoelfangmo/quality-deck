import 'package:clock/clock.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:timezone/data/latest.dart' as tzdata;

import 'package:app/core/utils/providers.dart';
import 'package:app/features/business/presentation/controllers/current_business.dart';
import 'package:app/features/estimates/data/jobs_repository.dart';
import 'package:app/features/estimates/presentation/controllers/project_jobs.dart';
import 'package:app/features/pricing/data/pricing_repository.dart';
import 'package:app/features/pricing/presentation/controllers/pricing_settings.dart';
import 'package:app/features/projects/data/projects_repository.dart';
import 'package:app/features/projects/presentation/controllers/project.dart';
import 'package:app/features/projects/presentation/project_page.dart';

import '../../../helpers/fixtures.dart';
import '../../../mocks.dart';

void main() {
  late MockProjectsRepository projects;
  late MockJobsRepository jobs;
  late MockPricingRepository pricing;

  setUpAll(tzdata.initializeTimeZones);

  setUp(() {
    projects = MockProjectsRepository();
    jobs = MockJobsRepository();
    pricing = MockPricingRepository();
    when(jobs.fetchForProject(any)).thenAnswer((_) async => [backDeckWithLines]);
    when(pricing.fetchSettings()).thenAnswer((_) async => qualityDeckSettings);
  });

  Future<void> pumpPage(WidgetTester tester, String id) async {
    tester.view.physicalSize = const Size(800, 1200);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          projectsRepositoryProvider.overrideWithValue(projects),
          jobsRepositoryProvider.overrideWithValue(jobs),
          pricingRepositoryProvider.overrideWithValue(pricing),
          currentBusinessProvider.overrideWith((ref) async => qualityDeck),
          clockProvider.overrideWithValue(
            Clock.fixed(DateTime.utc(2026, 10, 20, 18)),
          ),
          projectProvider(id).overrideWith(
            (ref) => ref.watch(projectsRepositoryProvider).fetchOne(id),
          ),
          projectJobsProvider(id).overrideWith(
            (ref) => ref.watch(jobsRepositoryProvider).fetchForProject(id),
          ),
          pricingSettingsProvider.overrideWith(
            (ref) => ref.watch(pricingRepositoryProvider).fetchSettings(),
          ),
        ],
        child: MaterialApp(home: ProjectPage(projectId: id)),
      ),
    );
    await tester.pumpAndSettle();
  }

  testWidgets('archived project hides add buttons, menus and drag handles', (
    tester,
  ) async {
    when(
      projects.fetchOne(archivedMelgar.id),
    ).thenAnswer((_) async => archivedMelgar);
    when(
      jobs.fetchForProject(archivedMelgar.id),
    ).thenAnswer((_) async => [backDeckWithLines]);

    await pumpPage(tester, archivedMelgar.id);

    expect(find.text('This project is archived.'), findsOneWidget);
    expect(find.text('+ Add job'), findsNothing);
    expect(find.text('+ Add from price list'), findsNothing);
    expect(find.text('+ Add custom line'), findsNothing);
    expect(find.text('+ Add labor'), findsNothing);
    expect(find.byIcon(Icons.drag_handle), findsNothing);
    expect(find.byType(PopupMenuButton<String>), findsOneWidget);
  });

  testWidgets('Generate proposal is disabled with a Coming soon tooltip', (
    tester,
  ) async {
    when(projects.fetchOne(melgarOak.id)).thenAnswer((_) async => melgarOak);

    await pumpPage(tester, melgarOak.id);

    expect(find.text('Generate proposal'), findsOneWidget);
    final button = tester.widget<FilledButton>(
      find.widgetWithText(FilledButton, 'Generate proposal'),
    );
    expect(button.onPressed, isNull);
    expect(find.byTooltip('Coming soon'), findsOneWidget);
  });

  testWidgets('unknown id shows not-found', (tester) async {
    when(projects.fetchOne('missing')).thenAnswer((_) async => null);

    await pumpPage(tester, 'missing');

    expect(find.text("This project couldn't be found."), findsOneWidget);
    expect(find.text('Back to projects'), findsOneWidget);
    expect(find.text('This project is archived.'), findsNothing);
  });

  testWidgets('Add labor is hidden once the job has labor', (tester) async {
    when(projects.fetchOne(melgarOak.id)).thenAnswer((_) async => melgarOak);

    await pumpPage(tester, melgarOak.id);

    expect(find.text('+ Add labor'), findsNothing);
    expect(find.text('Labor'), findsOneWidget);
  });
}
