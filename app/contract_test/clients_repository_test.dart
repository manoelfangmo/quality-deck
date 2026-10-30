@Tags(<String>['contract'])
library;

import 'package:flutter_test/flutter_test.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'package:app/features/clients/data/clients_repository.dart';
import 'package:app/features/clients/data/models.dart';

import 'clean_up.dart';
import 'helpers.dart';

void main() {
  SupabaseClient? supabase;
  late ClientsRepository repository;
  late ContractCleanup cleanup;

  setUpAll(() async {
    supabase = await signInAsSeededOwner();
    repository = ClientsRepository(supabase!);
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

  group('ClientsRepository.fetchAll', () {
    test('returns Quality Deck clients and hides other businesses', () async {
      final clients = await repository.fetchAll();

      expect(clients, isNotEmpty);
      expect(clients.any((client) => client.fullName == 'Ana Melgar'), isTrue);
      expect(
        clients.any((client) => client.fullName == 'Other Client A'),
        isFalse,
      );
      expect(
        clients.any((client) => client.fullName == 'Old Client One'),
        isFalse,
      );
    });
  });

  group('ClientsRepository.fetchPage', () {
    test('returns a page of clients and the total count', () async {
      final page = await repository.fetchPage(page: 0, pageSize: 10);

      expect(page.clients, hasLength(10));
      expect(page.total, greaterThanOrEqualTo(30));
      expect(
        page.clients.every((client) => client.fullName.isNotEmpty),
        isTrue,
      );
    });
  });

  group('ClientsRepository.create', () {
    test('inserts a client that the next fetch returns', () async {
      final stamp = uniqueStamp();

      final created = await repository.create(
        CreateClientCommand(
          fullName: 'CT Client $stamp',
          email: 'ct-client-$stamp@fieldnotes.test',
          phone: '3015550199',
          street: '99 Test St',
          city: 'Bowie',
          state: 'md',
          zip: '20715',
        ),
      );
      cleanup.trackClient(created.id);

      expect(created.id, isUuid);
      expect(created.fullName, 'CT Client $stamp');
      expect(created.email, 'ct-client-$stamp@fieldnotes.test');
      expect(created.phone, '+13015550199');
      expect(created.address?.state, 'MD');

      final fetched = (await repository.fetchAll()).firstWhere(
        (client) => client.id == created.id,
      );
      expect(fetched.fullName, 'CT Client $stamp');
      expect(fetched.email, 'ct-client-$stamp@fieldnotes.test');
      expect(fetched.phone, '+13015550199');
      expect(fetched.address?.street, '99 Test St');
      expect(fetched.address?.city, 'Bowie');
      expect(fetched.address?.state, 'MD');
      expect(fetched.address?.zip, '20715');
    });
  });

  group('ClientsRepository.update', () {
    test('persists edits that the next fetch returns', () async {
      final stamp = uniqueStamp();
      final created = await repository.create(
        CreateClientCommand(
          fullName: 'CT Before $stamp',
          email: 'ct-before-$stamp@fieldnotes.test',
          phone: '3015550111',
        ),
      );
      cleanup.trackClient(created.id);

      await repository.update(
        UpdateClientCommand(
          id: created.id,
          fullName: 'CT After $stamp',
          email: 'ct-after-$stamp@fieldnotes.test',
          phone: '3015550222',
          street: '12 Oak St',
          city: 'Bowie',
          state: 'MD',
          zip: '20715',
        ),
      );

      final fetched = (await repository.fetchAll()).firstWhere(
        (client) => client.id == created.id,
      );
      expect(fetched.fullName, 'CT After $stamp');
      expect(fetched.email, 'ct-after-$stamp@fieldnotes.test');
      expect(fetched.phone, '+13015550222');
      expect(fetched.address?.street, '12 Oak St');
    });
  });

  group('ClientsRepository.search', () {
    test('matches name or phone and hides removed clients', () async {
      final byName = await repository.search('Ana Melgar');
      expect(byName.any((client) => client.fullName == 'Ana Melgar'), isTrue);
      expect(byName.length, lessThanOrEqualTo(20));

      final byPhone = await repository.search('3015550101');
      expect(byPhone.any((client) => client.fullName == 'Ana Melgar'), isTrue);

      final removed = await repository.search('Old Client One');
      expect(removed, isEmpty);
    });
  });

  group('ClientsRepository.remove', () {
    test('hides the client from later fetches', () async {
      final created = await createUniqueClient(repository);
      cleanup.trackClient(created.id);

      await repository.remove(created.id);

      final fetched = await repository.fetchAll();
      expect(fetched.any((client) => client.id == created.id), isFalse);
    });
  });
}
