@Tags(<String>['contract'])
library;

import 'package:flutter_test/flutter_test.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'package:app/core/domain/user_role.dart';
import 'package:app/features/business/data/business_repository.dart';
import 'package:app/features/business/data/invites_repository.dart';
import 'package:app/features/business/data/models.dart';

import 'clean_up.dart';
import 'helpers.dart';

void main() {
  SupabaseClient? supabase;
  late BusinessRepository repository;
  late InvitesRepository invites;
  late ContractCleanup cleanup;

  setUpAll(() async {
    supabase = await signInAsSeededOwner();
    repository = BusinessRepository(supabase!);
    invites = InvitesRepository(supabase!);
    cleanup = ContractCleanup();
    await cleanup.snapshotQualityDeckName();
  });

  tearDown(() async {
    await cleanup.teardown();
  });

  tearDownAll(() async {
    await cleanup.dispose();
    await supabase?.auth.signOut();
    await supabase?.dispose();
  });

  group('BusinessRepository.fetchBusiness', () {
    test('returns Quality Deck for the seeded owner', () async {
      final business = await repository.fetchBusiness();

      expect(business, isNotNull);
      expect(business!.id, SeedUsers.qualityDeckId);
      expect(business.name, 'Quality Deck');
      expect(business.ownerId, SeedUsers.ownerId);
    });
  });

  group('BusinessRepository.fetchMembers', () {
    test('returns the seeded owner and crew', () async {
      final members = await repository.fetchMembers();
      final emails = members.map((member) => member.email).toSet();

      expect(
        emails,
        containsAll(<String>[SeedUsers.ownerEmail, SeedUsers.crewEmail]),
      );
      expect(
        members.firstWhere((member) => member.id == SeedUsers.ownerId).role,
        UserRole.owner,
      );
      expect(
        members.firstWhere((member) => member.id == SeedUsers.crewId).role,
        UserRole.member,
      );
    });
  });

  group('BusinessRepository.createBusiness', () {
    test('creates a business for a user with no membership', () async {
      final stamp = uniqueStamp();
      final session = await signUpUniqueUser(prefix: 'biz');
      cleanup.trackSignedUp(session);
      final created = BusinessRepository(session.client);

      final id = await created.createBusiness(
        CreateBusinessCommand(name: 'CT Co $stamp'),
      );
      cleanup.trackBusiness(id);

      expect(id, isUuid);
      final business = await created.fetchBusiness();
      expect(business, isNotNull);
      expect(business!.id, id);
      expect(business.name, 'CT Co $stamp');
      expect(business.ownerId, session.userId);
    });
  });

  group('BusinessRepository.redeemInvite', () {
    test('joins the caller to the business that issued the code', () async {
      final invite = await invites.createInvite();
      cleanup.trackInvite(invite.id);

      final session = await signUpUniqueUser(prefix: 'join');
      cleanup.trackSignedUp(session);
      final joiner = BusinessRepository(session.client);

      final businessId = await joiner.redeemInvite(
        RedeemInviteCommand(code: invite.code),
      );

      expect(businessId, SeedUsers.qualityDeckId);
      final members = await repository.fetchMembers();
      final joined = members.where((member) => member.id == session.userId);
      expect(joined, hasLength(1));
      expect(joined.first.role, UserRole.member);
      expect(joined.first.email, session.email);
    });
  });

  group('BusinessRepository.removeMember', () {
    test('drops a member that was added through an invite', () async {
      final invite = await invites.createInvite();
      cleanup.trackInvite(invite.id);

      final session = await signUpUniqueUser(prefix: 'rm');
      cleanup.trackSignedUp(session);
      await BusinessRepository(session.client).redeemInvite(
        RedeemInviteCommand(code: invite.code),
      );

      await repository.removeMember(session.userId);

      final members = await repository.fetchMembers();
      expect(members.any((member) => member.id == session.userId), isFalse);
    });
  });

  group('BusinessRepository.renameBusiness', () {
    test('persists the new name on the next fetch', () async {
      final stamp = uniqueStamp();

      await repository.renameBusiness(
        businessId: SeedUsers.qualityDeckId,
        name: 'CT Rename $stamp',
      );

      final business = await repository.fetchBusiness();
      expect(business, isNotNull);
      expect(business!.name, 'CT Rename $stamp');
    });
  });
}
