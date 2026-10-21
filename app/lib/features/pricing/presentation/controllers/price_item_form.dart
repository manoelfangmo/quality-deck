import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'package:app/core/domain/app_exception.dart';
import 'package:app/core/domain/money.dart';
import 'package:app/core/domain/pricing_type.dart';
import 'package:app/features/pricing/data/models.dart';
import 'package:app/features/pricing/data/price_items_repository.dart';
import 'package:app/features/pricing/domain/price_item.dart';
import 'package:app/features/pricing/presentation/controllers/price_items_table.dart';
import 'package:app/features/pricing/presentation/models/price_item_form_state.dart';
import 'package:app/features/pricing/presentation/validators/pricing_validators.dart';

part 'price_item_form.g.dart';

@riverpod
class PriceItemFormController extends _$PriceItemFormController {
  late PriceItemFormState _initial;

  @override
  PriceItemFormState build({PriceItem? item}) {
    _initial = item == null
        ? const PriceItemFormState()
        : PriceItemFormState.fromItem(item);
    return _initial;
  }

  bool get isDirty =>
      state.name != _initial.name ||
      state.description != _initial.description ||
      state.pricingType != _initial.pricingType ||
      state.price != _initial.price;

  void setName(String value) {
    state = state.copyWith(name: value);
    _revalidate();
  }

  void setDescription(String value) {
    state = state.copyWith(description: value);
    _revalidate();
  }

  void setPricingType(PricingType? value) {
    state = state.copyWith(pricingType: value);
    _revalidate();
  }

  void setPrice(String value) {
    state = state.copyWith(price: value);
    _revalidate();
  }

  /// Returns true when the save succeeded and the sheet should close.
  Future<bool> submit() async {
    final errors = _fieldErrors();
    if (errors.hasAny) {
      state = state.copyWith(
        submitted: true,
        isSubmitting: false,
        nameError: errors.name,
        descriptionError: errors.description,
        pricingTypeError: errors.pricingType,
        priceError: errors.price,
      );
      return false;
    }

    state = state.copyWith(
      submitted: true,
      isSubmitting: true,
      errorMessage: null,
    );
    try {
      final wasAdd = state.isAdd;
      if (wasAdd) {
        await ref.read(priceItemsRepositoryProvider).create(_toCreateCommand());
        ref.read(priceItemsTableControllerProvider.notifier).resetToFirstPage();
      } else {
        await ref.read(priceItemsRepositoryProvider).update(_toUpdateCommand());
      }
      ref.invalidate(allPriceItemsProvider);
      return true;
    } on AppException catch (error) {
      state = state.copyWith(isSubmitting: false, errorMessage: error.message);
      return false;
    } catch (_) {
      state = state.copyWith(
        isSubmitting: false,
        errorMessage: 'Something went wrong.',
      );
      return false;
    }
  }

  void _revalidate() {
    if (!state.submitted) return;
    final errors = _fieldErrors();
    state = state.copyWith(
      nameError: errors.name,
      descriptionError: errors.description,
      pricingTypeError: errors.pricingType,
      priceError: errors.price,
    );
  }

  _FieldErrors _fieldErrors() {
    return _FieldErrors(
      name: PricingValidators.name(state.name),
      description: PricingValidators.description(state.description),
      pricingType: PricingValidators.pricingType(state.pricingType),
      price: PricingValidators.price(state.price),
    );
  }

  CreatePriceItemCommand _toCreateCommand() {
    return CreatePriceItemCommand(
      name: state.name,
      description: state.description,
      pricingType: state.pricingType!,
      priceCents: Money.tryParse(state.price)!.cents,
    );
  }

  UpdatePriceItemCommand _toUpdateCommand() {
    return UpdatePriceItemCommand(
      id: state.itemId!,
      name: state.name,
      description: state.description,
      pricingType: state.pricingType!,
      priceCents: Money.tryParse(state.price)!.cents,
    );
  }
}

class _FieldErrors {
  const _FieldErrors({
    this.name,
    this.description,
    this.pricingType,
    this.price,
  });

  final String? name;
  final String? description;
  final String? pricingType;
  final String? price;

  bool get hasAny =>
      name != null ||
      description != null ||
      pricingType != null ||
      price != null;
}
