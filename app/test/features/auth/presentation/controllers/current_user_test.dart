import 'dart:async';

import 'package:clock/clock.dart';
import 'package:fake_async/fake_async.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'package:app/core/utils/local_store.dart';
import 'package:app/core/utils/providers.dart';
import 'package:app/features/auth/data/auth_repository.dart';
import 'package:app/features/auth/presentation/controllers/auth_notice.dart';
import 'package:app/features/auth/presentation/controllers/current_user.dart';

import '../../../../helpers/fixtures.dart';
import '../../../../mocks.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  late MockAuthRepository auth;
  late StreamController<AuthState> events;
  late LocalSettings settings;

  ProviderContainer makeContainer({Clock? clock}) {
    return ProviderContainer(
      retry: (count, error) => null,
      overrides: [
        authRepositoryProvider.overrideWithValue(auth),
        authStateChangesProvider.overrideWith((ref) => events.stream),
        localSettingsProvider.overrideWithValue(settings),
        if (clock != null) clockProvider.overrideWithValue(clock),
      ],
    );
  }

  setUp(() {
    auth = MockAuthRepository();
    events = StreamController<AuthState>.broadcast();
    settings = LocalSettings(MemoryLocalStore());
    when(auth.authStateChanges()).thenAnswer((_) => events.stream);
  });

  tearDown(() async {
    await events.close();
  });

  test('null without session', () async {
    when(auth.fetchCurrentUser()).thenAnswer((_) async => null);

    final c = makeContainer();
    addTearDown(c.dispose);
    c.listen(currentUserProvider, (_, _) {}, fireImmediately: true);

    events.add(const AuthState(AuthChangeEvent.initialSession, null));
    await c.read(currentUserProvider.future);

    expect(c.read(currentUserProvider).value, isNull);
  });

  test('loads user and membership on signedIn', () async {
    when(auth.fetchCurrentUser()).thenAnswer((_) async => ownerUser);

    final c = makeContainer();
    addTearDown(c.dispose);
    c.listen(currentUserProvider, (_, _) {}, fireImmediately: true);

    events.add(const AuthState(AuthChangeEvent.signedIn, null));
    final user = await c.read(currentUserProvider.future);

    expect(user, ownerUser);
    expect(user?.hasBusiness, isTrue);
  });

  test('signs out when a reload shows the membership is gone', () {
    fakeAsync((async) {
      when(auth.fetchCurrentUser()).thenAnswer((_) async => ownerUser);
      when(auth.signOut()).thenAnswer((_) async {});

      final c = makeContainer(
        clock: Clock.fixed(DateTime.utc(2026, 10, 20)),
      );
      addTearDown(c.dispose);
      c.listen(currentUserProvider, (_, _) {}, fireImmediately: true);

      events.add(const AuthState(AuthChangeEvent.signedIn, null));
      async.flushMicrotasks();
      expect(c.read(currentUserProvider).value, ownerUser);

      when(auth.fetchCurrentUser()).thenAnswer((_) async => noBusinessUser);

      async.elapse(membershipReloadInterval);
      async.flushMicrotasks();
      c.read(membershipReloadTickProvider.notifier).bump();
      async.flushMicrotasks();

      verify(auth.signOut()).called(1);
      expect(
        c.read(authNoticeProvider),
        AuthMessages.noLongerHaveAccess,
      );
      expect(c.read(currentUserProvider).value, isNull);
    });
  });

  test('frozen clock at sign-in + 30 days + 1 minute signs out', () async {
    final signedInAt = DateTime.utc(2026, 9, 20, 12);
    settings.set(LocalSettings.signedInAtKey, signedInAt.toIso8601String());
    when(auth.fetchCurrentUser()).thenAnswer((_) async => ownerUser);
    when(auth.signOut()).thenAnswer((_) async {});

    final c = makeContainer(
      clock: Clock.fixed(signedInAt.add(const Duration(days: 30, minutes: 1))),
    );
    addTearDown(c.dispose);
    c.listen(currentUserProvider, (_, _) {}, fireImmediately: true);

    events.add(const AuthState(AuthChangeEvent.signedIn, null));
    await c.read(currentUserProvider.future);

    verify(auth.signOut()).called(1);
    expect(c.read(currentUserProvider).value, isNull);
  });
}
