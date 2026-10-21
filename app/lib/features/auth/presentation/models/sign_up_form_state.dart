import 'package:freezed_annotation/freezed_annotation.dart';

import 'package:app/features/auth/domain/auth_failure.dart';

part 'sign_up_form_state.freezed.dart';

@freezed
abstract class SignUpFormState with _$SignUpFormState {
  const factory SignUpFormState({
    @Default('') String fullName,
    @Default('') String email,
    @Default('') String password,
    @Default(true) bool obscurePassword,
    @Default(false) bool isSubmitting,
    AuthFailure? failure,
  }) = _SignUpFormState;
}
