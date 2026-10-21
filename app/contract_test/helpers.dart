import 'package:clock/clock.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'package:app/core/constants/environment.dart';
import 'package:app/core/utils/local_store.dart';
import 'package:app/features/auth/data/auth_repository.dart';
import 'package:app/features/clients/data/clients_repository.dart';
import 'package:app/features/clients/data/models.dart';
import 'package:app/features/clients/domain/client.dart';

import 'test_env.dart';

abstract final class SeedUsers {
  static const password = 'password123';

  static const ownerEmail = 'owner@qualitydeck.test';
  static const ownerId = '00000000-0000-4000-8000-000000000001';
  static const ownerName = 'Moises (dev)';

  static const crewEmail = 'crew@qualitydeck.test';
  static const crewId = '00000000-0000-4000-8000-000000000002';
  static const crewName = 'Crew Member';

  static const otherOwnerEmail = 'other@example.test';
  static const otherOwnerId = '00000000-0000-4000-8000-000000000003';

  static const noBusinessEmail = 'nobusiness@example.test';
  static const noBusinessId = '00000000-0000-4000-8000-000000000004';

  static const joinerEmail = 'joiner@example.test';
  static const joinerId = '00000000-0000-4000-8000-000000000005';

  static const qualityDeckId = '00000000-0000-4000-8000-000000000011';
  static const otherCoId = '00000000-0000-4000-8000-000000000012';
}

abstract final class SeedClients {
  static const anaMelgarId = '00000000-0000-4000-8000-000000000101';
  static const jamesWhitakerId = '00000000-0000-4000-8000-000000000102';
  static const priyaShahId = '00000000-0000-4000-8000-000000000103';
}

abstract final class SeedAppointments {
  static const anaUpcomingId = '00000000-0000-4000-8000-000000000201';
}

abstract final class SeedProjects {
  static const anaOakId = '00000000-0000-4000-8000-000000000401';
  static const jamesPineId = '00000000-0000-4000-8000-000000000403';
  static const removedClientProjectId = '00000000-0000-4000-8000-000000000406';
  static const archivedBarkerId = '00000000-0000-4000-8000-000000000426';
}

abstract final class SeedInvites {
  static const active = 'QDACTIVE';
  static const expired = 'QDEXPIRD';
  static const used = 'QDUSED22';
  static const revoked = 'QDREVOKD';
}

final Matcher isUuid = matches(
  RegExp(
    r'^[0-9a-fA-F]{8}-[0-9a-fA-F]{4}-[0-9a-fA-F]{4}-[0-9a-fA-F]{4}-[0-9a-fA-F]{12}$',
  ),
);

void validateContractTestEnv() {
  if (Environment.supabaseUrl.isEmpty ||
      Environment.supabaseAnonKey.isEmpty ||
      TestEnv.serviceRoleKey.isEmpty) {
    throw StateError(
      'Missing SUPABASE_URL / SUPABASE_ANON_KEY / SUPABASE_SERVICE_ROLE_KEY. '
      'Pass them with --dart-define-from-file contract_test.env.',
    );
  }
}

int uniqueStamp() => DateTime.now().microsecondsSinceEpoch;

/// Direct SDK client. Implicit flow avoids PKCE, which needs the async
/// storage that only `Supabase.initialize()` installs.
SupabaseClient newAnonClient() {
  return SupabaseClient(
    Environment.supabaseUrl,
    Environment.supabaseAnonKey,
    authOptions: const AuthClientOptions(authFlowType: AuthFlowType.implicit),
  );
}

AuthRepository buildAuthRepository(SupabaseClient client) {
  return AuthRepository(
    client,
    localSettings: LocalSettings(MemoryLocalStore()),
    clock: const Clock(),
  );
}

Future<SupabaseClient> signInAs(String email, String password) async {
  validateContractTestEnv();
  final client = newAnonClient();
  await buildAuthRepository(client).signIn(email: email, password: password);
  return client;
}

Future<SupabaseClient> signInAsSeededOwner() {
  return signInAs(SeedUsers.ownerEmail, SeedUsers.password);
}

Future<SupabaseClient> signInAsSeededNoBusiness() {
  return signInAs(SeedUsers.noBusinessEmail, SeedUsers.password);
}

class SignedInSession {
  SignedInSession({
    required this.client,
    required this.userId,
    required this.email,
  });

  final SupabaseClient client;
  final String userId;
  final String email;
}

/// Creates a brand-new auth user and returns a signed-in client.
/// The caller must [ContractCleanup.trackSignedUp] immediately.
Future<SignedInSession> signUpUniqueUser({String prefix = 'user'}) async {
  validateContractTestEnv();
  final stamp = uniqueStamp();
  final email = 'ct-$prefix-$stamp@fieldnotes.test';
  final client = newAnonClient();
  final createdSession = await buildAuthRepository(client).signUp(
    fullName: 'Contract $prefix $stamp',
    email: email,
    password: SeedUsers.password,
  );
  final userId = client.auth.currentUser?.id;
  if (!createdSession || userId == null) {
    await client.dispose();
    throw StateError('signUp did not create a session for $email');
  }
  return SignedInSession(client: client, userId: userId, email: email);
}

Future<Client> createUniqueClient(ClientsRepository repository) {
  final stamp = uniqueStamp();
  return repository.create(
    CreateClientCommand(
      fullName: 'CT Client $stamp',
      email: 'ct-client-$stamp@fieldnotes.test',
      phone: '3015550100',
    ),
  );
}

void expectSameUtcParts(DateTime actual, DateTime expected) {
  final a = actual.toUtc();
  final e = expected.toUtc();
  expect(a.year, e.year);
  expect(a.month, e.month);
  expect(a.day, e.day);
  expect(a.hour, e.hour);
  expect(a.minute, e.minute);
}
