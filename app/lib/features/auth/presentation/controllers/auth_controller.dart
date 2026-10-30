import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'package:app/features/auth/data/auth_repository.dart';
import 'package:app/features/auth/presentation/controllers/current_user.dart';

part 'auth_controller.g.dart';

@riverpod
class AuthController extends _$AuthController {
  @override
  FutureOr<void> build() {}

  Future<void> signIn({required String email, required String password}) async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      await ref
          .read(authRepositoryProvider)
          .signIn(email: email.trim(), password: password);
      ref.invalidate(currentUserProvider);
    });
    final error = state.error;
    if (error != null) {
      Error.throwWithStackTrace(error, state.stackTrace ?? StackTrace.current);
    }
  }

  /// Returns true when a session was created, false when confirmation is pending.
  Future<bool> signUp({
    required String fullName,
    required String email,
    required String password,
  }) async {
    state = const AsyncLoading();
    var createdSession = false;
    state = await AsyncValue.guard(() async {
      createdSession = await ref
          .read(authRepositoryProvider)
          .signUp(
            fullName: fullName.trim(),
            email: email.trim(),
            password: password,
          );
      ref.invalidate(currentUserProvider);
    });
    final error = state.error;
    if (error != null) {
      Error.throwWithStackTrace(error, state.stackTrace ?? StackTrace.current);
    }
    return createdSession;
  }

  Future<void> signOut() async {
    await ref.read(authRepositoryProvider).signOut();
    ref.invalidate(currentUserProvider);
  }
}
