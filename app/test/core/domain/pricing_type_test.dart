import 'package:flutter_test/flutter_test.dart';

import 'package:app/core/domain/pricing_type.dart';

void main() {
  test('every value round-trips through toDb / fromDb', () {
    for (final type in PricingType.values) {
      expect(PricingType.fromDb(type.toDb()), type);
    }
  });

  test('every value has a label, price field label, and suffix', () {
    for (final type in PricingType.values) {
      expect(type.label, isNotEmpty, reason: '$type is missing a label');
      expect(
        type.priceFieldLabel,
        isNotEmpty,
        reason: '$type is missing a price field label',
      );
      expect(type.suffix, isNotEmpty, reason: '$type is missing a suffix');
    }
  });
}
