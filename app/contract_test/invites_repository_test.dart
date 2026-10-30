@Tags(<String>['contract'])
library;

import 'package:flutter_test/flutter_test.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'package:app/features/business/data/invites_repository.dart';
import 'package:app/features/business/domain/invite_status.dart';

import 'clean_up.dart';
import 'helpers.dart';

void main() {
  SupabaseClient? supabase;
  late InvitesRepository repository;
  late ContractCleanup cleanup;

  setUpAll(() async {
    supabase = await signInAsSeededOwner();
    repository = InvitesRepository(supabase!);
    cleanup = ContractCleanup();
  });

  tearDown(() async {
    await cleanup.teardown();
  });

  tearDownAll(() async {
    await cleanup.dispose();
    await supabase?.auth.signOut();
    await supabase?.dispose();
  });

  group('InvitesRepository.fetchInvites', () {
    test('returns seeded Quality Deck invites', () async {
      final invites = await repository.fetchInvites();

      expect(invites, isNotEmpty);
      expect(
        invites.any(
          (invite) =>
              invite.code == SeedInvites.active &&
              invite.status == InviteStatus.active,
        ),
        isTrue,
      );
      expect(
        invites.any(
          (invite) =>
              invite.code == SeedInvites.used &&
              invite.status == InviteStatus.used &&
              invite.usedByName == SeedUsers.crewName,
        ),
        isTrue,
      );
    });
  });

  group('InvitesRepository.createInvite', () {
    test('returns an active invite that appears on the next fetch', () async {
      final invite = await repository.createInvite();
      cleanup.trackInvite(invite.id);

      expect(invite.id, isUuid);
      expect(invite.code, isNotEmpty);
      expect(invite.status, InviteStatus.active);

      final fetched = await repository.fetchInvites();
      expect(fetched.any((row) => row.id == invite.id), isTrue);
    });
  });

  group('InvitesRepository.revokeInvite', () {
    test('marks an active invite revoked', () async {
      final invite = await repository.createInvite();
      cleanup.trackInvite(invite.id);

      await repository.revokeInvite(invite.id);

      final fetched = await repository.fetchInvites();
      final revoked = fetched.firstWhere((row) => row.id == invite.id);
      expect(revoked.status, InviteStatus.revoked);
    });
  });
}
