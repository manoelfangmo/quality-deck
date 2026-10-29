import 'package:app/core/domain/money.dart';
import 'package:app/core/domain/percent.dart';
import 'package:app/core/domain/pricing_type.dart';
import 'package:app/core/domain/quantity.dart';
import 'package:app/features/estimates/domain/job_type.dart';
import 'package:app/features/pricing/presentation/validators/pricing_validators.dart';

abstract final class EstimateValidators {
  static const maxJobTitleLength = 120;
  static const maxJobDescriptionLength = 2000;
  static const maxLineNameLength = 120;
  static const maxLineDescriptionLength = 1000;
  static const maxQuantity = 1000000;
  static const maxLaborHours = 10000;
  static const maxLaborRateCents = 100000;
  static const maxPriceCents = 100000000;

  static String? jobTitle(String? value) {
    final trimmed = value?.trim() ?? '';
    if (trimmed.isEmpty || trimmed.length > maxJobTitleLength) {
      return 'Enter a title for this job.';
    }
    return null;
  }

  static String? jobType(JobType? value) {
    if (value == null) return 'Choose a job type.';
    return null;
  }

  static String? jobDescription(String? value) {
    if (value == null || value.isEmpty) return null;
    if (value.length > maxJobDescriptionLength) {
      return 'Keep the description under 2,000 characters.';
    }
    return null;
  }

  static String? alternateOfJobId({
    required bool isAlternate,
    String? alternateOfJobId,
  }) {
    if (!isAlternate) return null;
    if (alternateOfJobId == null || alternateOfJobId.isEmpty) {
      return 'Pick the job this option replaces.';
    }
    return null;
  }

  static String? lineName(String? value) {
    final trimmed = value?.trim() ?? '';
    if (trimmed.isEmpty || trimmed.length > maxLineNameLength) {
      return 'Enter a name for this line.';
    }
    return null;
  }

  static String? lineDescription(String? value) {
    if (value == null || value.isEmpty) return null;
    if (value.length > maxLineDescriptionLength) {
      return 'Keep the description under 1,000 characters.';
    }
    return null;
  }

  static String? quantity(String? value, {required PricingType? type}) {
    if (type == PricingType.fixed) return null;
    final quantity = Quantity.tryParse(value);
    if (quantity == null || quantity.hundredths > maxQuantity * 100) {
      return 'Enter a quantity greater than 0.';
    }
    return null;
  }

  static String? price(String? value) => PricingValidators.price(value);

  static String? laborHours(String? value) {
    final hours = Quantity.tryParse(value);
    if (hours == null || hours.hundredths > maxLaborHours * 100) {
      return 'Enter the hours, more than 0.';
    }
    return null;
  }

  static String? laborRate(String? value) {
    final money = Money.tryParse(value);
    if (money == null || money.cents > maxLaborRateCents) {
      return r'Enter an hourly rate from $0 to $1,000.';
    }
    return null;
  }

  static String? overhead(String? value) {
    final percent = Percent.tryParse(value);
    if (percent == null || percent.basisPoints > 10000) {
      return 'Enter a percentage from 0 to 100.';
    }
    return null;
  }
}
