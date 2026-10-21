@Tags(<String>['contract'])
library;

import 'package:flutter_test/flutter_test.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'package:app/core/domain/money.dart';
import 'package:app/core/domain/pricing_type.dart';
import 'package:app/features/pricing/data/models.dart';
import 'package:app/features/pricing/data/price_items_repository.dart';

import 'clean_up.dart';
import 'helpers.dart';

void main() {
  SupabaseClient? supabase;
  late PriceItemsRepository repository;
  late ContractCleanup cleanup;

  setUpAll(() async {
    supabase = await signInAsSeededOwner();
    repository = PriceItemsRepository(supabase!);
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

  group('PriceItemsRepository.fetchAll', () {
    test('returns Quality Deck items and hides other businesses', () async {
      final items = await repository.fetchAll();

      expect(items, isNotEmpty);
      expect(
        items.any((item) => item.name == 'New Composite Deck - Trex Transcend'),
        isTrue,
      );
      expect(items.any((item) => item.name == 'Hourly labor'), isFalse);
      expect(items.every((item) => item.name.isNotEmpty), isTrue);
      expect(items.every((item) => item.price.cents >= 0), isTrue);
    });
  });

  group('PriceItemsRepository.fetchPage', () {
    test('returns a page of items and the total count', () async {
      final page = await repository.fetchPage(page: 0, pageSize: 10);

      expect(page.items, hasLength(10));
      expect(page.total, greaterThanOrEqualTo(25));
    });
  });

  group('PriceItemsRepository.search', () {
    test('matches name and hides other businesses', () async {
      final matches = await repository.search('composite', limit: 30);

      expect(
        matches.any(
          (item) => item.name == 'New Composite Deck - Trex Enhance or Select',
        ),
        isTrue,
      );
      expect(matches.length, lessThanOrEqualTo(30));
      expect(matches.any((item) => item.name == 'Hourly labor'), isFalse);
    });
  });

  group('PriceItemsRepository.create', () {
    test('inserts an item that the next fetch returns', () async {
      final stamp = uniqueStamp();

      final created = await repository.create(
        CreatePriceItemCommand(
          name: 'CT item $stamp',
          description: 'Contract test',
          pricingType: PricingType.perSqFt,
          priceCents: 425,
        ),
      );
      cleanup.trackPriceItem(created.id);

      expect(created.id, isUuid);
      expect(created.name, 'CT item $stamp');
      expect(created.pricingType, PricingType.perSqFt);
      expect(created.price, const Money(425));

      final fetched = (await repository.fetchAll()).firstWhere(
        (item) => item.id == created.id,
      );
      expect(fetched.name, 'CT item $stamp');
      expect(fetched.description, 'Contract test');
      expect(fetched.pricingType, PricingType.perSqFt);
      expect(fetched.price, const Money(425));
    });
  });

  group('PriceItemsRepository.update', () {
    test('persists edits that the next fetch returns', () async {
      final stamp = uniqueStamp();
      final created = await repository.create(
        CreatePriceItemCommand(
          name: 'CT before $stamp',
          pricingType: PricingType.fixed,
          priceCents: 1000,
        ),
      );
      cleanup.trackPriceItem(created.id);

      await repository.update(
        UpdatePriceItemCommand(
          id: created.id,
          name: 'CT after $stamp',
          description: 'Updated',
          pricingType: PricingType.perUnit,
          priceCents: 2500,
        ),
      );

      final fetched = (await repository.fetchAll()).firstWhere(
        (item) => item.id == created.id,
      );
      expect(fetched.name, 'CT after $stamp');
      expect(fetched.description, 'Updated');
      expect(fetched.pricingType, PricingType.perUnit);
      expect(fetched.price, const Money(2500));
    });
  });

  group('PriceItemsRepository.delete', () {
    test('removes the item from later fetches', () async {
      final stamp = uniqueStamp();
      final created = await repository.create(
        CreatePriceItemCommand(
          name: 'CT delete $stamp',
          pricingType: PricingType.fixed,
          priceCents: 500,
        ),
      );
      cleanup.trackPriceItem(created.id);

      await repository.delete(created.id);

      final fetched = await repository.fetchAll();
      expect(fetched.any((item) => item.id == created.id), isFalse);
    });
  });
}
