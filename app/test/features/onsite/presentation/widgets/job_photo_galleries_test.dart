import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:app/features/onsite/presentation/widgets/job_photo_galleries.dart';

import '../../../../helpers/photo_overrides.dart';

void main() {
  Future<void> pumpGalleries(
    WidgetTester tester, {
    bool readOnly = false,
  }) async {
    tester.view.physicalSize = const Size(400, 1200);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(
      ProviderScope(
        overrides: jobPhotoTestOverrides(),
        child: MaterialApp(
          home: Scaffold(
            body: JobPhotoGalleries(jobId: 'job-back-deck', readOnly: readOnly),
          ),
        ),
      ),
    );
    await tester.pump();
    await tester.pump();
  }

  testWidgets('shows Before, Concept and After with empty states', (
    tester,
  ) async {
    await pumpGalleries(tester);

    expect(find.text('Before · 0/10'), findsOneWidget);
    expect(find.text('Concept · 0/10'), findsOneWidget);
    expect(find.text('After · 0/10'), findsOneWidget);
    expect(
      find.text('No before photos yet. Add photos of the site as it is today.'),
      findsOneWidget,
    );
    expect(find.text('Take photo'), findsNWidgets(3));
    expect(find.text('Choose photos'), findsNWidgets(3));
  });

  testWidgets('read-only galleries hide add buttons', (tester) async {
    await pumpGalleries(tester, readOnly: true);

    expect(find.text('Take photo'), findsNothing);
    expect(find.text('Choose photos'), findsNothing);
  });
}
