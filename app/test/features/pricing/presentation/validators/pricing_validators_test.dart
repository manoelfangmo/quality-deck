import 'package:flutter_test/flutter_test.dart';

import 'package:app/core/domain/pricing_type.dart';
import 'package:app/features/pricing/presentation/validators/pricing_validators.dart';

void main() {
  test('labor rate is money from \$0 to \$1,000', () {
    expect(
      PricingValidators.laborRate('-5'),
      r'Enter an hourly rate from $0 to $1,000.',
    );
    expect(
      PricingValidators.laborRate('1001'),
      r'Enter an hourly rate from $0 to $1,000.',
    );
    expect(PricingValidators.laborRate('70'), isNull);
    expect(PricingValidators.laborRate(r'$1,000'), isNull);
  });

  test('overhead is 0 to 100 with at most two decimals', () {
    expect(PricingValidators.overhead('120'), 'Enter a percentage from 0 to 100.');
    expect(PricingValidators.overhead('1.234'), 'Enter a percentage from 0 to 100.');
    expect(PricingValidators.overhead('15'), isNull);
    expect(PricingValidators.overhead('12.5'), isNull);
  });

  test('name is required and at most 120 characters', () {
    expect(PricingValidators.name('  '), 'Enter a name for this item.');
    expect(PricingValidators.name('A' * 121), 'Enter a name for this item.');
    expect(PricingValidators.name('Permit filing'), isNull);
  });

  test('description is optional and at most 1,000 characters', () {
    expect(PricingValidators.description(null), isNull);
    expect(PricingValidators.description(''), isNull);
    expect(
      PricingValidators.description('x' * 1001),
      'Keep the description under 1,000 characters.',
    );
  });

  test('pricing type is required', () {
    expect(
      PricingValidators.pricingType(null),
      'Choose how this item is priced.',
    );
    expect(PricingValidators.pricingType(PricingType.fixed), isNull);
  });

  test('price is money of \$0 or more', () {
    expect(PricingValidators.price('abc'), r'Enter a price of $0 or more.');
    expect(PricingValidators.price('4.50'), isNull);
    expect(PricingValidators.price('0'), isNull);
  });
}
