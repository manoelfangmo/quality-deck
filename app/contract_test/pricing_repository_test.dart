@Tags(<String>['contract'])
library;

import 'package:flutter_test/flutter_test.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'package:app/core/domain/money.dart';
import 'package:app/core/domain/percent.dart';
import 'package:app/features/pricing/data/pricing_repository.dart';

import 'clean_up.dart';
import 'helpers.dart';

void main() {
  SupabaseClient? supabase;
  late PricingRepository repository;
  late ContractCleanup cleanup;

  setUpAll(() async {
    supabase = await signInAsSeededOwner();
    repository = PricingRepository(supabase!);
    cleanup = ContractCleanup();
    await cleanup.snapshotQualityDeckPricing();
  });

  tearDown(() async {
    await cleanup.teardown();
  });

  tearDownAll(() async {
    await cleanup.dispose();
    await supabase?.auth.signOut();
    await supabase?.dispose();
  });

  group('PricingRepository.fetchSettings', () {
    test('returns Quality Deck labor rate and overhead', () async {
      final settings = await repository.fetchSettings();

      expect(settings, isNotNull);
      expect(settings!.laborRate, const Money(6500));
      expect(settings.overhead, const Percent(1250));
    });
  });

  group('PricingRepository.updateLaborRate', () {
    test('persists the labor rate on the next fetch', () async {
      await repository.updateLaborRate(7200);

      final settings = await repository.fetchSettings();
      expect(settings, isNotNull);
      expect(settings!.laborRate, const Money(7200));
      expect(settings.overhead, const Percent(1250));
      expect(settings.updatedByName, SeedUsers.ownerName);
    });
  });

  group('PricingRepository.updateOverhead', () {
    test('persists overhead on the next fetch', () async {
      await repository.updateOverhead(1500);

      final settings = await repository.fetchSettings();
      expect(settings, isNotNull);
      expect(settings!.overhead, const Percent(1500));
      expect(settings.laborRate, const Money(6500));
      expect(settings.updatedByName, SeedUsers.ownerName);
    });
  });
}
