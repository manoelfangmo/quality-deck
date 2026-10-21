import 'package:freezed_annotation/freezed_annotation.dart';

import 'package:app/core/domain/pricing_type.dart';
import 'package:app/features/pricing/domain/price_item.dart';

part 'price_item_form_state.freezed.dart';

enum PriceItemFormMode { add, edit }

@freezed
abstract class PriceItemFormState with _$PriceItemFormState {
  const PriceItemFormState._();

  const factory PriceItemFormState({
    @Default(PriceItemFormMode.add) PriceItemFormMode mode,
    String? itemId,
    @Default('') String name,
    @Default('') String description,
    PricingType? pricingType,
    @Default('') String price,
    @Default(false) bool isSubmitting,
    @Default(false) bool submitted,
    String? errorMessage,
    String? nameError,
    String? descriptionError,
    String? pricingTypeError,
    String? priceError,
  }) = _PriceItemFormState;

  factory PriceItemFormState.fromItem(PriceItem item) {
    return PriceItemFormState(
      mode: PriceItemFormMode.edit,
      itemId: item.id,
      name: item.name,
      description: item.description ?? '',
      pricingType: item.pricingType,
      price: _priceInput(item.price.cents),
    );
  }

  bool get isAdd => mode == PriceItemFormMode.add;

  static String _priceInput(int cents) {
    final dollars = cents ~/ 100;
    final remainder = cents % 100;
    if (remainder == 0) return dollars.toString();
    if (remainder % 10 == 0) return '$dollars.${remainder ~/ 10}';
    return '$dollars.${remainder.toString().padLeft(2, '0')}';
  }
}
