import 'package:app/core/domain/money.dart';

enum PricingType {
  fixed,
  perUnit,
  perSqFt,
  perLinearFt,
  perStep;

  String toDb() => switch (this) {
    PricingType.fixed => 'fixed',
    PricingType.perUnit => 'per_unit',
    PricingType.perSqFt => 'per_sq_ft',
    PricingType.perLinearFt => 'per_linear_ft',
    PricingType.perStep => 'per_step',
  };

  static PricingType fromDb(String value) {
    return PricingType.values.firstWhere(
      (type) => type.toDb() == value,
      orElse: () => throw FormatException('Unknown pricing type: $value'),
    );
  }

  String get label => switch (this) {
    PricingType.fixed => 'Fixed price',
    PricingType.perUnit => 'Per unit',
    PricingType.perSqFt => 'Per sq ft',
    PricingType.perLinearFt => 'Per linear ft',
    PricingType.perStep => 'Per step',
  };

  String get priceFieldLabel => switch (this) {
    PricingType.fixed => 'Price',
    PricingType.perUnit => 'Price per unit',
    PricingType.perSqFt => 'Price per sq ft',
    PricingType.perLinearFt => 'Price per linear ft',
    PricingType.perStep => 'Price per step',
  };

  String get suffix => switch (this) {
    PricingType.fixed => 'fixed',
    PricingType.perUnit => '/ unit',
    PricingType.perSqFt => '/ sq ft',
    PricingType.perLinearFt => '/ linear ft',
    PricingType.perStep => '/ step',
  };

  String formatPrice(Money price) => '${price.format()} $suffix';

  String get quantityUnit => switch (this) {
    PricingType.fixed => '',
    PricingType.perUnit => 'units',
    PricingType.perSqFt => 'sq ft',
    PricingType.perLinearFt => 'linear ft',
    PricingType.perStep => 'steps',
  };
}
