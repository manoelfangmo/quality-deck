import 'package:freezed_annotation/freezed_annotation.dart';

import 'package:app/features/auth/domain/auth_failure.dart';

part 'sign_in_form_state.freezed.dart';

@freezed
abstract class SignInFormState with _$SignInFormState {
  const factory SignInFormState({
    @Default('') String email,
    @Default('') String password,
    @Default(true) bool obscurePassword,
    @Default(false) bool isSubmitting,
    AuthFailure? failure,
  }) = _SignInFormState;
}
