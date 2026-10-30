import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:app/core/domain/money.dart';
import 'package:app/core/domain/percent.dart';
import 'package:app/features/estimates/data/jobs_repository.dart';
import 'package:app/features/estimates/presentation/controllers/project_jobs.dart';
import 'package:app/features/estimates/presentation/widgets/labor_sheet.dart';
import 'package:app/features/projects/data/projects_repository.dart';
import 'package:app/features/projects/presentation/controllers/project.dart';
import 'package:app/features/projects/presentation/widgets/overhead_sheet.dart';

import '../../../../helpers/fixtures.dart';
import '../../../../mocks.dart';

void main() {
  testWidgets('Add labor prefills the business rate and shows a hint when unset', (
    tester,
  ) async {
    tester.view.physicalSize = const Size(400, 900);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          jobsRepositoryProvider.overrideWithValue(MockJobsRepository()),
          projectJobsProvider(frontStepsJob.projectId).overrideWith(
            (ref) async => [frontStepsWithLines],
          ),
        ],
        child: MaterialApp(
          home: LaborSheet(
            projectId: frontStepsJob.projectId,
            job: frontStepsJob,
            prefilledRate: const Money(6500),
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('65'), findsOneWidget);
    expect(
      find.text('Set a labor rate on the Pricing page to fill this in.'),
      findsNothing,
    );

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          jobsRepositoryProvider.overrideWithValue(MockJobsRepository()),
          projectJobsProvider(frontStepsJob.projectId).overrideWith(
            (ref) async => [frontStepsWithLines],
          ),
        ],
        child: MaterialApp(
          home: LaborSheet(
            projectId: frontStepsJob.projectId,
            job: frontStepsJob,
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();

    expect(
      find.text('Set a labor rate on the Pricing page to fill this in.'),
      findsOneWidget,
    );
  });

  testWidgets('Add overhead prefills the business percentage', (tester) async {
    tester.view.physicalSize = const Size(400, 900);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          projectsRepositoryProvider.overrideWithValue(MockProjectsRepository()),
          projectProvider(melgarOak.id).overrideWith((ref) async => melgarOak),
        ],
        child: MaterialApp(
          home: OverheadSheet(
            projectId: melgarOak.id,
            prefilled: const Percent(1250),
            subtotal: const Money(433875),
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('12.5'), findsOneWidget);
  });
}
