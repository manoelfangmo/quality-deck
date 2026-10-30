import 'package:flutter_test/flutter_test.dart';

import 'package:app/core/domain/money.dart';
import 'package:app/core/domain/pricing_type.dart';
import 'package:app/features/pricing/domain/price_item.dart';

void main() {
  PriceItem item(PricingType type, int cents) {
    return PriceItem(
      id: 'item-${type.name}',
      name: type.label,
      pricingType: type,
      price: Money(cents),
      updatedAt: DateTime.utc(2026, 10, 20),
    );
  }

  test('priceLabel for every pricing type', () {
    expect(item(PricingType.fixed, 35000).priceLabel, r'$350.00 fixed');
    expect(item(PricingType.perUnit, 1200).priceLabel, r'$12.00 / unit');
    expect(item(PricingType.perSqFt, 450).priceLabel, r'$4.50 / sq ft');
    expect(
      item(PricingType.perLinearFt, 3800).priceLabel,
      r'$38.00 / linear ft',
    );
    expect(item(PricingType.perStep, 9500).priceLabel, r'$95.00 / step');
  });
}
