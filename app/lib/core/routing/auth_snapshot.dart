import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:app/core/domain/app_user.dart';

class AuthSnapshot {
  const AuthSnapshot._({required this.isLoading, this.user});

  const AuthSnapshot.loading() : this._(isLoading: true);

  const AuthSnapshot.signedOut() : this._(isLoading: false);

  const AuthSnapshot.signedIn(AppUser user)
    : this._(isLoading: false, user: user);

  final bool isLoading;
  final AppUser? user;

  factory AuthSnapshot.fromAsync(AsyncValue<AppUser?> value) {
    if (value.isLoading && !value.hasValue) {
      return const AuthSnapshot.loading();
    }
    final user = value.value;
    if (user == null) return const AuthSnapshot.signedOut();
    return AuthSnapshot.signedIn(user);
  }
}
