import 'package:freezed_annotation/freezed_annotation.dart';

part 'auth_failure.freezed.dart';

@freezed
sealed class AuthFailure with _$AuthFailure implements Exception {
  const AuthFailure._();

  const factory AuthFailure.invalidCredentials() = InvalidCredentials;
  const factory AuthFailure.emailInUse() = EmailInUse;
  const factory AuthFailure.weakPassword() = WeakPassword;
  const factory AuthFailure.network() = NetworkFailure;
  const factory AuthFailure.unknown() = UnknownAuthFailure;

  String get message => switch (this) {
    InvalidCredentials() => 'That email or password is incorrect.',
    EmailInUse() => 'An account with that email already exists.',
    WeakPassword() => 'Password must be at least 8 characters.',
    NetworkFailure() => 'Check your connection and try again.',
    UnknownAuthFailure() => 'Something went wrong. Try again.',
  };

  @override
  String toString() => message;
}
