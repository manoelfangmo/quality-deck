import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import 'package:app/features/estimates/data/line_items_repository.dart';
import 'package:app/features/estimates/presentation/controllers/project_jobs.dart';
import 'package:app/features/estimates/presentation/widgets/add_from_price_list_sheet.dart';
import 'package:app/features/pricing/data/price_items_repository.dart';

import '../../../../helpers/fixtures.dart';
import '../../../../mocks.dart';

void main() {
  late MockPriceItemsRepository items;
  late MockLineItemsRepository lines;

  setUp(() {
    items = MockPriceItemsRepository();
    lines = MockLineItemsRepository();
    when(items.search(any, limit: anyNamed('limit'))).thenAnswer(
      (_) async => [compositeDecking, permitFiling],
    );
  });

  Future<void> pumpSheet(WidgetTester tester) async {
    tester.view.physicalSize = const Size(400, 900);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          priceItemsRepositoryProvider.overrideWithValue(items),
          lineItemsRepositoryProvider.overrideWithValue(lines),
          projectJobsProvider(backDeckJob.projectId).overrideWith(
            (ref) async => [backDeckWithLines],
          ),
        ],
        child: const MaterialApp(
          home: AddFromPriceListSheet(
            projectId: 'project-melgar',
            jobId: 'job-back-deck',
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();
  }

  testWidgets('fixed item hides quantity; other types require it', (tester) async {
    await pumpSheet(tester);

    await tester.tap(find.text('Permit filing'));
    await tester.pumpAndSettle();
    expect(find.widgetWithText(TextField, 'Quantity'), findsNothing);

    await tester.tap(find.text('Composite decking'));
    await tester.pumpAndSettle();
    expect(find.widgetWithText(TextField, 'Quantity'), findsOneWidget);
  });
}
