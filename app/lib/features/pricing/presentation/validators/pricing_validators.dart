import 'package:app/core/domain/money.dart';
import 'package:app/core/domain/percent.dart';
import 'package:app/core/domain/pricing_type.dart';

abstract final class PricingValidators {
  static const maxLaborRateCents = 100000;
  static const maxOverheadBps = 10000;
  static const maxPriceCents = 100000000;
  static const maxNameLength = 120;
  static const maxDescriptionLength = 1000;

  static String? laborRate(String? value) {
    final money = Money.tryParse(value);
    if (money == null || money.cents > maxLaborRateCents) {
      return r'Enter an hourly rate from $0 to $1,000.';
    }
    return null;
  }

  static String? overhead(String? value) {
    final percent = Percent.tryParse(value);
    if (percent == null || percent.basisPoints > maxOverheadBps) {
      return 'Enter a percentage from 0 to 100.';
    }
    return null;
  }

  static String? name(String? value) {
    final trimmed = value?.trim() ?? '';
    if (trimmed.isEmpty || trimmed.length > maxNameLength) {
      return 'Enter a name for this item.';
    }
    return null;
  }

  static String? description(String? value) {
    if (value == null || value.isEmpty) return null;
    if (value.length > maxDescriptionLength) {
      return 'Keep the description under 1,000 characters.';
    }
    return null;
  }

  static String? pricingType(PricingType? value) {
    if (value == null) return 'Choose how this item is priced.';
    return null;
  }

  static String? price(String? value) {
    final money = Money.tryParse(value);
    if (money == null || money.cents > maxPriceCents) {
      return r'Enter a price of $0 or more.';
    }
    return null;
  }
}
