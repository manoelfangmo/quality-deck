import 'package:clock/clock.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:timezone/data/latest.dart' as tzdata;

import 'package:app/core/utils/providers.dart';
import 'package:app/features/business/presentation/controllers/current_business.dart';
import 'package:app/features/projects/data/projects_repository.dart';
import 'package:app/features/projects/presentation/controllers/project.dart';
import 'package:app/features/projects/presentation/project_page.dart';

import '../../../helpers/fixtures.dart';
import '../../../mocks.dart';

void main() {
  late MockProjectsRepository projects;

  setUpAll(tzdata.initializeTimeZones);

  setUp(() {
    projects = MockProjectsRepository();
  });

  Future<void> pumpPage(WidgetTester tester, String id) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          projectsRepositoryProvider.overrideWithValue(projects),
          currentBusinessProvider.overrideWith((ref) async => qualityDeck),
          clockProvider.overrideWithValue(
            Clock.fixed(DateTime.utc(2026, 10, 20, 18)),
          ),
          projectProvider(id).overrideWith(
            (ref) => ref.watch(projectsRepositoryProvider).fetchOne(id),
          ),
        ],
        child: MaterialApp(home: ProjectPage(projectId: id)),
      ),
    );
    await tester.pumpAndSettle();
  }

  testWidgets('archived project shows the archived banner', (tester) async {
    when(
      projects.fetchOne(archivedMelgar.id),
    ).thenAnswer((_) async => archivedMelgar);

    await pumpPage(tester, archivedMelgar.id);

    expect(find.text('This project is archived.'), findsOneWidget);
    expect(find.widgetWithText(TextButton, 'Unarchive'), findsOneWidget);
    expect(find.text('Project details are coming in a later update.'), findsOneWidget);
  });

  testWidgets('unknown id shows not-found', (tester) async {
    when(projects.fetchOne('missing')).thenAnswer((_) async => null);

    await pumpPage(tester, 'missing');

    expect(find.text("This project couldn't be found."), findsOneWidget);
    expect(find.text('Back to projects'), findsOneWidget);
    expect(find.text('This project is archived.'), findsNothing);
  });
}
