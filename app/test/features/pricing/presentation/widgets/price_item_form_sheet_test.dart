import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:app/core/domain/pricing_type.dart';
import 'package:app/features/pricing/data/price_items_repository.dart';
import 'package:app/features/pricing/presentation/widgets/price_item_form_sheet.dart';

import '../../../../mocks.dart';

void main() {
  testWidgets('price field label follows the pricing type', (tester) async {
    tester.view.physicalSize = const Size(400, 900);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          priceItemsRepositoryProvider.overrideWithValue(
            MockPriceItemsRepository(),
          ),
        ],
        child: const MaterialApp(home: PriceItemFormSheet()),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('Price'), findsOneWidget);

    await tester.tap(find.byType(DropdownButtonFormField<PricingType>));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Per sq ft').last);
    await tester.pumpAndSettle();

    expect(find.text('Price per sq ft'), findsOneWidget);
  });
}
