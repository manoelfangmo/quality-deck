import 'package:freezed_annotation/freezed_annotation.dart';

part 'onboarding_form_state.freezed.dart';

@freezed
abstract class OnboardingFormState with _$OnboardingFormState {
  const OnboardingFormState._();

  const factory OnboardingFormState({
    @Default('') String inviteCode,
    @Default('') String businessName,
    @Default(false) bool isSubmitting,
    String? errorMessage,
  }) = _OnboardingFormState;

  bool get hasCode => inviteCode.trim().isNotEmpty;
}
