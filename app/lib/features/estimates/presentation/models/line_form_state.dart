import 'package:freezed_annotation/freezed_annotation.dart';

import 'package:app/core/domain/pricing_type.dart';
import 'package:app/features/estimates/domain/line_item.dart';

part 'line_form_state.freezed.dart';

@freezed
abstract class LineFormState with _$LineFormState {
  const LineFormState._();

  const factory LineFormState({
    String? lineId,
    @Default(true) bool isCustom,
    String? priceItemId,
    @Default('') String name,
    @Default('') String description,
    PricingType? pricingType,
    @Default('') String quantity,
    @Default('') String price,
    @Default('') String originalPrice,
    @Default(false) bool hasOverride,
    @Default(false) bool isSubmitting,
    @Default(false) bool submitted,
    String? errorMessage,
    String? nameError,
    String? descriptionError,
    String? pricingTypeError,
    String? quantityError,
    String? priceError,
  }) = _LineFormState;

  factory LineFormState.fromItem(LineItem item) {
    final effective = item.effectivePrice;
    return LineFormState(
      lineId: item.id,
      isCustom: item.isCustom,
      priceItemId: item.priceItemId,
      name: item.name,
      description: item.description ?? '',
      pricingType: item.pricingType,
      quantity: item.pricingType == PricingType.fixed
          ? '1'
          : item.quantity.format(),
      price: _moneyInput(effective.cents),
      originalPrice: _moneyInput(item.savedPrice.cents),
      hasOverride: item.hasOverride,
    );
  }

  factory LineFormState.addCustom() => const LineFormState();

  bool get isAdd => lineId == null;

  bool get isPriceList => !isCustom;

  bool get priceItemDeleted => isPriceList && priceItemId == null;
}

String _moneyInput(int cents) {
  final dollars = cents ~/ 100;
  final remainder = cents % 100;
  if (remainder == 0) return dollars.toString();
  if (remainder % 10 == 0) return '$dollars.${remainder ~/ 10}';
  return '$dollars.${remainder.toString().padLeft(2, '0')}';
}
