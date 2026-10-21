import 'dart:async';

import 'package:flutter/widgets.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'package:app/core/domain/app_user.dart';
import 'package:app/core/utils/local_store.dart';
import 'package:app/core/utils/providers.dart';
import 'package:app/features/auth/data/auth_repository.dart';
import 'package:app/features/auth/presentation/controllers/auth_notice.dart';

part 'current_user.g.dart';

const membershipReloadInterval = Duration(minutes: 5);
const sessionLifetime = Duration(days: 30);

@Riverpod(keepAlive: true)
Stream<AuthState> authStateChanges(Ref ref) {
  return ref.watch(authRepositoryProvider).authStateChanges();
}

@Riverpod(keepAlive: true)
class MembershipReloadTick extends _$MembershipReloadTick {
  @override
  int build() {
    final timer = Timer.periodic(membershipReloadInterval, (_) {
      final lifecycle = WidgetsBinding.instance.lifecycleState;
      if (lifecycle == null || lifecycle == AppLifecycleState.resumed) {
        state++;
      }
    });
    ref.onDispose(timer.cancel);

    final listener = AppLifecycleListener(onShow: () => state++);
    ref.onDispose(listener.dispose);

    return 0;
  }

  void bump() => state++;
}

@Riverpod(keepAlive: true)
class CurrentUser extends _$CurrentUser {
  @override
  Future<AppUser?> build() async {
    ref.watch(membershipReloadTickProvider);
    final repo = ref.watch(authRepositoryProvider);
    final clock = ref.watch(clockProvider);
    final settings = ref.watch(localSettingsProvider);

    final AuthState authState;
    try {
      authState = await ref.watch(authStateChangesProvider.future);
    } catch (_) {
      return null;
    }

    if (!AuthRepository.eventHasSession(authState.event)) {
      return null;
    }

    repo.rememberSignInIfMissing();

    final signedInAtRaw = settings.get(LocalSettings.signedInAtKey);
    if (signedInAtRaw != null) {
      final signedInAt = DateTime.tryParse(signedInAtRaw);
      if (signedInAt != null &&
          clock.now().isAfter(signedInAt.add(sessionLifetime))) {
        await repo.signOut();
        settings.remove(LocalSettings.signedInAtKey);
        return null;
      }
    }

    final AppUser? user;
    try {
      user = await repo.fetchCurrentUser();
    } catch (error) {
      if (_isRevokedSession(error)) {
        await repo.signOut();
        return null;
      }
      rethrow;
    }

    final previous = state.value;
    if (previous?.hasBusiness == true && user?.hasBusiness != true) {
      ref.read(authNoticeProvider.notifier).show(AuthMessages.noLongerHaveAccess);
      await repo.signOut();
      return null;
    }

    return user;
  }

  bool _isRevokedSession(Object error) {
    if (error is AuthException) {
      final code = (error.code ?? '').toLowerCase();
      final message = error.message.toLowerCase();
      return code.contains('session') ||
          code.contains('refresh_token') ||
          code.contains('jwt') ||
          message.contains('session') ||
          message.contains('refresh token') ||
          message.contains('jwt');
    }
    if (error is PostgrestException) {
      return error.code == 'PGRST301' || error.code == '401';
    }
    return false;
  }
}
