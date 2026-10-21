import 'package:clock/clock.dart';
import 'package:flutter/foundation.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'package:app/core/database/memberships_table.dart';
import 'package:app/core/database/users_table.dart';
import 'package:app/core/domain/app_user.dart';
import 'package:app/core/routing/app_routes.dart';
import 'package:app/core/utils/local_store.dart';
import 'package:app/core/utils/providers.dart';
import 'package:app/features/auth/domain/auth_failure.dart';

part 'auth_repository.g.dart';

@riverpod
AuthRepository authRepository(Ref ref) {
  return AuthRepository(
    ref.watch(supabaseProvider),
    localSettings: ref.watch(localSettingsProvider),
    clock: ref.watch(clockProvider),
  );
}

class AuthRepository {
  AuthRepository(
    this._supabase, {
    required this.localSettings,
    required this.clock,
  });

  final SupabaseClient _supabase;
  final LocalSettings localSettings;
  final Clock clock;

  static const _sessionEvents = {
    AuthChangeEvent.initialSession,
    AuthChangeEvent.signedIn,
    AuthChangeEvent.tokenRefreshed,
    AuthChangeEvent.userUpdated,
  };

  Stream<AuthState> authStateChanges() => _supabase.auth.onAuthStateChange;

  static bool eventHasSession(AuthChangeEvent event) =>
      _sessionEvents.contains(event);

  Future<void> signIn({required String email, required String password}) async {
    try {
      await _supabase.auth.signInWithPassword(
        email: email,
        password: password,
      );
      _rememberSignIn();
    } catch (error, stackTrace) {
      _throwMapped(error, stackTrace, forSignUp: false);
    }
  }

  /// Returns true when a session was created, false when email confirmation is pending.
  Future<bool> signUp({
    required String fullName,
    required String email,
    required String password,
  }) async {
    try {
      final response = await _supabase.auth.signUp(
        email: email,
        password: password,
        data: {'full_name': fullName},
        emailRedirectTo: _onboardingRedirectUrl,
      );
      final createdSession = response.session != null;
      if (createdSession) {
        _rememberSignIn();
      }
      return createdSession;
    } catch (error, stackTrace) {
      _throwMapped(error, stackTrace, forSignUp: true);
    }
  }

  Future<void> signOut() async {
    localSettings.remove(LocalSettings.signedInAtKey);
    await _supabase.auth.signOut(scope: SignOutScope.local);
  }

  Future<AppUser?> fetchCurrentUser() async {
    final session = _supabase.auth.currentSession;
    if (session == null) return null;

    final row = await _supabase
        .from(UsersTable.name)
        .select(
          '${UsersTable.id}, ${UsersTable.email}, ${UsersTable.fullName}, '
          '${MembershipsTable.name} (${MembershipsTable.businessId}, '
          '${MembershipsTable.role}, ${MembershipsTable.joinedAt})',
        )
        .eq(UsersTable.id, session.user.id)
        .maybeSingle();

    if (row == null) return null;
    return AppUser.fromJson(row);
  }

  void rememberSignInIfMissing() {
    if (localSettings.get(LocalSettings.signedInAtKey) != null) return;
    if (_supabase.auth.currentSession == null) return;
    _rememberSignIn();
  }

  void _rememberSignIn() {
    localSettings.set(
      LocalSettings.signedInAtKey,
      clock.now().toUtc().toIso8601String(),
    );
  }

  String get _onboardingRedirectUrl {
    if (kIsWeb) {
      return '${Uri.base.origin}${AppRoutes.onboarding}';
    }
    return 'http://127.0.0.1:3000${AppRoutes.onboarding}';
  }

  Never _throwMapped(
    Object error,
    StackTrace stackTrace, {
    required bool forSignUp,
  }) {
    if (error is AuthRetryableFetchException) {
      throw const AuthFailure.network();
    }
    if (error is AuthException) {
      final code = (error.code ?? '').toLowerCase();
      final message = error.message.toLowerCase();
      if (forSignUp) {
        if (code == 'user_already_exists' ||
            code == 'email_exists' ||
            message.contains('already registered') ||
            message.contains('already been registered')) {
          throw const AuthFailure.emailInUse();
        }
        if (code == 'weak_password' || message.contains('password')) {
          throw const AuthFailure.weakPassword();
        }
      } else if (code == 'invalid_credentials' ||
          message.contains('invalid login') ||
          message.contains('invalid credentials')) {
        throw const AuthFailure.invalidCredentials();
      }
      throw const AuthFailure.unknown();
    }
    throw const AuthFailure.unknown();
  }
}
