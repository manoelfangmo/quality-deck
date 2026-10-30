import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'package:app/core/domain/app_exception.dart';
import 'package:app/core/domain/money.dart';
import 'package:app/core/domain/pricing_type.dart';
import 'package:app/core/domain/quantity.dart';
import 'package:app/features/estimates/data/line_items_repository.dart';
import 'package:app/features/estimates/data/models.dart';
import 'package:app/features/estimates/domain/line_item.dart';
import 'package:app/features/estimates/domain/line_math.dart';
import 'package:app/features/estimates/presentation/controllers/project_jobs.dart';
import 'package:app/features/estimates/presentation/models/line_form_state.dart';
import 'package:app/features/estimates/presentation/validators/estimate_validators.dart';

part 'line_form.g.dart';

@riverpod
class LineFormController extends _$LineFormController {
  late LineFormState _initial;

  @override
  LineFormState build({
    required String projectId,
    required String jobId,
    LineItem? item,
  }) {
    _initial = item == null
        ? LineFormState.addCustom()
        : LineFormState.fromItem(item);
    return _initial;
  }

  bool get isDirty =>
      state.name != _initial.name ||
      state.description != _initial.description ||
      state.pricingType != _initial.pricingType ||
      state.quantity != _initial.quantity ||
      state.price != _initial.price;

  Money? get previewTotal {
    final type = state.pricingType;
    final price = Money.tryParse(state.price);
    if (type == null || price == null) return null;
    final quantity = type == PricingType.fixed
        ? const Quantity(100)
        : Quantity.tryParse(state.quantity);
    if (quantity == null) return null;
    return Money(lineTotal(quantity, price.cents));
  }

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

  void setQuantity(String value) {
    state = state.copyWith(quantity: value);
    _revalidate();
  }

  void setPrice(String value) {
    final original = Money.tryParse(state.originalPrice);
    final parsed = Money.tryParse(value);
    final hasOverride =
        state.isPriceList &&
        original != null &&
        parsed != null &&
        parsed.cents != original.cents;
    state = state.copyWith(price: value, hasOverride: hasOverride);
    _revalidate();
  }

  void resetOverride() {
    state = state.copyWith(price: state.originalPrice, hasOverride: false);
    _revalidate();
  }

  Future<bool> submit() async {
    final errors = _fieldErrors();
    if (errors.hasAny) {
      state = state.copyWith(
        submitted: true,
        isSubmitting: false,
        nameError: errors.name,
        descriptionError: errors.description,
        pricingTypeError: errors.pricingType,
        quantityError: errors.quantity,
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
      final repo = ref.read(lineItemsRepositoryProvider);
      if (state.isAdd) {
        await repo.addCustom(_toAddCommand());
      } else {
        await repo.update(_toUpdateCommand());
      }
      ref.invalidate(projectJobsProvider(projectId));
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

  AddCustomLineCommand _toAddCommand() {
    final type = state.pricingType!;
    return AddCustomLineCommand(
      jobId: jobId,
      name: state.name,
      description: state.description,
      pricingType: type,
      quantity: _quantity(type),
      priceCents: Money.tryParse(state.price)!.cents,
    );
  }

  UpdateLineCommand _toUpdateCommand() {
    final type = state.pricingType!;
    if (state.isCustom) {
      return UpdateLineCommand(
        id: state.lineId!,
        quantity: _quantity(type),
        description: state.description,
        name: state.name,
        pricingType: type,
        priceCents: Money.tryParse(state.price)!.cents,
      );
    }

    final saved = Money.tryParse(state.originalPrice)!.cents;
    final current = Money.tryParse(state.price)!.cents;
    return UpdateLineCommand(
      id: state.lineId!,
      quantity: _quantity(type),
      description: state.description,
      overridePriceCents: current == saved ? null : current,
    );
  }

  Quantity _quantity(PricingType type) {
    if (type == PricingType.fixed) return const Quantity(100);
    return Quantity.tryParse(state.quantity)!;
  }

  void _revalidate() {
    if (!state.submitted) return;
    final errors = _fieldErrors();
    state = state.copyWith(
      nameError: errors.name,
      descriptionError: errors.description,
      pricingTypeError: errors.pricingType,
      quantityError: errors.quantity,
      priceError: errors.price,
    );
  }

  _FieldErrors _fieldErrors() {
    return _FieldErrors(
      name: state.isCustom ? EstimateValidators.lineName(state.name) : null,
      description: EstimateValidators.lineDescription(state.description),
      pricingType: state.isCustom
          ? (state.pricingType == null ? 'Choose how this line is priced.' : null)
          : null,
      quantity: EstimateValidators.quantity(
        state.quantity,
        type: state.pricingType,
      ),
      price: EstimateValidators.price(state.price),
    );
  }
}

class _FieldErrors {
  const _FieldErrors({
    this.name,
    this.description,
    this.pricingType,
    this.quantity,
    this.price,
  });

  final String? name;
  final String? description;
  final String? pricingType;
  final String? quantity;
  final String? price;

  bool get hasAny =>
      name != null ||
      description != null ||
      pricingType != null ||
      quantity != null ||
      price != null;
}
