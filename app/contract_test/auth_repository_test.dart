@Tags(<String>['contract'])
library;

import 'package:flutter_test/flutter_test.dart';

import 'package:app/features/auth/domain/auth_failure.dart';

import 'clean_up.dart';
import 'helpers.dart';

void main() {
  late ContractCleanup cleanup;

  setUpAll(() {
    validateContractTestEnv();
    cleanup = ContractCleanup();
  });

  tearDown(() async {
    await cleanup.teardown();
  });

  tearDownAll(() async {
    await cleanup.dispose();
  });

  group('AuthRepository.signIn', () {
    test('opens a session for a seeded user', () async {
      final client = newAnonClient();
      cleanup.trackSession(client);
      final repository = buildAuthRepository(client);

      await repository.signIn(
        email: SeedUsers.ownerEmail,
        password: SeedUsers.password,
      );

      expect(client.auth.currentUser, isNotNull);
      expect(client.auth.currentUser!.email, SeedUsers.ownerEmail);
    });

    test('rejects an unknown password', () async {
      final client = newAnonClient();
      cleanup.trackSession(client);
      final repository = buildAuthRepository(client);

      await expectLater(
        repository.signIn(
          email: SeedUsers.ownerEmail,
          password: 'not-the-password',
        ),
        throwsA(const AuthFailure.invalidCredentials()),
      );
    });
  });

  group('AuthRepository.signUp', () {
    test('creates a user and a session', () async {
      final stamp = uniqueStamp();
      final client = newAnonClient();
      cleanup.trackSession(client);
      final repository = buildAuthRepository(client);

      final createdSession = await repository.signUp(
        fullName: 'Contract Auth $stamp',
        email: 'ct-auth-$stamp@fieldnotes.test',
        password: SeedUsers.password,
      );
      final userId = client.auth.currentUser?.id;
      if (userId != null) {
        cleanup.trackUser(userId);
      }

      expect(createdSession, isTrue);
      expect(userId, isUuid);
    });

    test('rejects an email that is already registered', () async {
      final client = newAnonClient();
      cleanup.trackSession(client);
      final repository = buildAuthRepository(client);

      await expectLater(
        repository.signUp(
          fullName: 'Duplicate Owner',
          email: SeedUsers.ownerEmail,
          password: SeedUsers.password,
        ),
        throwsA(const AuthFailure.emailInUse()),
      );
    });
  });

  group('AuthRepository.fetchCurrentUser', () {
    test('returns the seeded owner and their membership', () async {
      final client = await signInAsSeededOwner();
      cleanup.trackSession(client);
      final repository = buildAuthRepository(client);

      final user = await repository.fetchCurrentUser();

      expect(user, isNotNull);
      expect(user!.id, SeedUsers.ownerId);
      expect(user.email, SeedUsers.ownerEmail);
      expect(user.fullName, SeedUsers.ownerName);
      expect(user.hasBusiness, isTrue);
      expect(user.isOwner, isTrue);
      expect(user.membership!.businessId, SeedUsers.qualityDeckId);
    });

    test('returns a user with no membership when none exists', () async {
      final client = await signInAsSeededNoBusiness();
      cleanup.trackSession(client);
      final repository = buildAuthRepository(client);

      final user = await repository.fetchCurrentUser();

      expect(user, isNotNull);
      expect(user!.id, SeedUsers.noBusinessId);
      expect(user.email, SeedUsers.noBusinessEmail);
      expect(user.hasBusiness, isFalse);
    });

    test('returns null when there is no session', () async {
      final client = newAnonClient();
      cleanup.trackSession(client);
      final repository = buildAuthRepository(client);

      expect(await repository.fetchCurrentUser(), isNull);
    });
  });

  group('AuthRepository.signOut', () {
    test('clears the session', () async {
      final client = await signInAsSeededOwner();
      cleanup.trackSession(client);
      final repository = buildAuthRepository(client);

      await repository.signOut();

      expect(client.auth.currentSession, isNull);
      expect(await repository.fetchCurrentUser(), isNull);
    });
  });
}
