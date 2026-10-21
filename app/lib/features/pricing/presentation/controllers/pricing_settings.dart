import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'package:app/core/domain/app_exception.dart';
import 'package:app/core/domain/money.dart';
import 'package:app/core/domain/percent.dart';
import 'package:app/features/pricing/data/pricing_repository.dart';
import 'package:app/features/pricing/domain/pricing_settings.dart';
import 'package:app/features/pricing/presentation/validators/pricing_validators.dart';

part 'pricing_settings.g.dart';

@riverpod
Future<PricingSettings?> pricingSettings(Ref ref) {
  return ref.watch(pricingRepositoryProvider).fetchSettings();
}

class PricingSettingsActionState {
  const PricingSettingsActionState({
    this.isSavingLabor = false,
    this.isSavingOverhead = false,
    this.laborRateError,
    this.overheadError,
    this.errorMessage,
  });

  final bool isSavingLabor;
  final bool isSavingOverhead;
  final String? laborRateError;
  final String? overheadError;
  final String? errorMessage;

  PricingSettingsActionState copyWith({
    bool? isSavingLabor,
    bool? isSavingOverhead,
    String? laborRateError,
    String? overheadError,
    String? errorMessage,
    bool clearLaborRateError = false,
    bool clearOverheadError = false,
    bool clearErrorMessage = false,
  }) {
    return PricingSettingsActionState(
      isSavingLabor: isSavingLabor ?? this.isSavingLabor,
      isSavingOverhead: isSavingOverhead ?? this.isSavingOverhead,
      laborRateError: clearLaborRateError
          ? null
          : (laborRateError ?? this.laborRateError),
      overheadError: clearOverheadError
          ? null
          : (overheadError ?? this.overheadError),
      errorMessage: clearErrorMessage
          ? null
          : (errorMessage ?? this.errorMessage),
    );
  }
}

@riverpod
class PricingSettingsController extends _$PricingSettingsController {
  @override
  PricingSettingsActionState build() => const PricingSettingsActionState();

  Future<bool> saveLaborRate(String raw) async {
    final error = PricingValidators.laborRate(raw);
    if (error != null) {
      state = state.copyWith(laborRateError: error);
      return false;
    }
    final cents = Money.tryParse(raw)!.cents;
    state = state.copyWith(
      isSavingLabor: true,
      clearLaborRateError: true,
      clearErrorMessage: true,
    );
    try {
      await ref.read(pricingRepositoryProvider).updateLaborRate(cents);
      if (!ref.mounted) return true;
      ref.invalidate(pricingSettingsProvider);
      state = state.copyWith(isSavingLabor: false);
      return true;
    } on AppException catch (error) {
      if (!ref.mounted) return false;
      state = state.copyWith(isSavingLabor: false, errorMessage: error.message);
      return false;
    } catch (_) {
      if (!ref.mounted) return false;
      state = state.copyWith(
        isSavingLabor: false,
        errorMessage: 'Something went wrong.',
      );
      return false;
    }
  }

  Future<bool> saveOverhead(String raw) async {
    final error = PricingValidators.overhead(raw);
    if (error != null) {
      state = state.copyWith(overheadError: error);
      return false;
    }
    final bps = Percent.tryParse(raw)!.basisPoints;
    state = state.copyWith(
      isSavingOverhead: true,
      clearOverheadError: true,
      clearErrorMessage: true,
    );
    try {
      await ref.read(pricingRepositoryProvider).updateOverhead(bps);
      if (!ref.mounted) return true;
      ref.invalidate(pricingSettingsProvider);
      state = state.copyWith(isSavingOverhead: false);
      return true;
    } on AppException catch (error) {
      if (!ref.mounted) return false;
      state = state.copyWith(
        isSavingOverhead: false,
        errorMessage: error.message,
      );
      return false;
    } catch (_) {
      if (!ref.mounted) return false;
      state = state.copyWith(
        isSavingOverhead: false,
        errorMessage: 'Something went wrong.',
      );
      return false;
    }
  }
}
