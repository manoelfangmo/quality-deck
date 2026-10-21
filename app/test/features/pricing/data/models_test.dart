import 'package:flutter_test/flutter_test.dart';

import 'package:app/core/database/price_items_table.dart';
import 'package:app/core/domain/pricing_type.dart';
import 'package:app/features/pricing/data/models.dart';

void main() {
  test('CreatePriceItemCommand trims, empties description, stores cents', () {
    final json = const CreatePriceItemCommand(
      name: '  Composite decking  ',
      description: '  Trex Enhance  ',
      pricingType: PricingType.perSqFt,
      priceCents: 450,
    ).toJson();

    expect(json[PriceItemsTable.itemName], 'Composite decking');
    expect(json[PriceItemsTable.description], 'Trex Enhance');
    expect(json[PriceItemsTable.pricingType], 'per_sq_ft');
    expect(json[PriceItemsTable.priceCents], 450);
    expect(json.containsKey(PriceItemsTable.businessId), isFalse);
    expect(json.containsKey(PriceItemsTable.id), isFalse);
  });

  test('empty description becomes null', () {
    final json = const CreatePriceItemCommand(
      name: 'Permit filing',
      description: '   ',
      pricingType: PricingType.fixed,
      priceCents: 35000,
    ).toJson();

    expect(json[PriceItemsTable.description], isNull);
  });

  test('UpdatePriceItemCommand payload has no id or business_id', () {
    final json = const UpdatePriceItemCommand(
      id: 'item-railing',
      name: 'Aluminum railing',
      pricingType: PricingType.perLinearFt,
      priceCents: 3800,
    ).toJson();

    expect(json.containsKey(PriceItemsTable.id), isFalse);
    expect(json.containsKey(PriceItemsTable.businessId), isFalse);
  });
}
