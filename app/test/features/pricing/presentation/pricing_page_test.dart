import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import 'package:app/features/pricing/data/price_items_repository.dart';
import 'package:app/features/pricing/data/pricing_repository.dart';
import 'package:app/features/pricing/presentation/controllers/price_items_table.dart';
import 'package:app/features/pricing/presentation/controllers/pricing_settings.dart';
import 'package:app/features/pricing/presentation/pricing_page.dart';

import '../../../helpers/fixtures.dart';
import '../../../mocks.dart';

void main() {
  late MockPricingRepository pricing;
  late MockPriceItemsRepository items;

  setUp(() {
    pricing = MockPricingRepository();
    items = MockPriceItemsRepository();
    when(pricing.fetchSettings()).thenAnswer((_) async => qualityDeckSettings);
    when(
      items.fetchAll(),
    ).thenAnswer((_) async => [aluminumRailing, compositeDecking]);
  });

  Future<void> pumpPage(WidgetTester tester) async {
    tester.view.physicalSize = const Size(1800, 900);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          pricingRepositoryProvider.overrideWithValue(pricing),
          priceItemsRepositoryProvider.overrideWithValue(items),
          pricingSettingsProvider.overrideWith(
            (ref) => ref.watch(pricingRepositoryProvider).fetchSettings(),
          ),
          allPriceItemsProvider.overrideWith(
            (ref) => ref.watch(priceItemsRepositoryProvider).fetchAll(),
          ),
        ],
        child: const MaterialApp(home: Scaffold(body: PricingPage())),
      ),
    );
    await tester.pumpAndSettle();
  }

  testWidgets('Add item opens an empty form', (tester) async {
    await pumpPage(tester);

    await tester.tap(find.widgetWithText(FilledButton, 'Add item'));
    await tester.pumpAndSettle();

    expect(find.text('Add item'), findsWidgets);
    final nameField = tester.widget<TextField>(find.byType(TextField).first);
    expect(nameField.controller?.text, isEmpty);
  });

  testWidgets('row Edit opens the form filled in', (tester) async {
    await pumpPage(tester);

    await tester.tap(find.byIcon(Icons.more_horiz).first);
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(const ValueKey('Edit')));
    await tester.pumpAndSettle();

    expect(find.text('Edit item'), findsOneWidget);
    final nameField = tester.widget<TextField>(find.byType(TextField).first);
    expect(nameField.controller?.text, aluminumRailing.name);
  });

  testWidgets('Delete shows confirmation and only calls the repository after Delete', (
    tester,
  ) async {
    when(items.delete(any)).thenAnswer((_) async {});
    await pumpPage(tester);

    await tester.tap(find.byIcon(Icons.more_horiz).first);
    await tester.pumpAndSettle();
    await tester.tap(find.text('Delete'));
    await tester.pumpAndSettle();

    expect(find.text('Delete Aluminum railing?'), findsOneWidget);
    verifyNever(items.delete(any));

    await tester.tap(find.widgetWithText(TextButton, 'Delete'));
    await tester.pumpAndSettle();

    verify(items.delete(aluminumRailing.id)).called(1);
  });
}
