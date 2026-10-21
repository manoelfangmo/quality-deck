import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'package:app/core/domain/app_user.dart';
import 'package:app/features/auth/data/auth_repository.dart';
import 'package:app/features/auth/domain/auth_failure.dart';
import 'package:app/features/auth/presentation/controllers/auth_controller.dart';
import 'package:app/features/auth/presentation/controllers/current_user.dart';

import '../../../../helpers/fixtures.dart';
import '../../../../mocks.dart';

void main() {
  late MockAuthRepository auth;

  ProviderContainer container() {
    return ProviderContainer(
      retry: (count, error) => null,
      overrides: [
        authRepositoryProvider.overrideWithValue(auth),
        currentUserProvider.overrideWith(() => FakeCurrentUser(null)),
        authStateChangesProvider.overrideWith(
          (ref) => Stream<AuthState>.empty(),
        ),
      ],
    );
  }

  setUp(() {
    auth = MockAuthRepository();
  });

  test('signUp passes trimmed name/email', () async {
    when(
      auth.signUp(
        fullName: anyNamed('fullName'),
        email: anyNamed('email'),
        password: anyNamed('password'),
      ),
    ).thenAnswer((_) async => true);

    final c = container();
    addTearDown(c.dispose);

    await c
        .read(authControllerProvider.notifier)
        .signUp(
          fullName: '  Moises  ',
          email: '  owner@qualitydeck.test  ',
          password: 'password123',
        );

    verify(
      auth.signUp(
        fullName: 'Moises',
        email: 'owner@qualitydeck.test',
        password: 'password123',
      ),
    ).called(1);
  });

  test('signUp returns confirmation pending when repository returns false', () async {
    when(
      auth.signUp(
        fullName: anyNamed('fullName'),
        email: anyNamed('email'),
        password: anyNamed('password'),
      ),
    ).thenAnswer((_) async => false);

    final c = container();
    addTearDown(c.dispose);

    final result = await c
        .read(authControllerProvider.notifier)
        .signUp(
          fullName: 'Moises',
          email: 'owner@qualitydeck.test',
          password: 'password123',
        );

    expect(result, isFalse);
  });

  test('signUp maps emailInUse', () async {
    when(
      auth.signUp(
        fullName: anyNamed('fullName'),
        email: anyNamed('email'),
        password: anyNamed('password'),
      ),
    ).thenThrow(const AuthFailure.emailInUse());

    final c = container();
    addTearDown(c.dispose);

    await expectLater(
      c.read(authControllerProvider.notifier).signUp(
            fullName: 'Moises',
            email: 'owner@qualitydeck.test',
            password: 'password123',
          ),
      throwsA(isA<EmailInUse>()),
    );
  });

  test('signIn passes trimmed email', () async {
    when(
      auth.signIn(email: anyNamed('email'), password: anyNamed('password')),
    ).thenAnswer((_) async {});

    final c = container();
    addTearDown(c.dispose);

    await c
        .read(authControllerProvider.notifier)
        .signIn(email: '  owner@qualitydeck.test  ', password: 'password123');

    verify(
      auth.signIn(email: 'owner@qualitydeck.test', password: 'password123'),
    ).called(1);
  });

  test('signIn maps invalidCredentials', () async {
    when(
      auth.signIn(email: anyNamed('email'), password: anyNamed('password')),
    ).thenThrow(const AuthFailure.invalidCredentials());

    final c = container();
    addTearDown(c.dispose);

    await expectLater(
      c.read(authControllerProvider.notifier).signIn(
            email: 'owner@qualitydeck.test',
            password: 'wrong',
          ),
      throwsA(isA<InvalidCredentials>()),
    );
  });

  test('signOut invalidates currentUserProvider', () async {
    when(auth.signOut()).thenAnswer((_) async {});

    var builds = 0;
    final c = ProviderContainer(
      retry: (count, error) => null,
      overrides: [
        authRepositoryProvider.overrideWithValue(auth),
        currentUserProvider.overrideWith(() => _CountingUser(() => builds++)),
        authStateChangesProvider.overrideWith(
          (ref) => Stream<AuthState>.empty(),
        ),
      ],
    );
    addTearDown(c.dispose);

    c.listen(currentUserProvider, (_, _) {}, fireImmediately: true);
    await c.read(currentUserProvider.future);
    final buildsAfterListen = builds;

    await c.read(authControllerProvider.notifier).signOut();
    await c.read(currentUserProvider.future);

    verify(auth.signOut()).called(1);
    expect(builds, greaterThan(buildsAfterListen));
  });
}

class _CountingUser extends CurrentUser {
  _CountingUser(this.onBuild);

  final void Function() onBuild;

  @override
  Future<AppUser?> build() async {
    onBuild();
    return ownerUser;
  }
}
