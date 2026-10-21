@Tags(<String>['contract'])
library;

import 'package:flutter_test/flutter_test.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'package:app/core/domain/app_exception.dart';
import 'package:app/core/domain/money.dart';
import 'package:app/core/domain/pricing_type.dart';
import 'package:app/core/domain/quantity.dart';
import 'package:app/features/clients/data/clients_repository.dart';
import 'package:app/features/estimates/data/jobs_repository.dart';
import 'package:app/features/estimates/data/line_items_repository.dart';
import 'package:app/features/estimates/data/models.dart';
import 'package:app/features/estimates/domain/job.dart';
import 'package:app/features/estimates/domain/job_type.dart';
import 'package:app/features/estimates/domain/line_item.dart';
import 'package:app/features/pricing/data/models.dart';
import 'package:app/features/pricing/data/price_items_repository.dart';
import 'package:app/features/projects/data/projects_repository.dart';

import 'clean_up.dart';
import 'helpers.dart';

void main() {
  SupabaseClient? supabase;
  late LineItemsRepository repository;
  late JobsRepository jobs;
  late ProjectsRepository projects;
  late ClientsRepository clients;
  late PriceItemsRepository priceItems;
  late ContractCleanup cleanup;

  setUpAll(() async {
    supabase = await signInAsSeededOwner();
    repository = LineItemsRepository(supabase!);
    jobs = JobsRepository(supabase!);
    projects = ProjectsRepository(supabase!);
    clients = ClientsRepository(supabase!);
    priceItems = PriceItemsRepository(supabase!);
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

  Future<Job> arrangeJob() async {
    final created = await createUniqueProject(
      projects: projects,
      clients: clients,
    );
    cleanup.trackClient(created.clientId);
    cleanup.trackProject(created.projectId);
    return jobs.create(
      CreateJobCommand(
        projectId: created.projectId,
        title: 'CT lines ${uniqueStamp()}',
        jobType: JobType.deck,
      ),
    );
  }

  Future<LineItem> lineOn(Job job, String lineId) async {
    final fetched = await jobs.fetchForProject(job.projectId);
    return fetched.single.lines.firstWhere((line) => line.id == lineId);
  }

  group('LineItemsRepository.addFromPriceList', () {
    test('copies name, type and price and computes the line total', () async {
      final job = await arrangeJob();

      final id = await repository.addFromPriceList(
        AddPriceListLineCommand(
          jobId: job.id,
          priceItemId: SeedPriceItems.compositeDeckingId,
          quantity: const Quantity(19250),
        ),
      );

      expect(id, isUuid);
      final line = await lineOn(job, id);
      expect(line.name, 'New Composite Deck - Trex Enhance or Select');
      expect(line.isCustom, isFalse);
      expect(line.priceItemId, SeedPriceItems.compositeDeckingId);
      expect(line.pricingType, PricingType.perSqFt);
      expect(line.quantity, const Quantity(19250));
      expect(line.savedPrice, const Money(9500));
      expect(line.overridePrice, isNull);
      expect(line.total, const Money(1828750));
    });

    test('forces quantity 1 on a fixed-price item', () async {
      final job = await arrangeJob();

      final id = await repository.addFromPriceList(
        AddPriceListLineCommand(
          jobId: job.id,
          priceItemId: SeedPriceItems.gritMinimumId,
          quantity: const Quantity(500),
        ),
      );

      final line = await lineOn(job, id);
      expect(line.pricingType, PricingType.fixed);
      expect(line.quantity, const Quantity(100));
      expect(line.savedPrice, const Money(2500));
      expect(line.total, const Money(2500));
    });

    test('keeps the copied price after the price item is edited or deleted', () async {
      final job = await arrangeJob();
      final stamp = uniqueStamp();
      final item = await priceItems.create(
        CreatePriceItemCommand(
          name: 'CT copy $stamp',
          description: 'Original',
          pricingType: PricingType.perSqFt,
          priceCents: 450,
        ),
      );
      cleanup.trackPriceItem(item.id);

      final id = await repository.addFromPriceList(
        AddPriceListLineCommand(
          jobId: job.id,
          priceItemId: item.id,
          quantity: const Quantity(19250),
        ),
      );

      await priceItems.update(
        UpdatePriceItemCommand(
          id: item.id,
          name: 'CT renamed $stamp',
          description: 'Changed',
          pricingType: PricingType.perUnit,
          priceCents: 999,
        ),
      );

      var line = await lineOn(job, id);
      expect(line.name, 'CT copy $stamp');
      expect(line.description, 'Original');
      expect(line.pricingType, PricingType.perSqFt);
      expect(line.savedPrice, const Money(450));
      expect(line.priceItemId, item.id);

      await priceItems.delete(item.id);

      line = await lineOn(job, id);
      expect(line.name, 'CT copy $stamp');
      expect(line.savedPrice, const Money(450));
      expect(line.total, const Money(86625));
      expect(line.priceItemId, isNull);
      expect(line.priceItemDeleted, isTrue);
    });

    test('raises price_item_not_found for another business\'s item', () async {
      final job = await arrangeJob();

      try {
        await repository.addFromPriceList(
          AddPriceListLineCommand(
            jobId: job.id,
            priceItemId: SeedPriceItems.otherCoHourlyLaborId,
            quantity: const Quantity(100),
          ),
        );
        fail('expected AppException');
      } on AppException catch (error) {
        expect(error.token, 'price_item_not_found');
      }
    });

    test('raises project_archived when the project is archived', () async {
      final job = await arrangeJob();
      await projects.archive(job.projectId);

      try {
        await repository.addFromPriceList(
          AddPriceListLineCommand(
            jobId: job.id,
            priceItemId: SeedPriceItems.compositeDeckingId,
            quantity: const Quantity(19250),
          ),
        );
        fail('expected AppException');
      } on AppException catch (error) {
        expect(error.token, 'project_archived');
      }
    });
  });

  group('LineItemsRepository.addCustom', () {
    test('inserts a custom line the next fetch returns', () async {
      final job = await arrangeJob();
      final stamp = uniqueStamp();

      final id = await repository.addCustom(
        AddCustomLineCommand(
          jobId: job.id,
          name: '  Haul-away $stamp  ',
          description: 'Debris',
          pricingType: PricingType.fixed,
          quantity: const Quantity(500),
          priceCents: 25000,
        ),
      );

      final line = await lineOn(job, id);
      expect(line.isCustom, isTrue);
      expect(line.name, 'Haul-away $stamp');
      expect(line.description, 'Debris');
      expect(line.pricingType, PricingType.fixed);
      expect(line.quantity, const Quantity(100));
      expect(line.savedPrice, const Money(25000));
      expect(line.overridePrice, isNull);
      expect(line.total, const Money(25000));
    });
  });

  group('LineItemsRepository.update', () {
    test('applies a per-job override and Reset clears it', () async {
      final job = await arrangeJob();
      final id = await repository.addFromPriceList(
        AddPriceListLineCommand(
          jobId: job.id,
          priceItemId: SeedPriceItems.compositeDeckingId,
          quantity: const Quantity(19250),
        ),
      );

      await repository.update(
        UpdateLineCommand(
          id: id,
          quantity: const Quantity(19250),
          overridePriceCents: 425,
        ),
      );

      var line = await lineOn(job, id);
      expect(line.hasOverride, isTrue);
      expect(line.savedPrice, const Money(450));
      expect(line.overridePrice, const Money(425));
      expect(line.total, const Money(81813));

      await repository.update(
        UpdateLineCommand(
          id: id,
          quantity: const Quantity(19250),
        ),
      );

      line = await lineOn(job, id);
      expect(line.hasOverride, isFalse);
      expect(line.total, const Money(86625));
    });

    test('edits every field on a custom line', () async {
      final job = await arrangeJob();
      final id = await repository.addCustom(
        AddCustomLineCommand(
          jobId: job.id,
          name: 'Before',
          pricingType: PricingType.fixed,
          quantity: const Quantity(100),
          priceCents: 1000,
        ),
      );

      await repository.update(
        UpdateLineCommand(
          id: id,
          name: 'After',
          description: 'Updated',
          pricingType: PricingType.perUnit,
          quantity: const Quantity(300),
          priceCents: 1200,
        ),
      );

      final line = await lineOn(job, id);
      expect(line.isCustom, isTrue);
      expect(line.name, 'After');
      expect(line.description, 'Updated');
      expect(line.pricingType, PricingType.perUnit);
      expect(line.quantity, const Quantity(300));
      expect(line.savedPrice, const Money(1200));
      expect(line.total, const Money(3600));
    });

    test('rejects a new name on a price-list line', () async {
      final job = await arrangeJob();
      final id = await repository.addFromPriceList(
        AddPriceListLineCommand(
          jobId: job.id,
          priceItemId: SeedPriceItems.compositeDeckingId,
          quantity: const Quantity(19250),
        ),
      );

      try {
        await repository.update(
          UpdateLineCommand(
            id: id,
            quantity: const Quantity(19250),
            name: 'Nope',
          ),
        );
        fail('expected AppException');
      } on AppException catch (error) {
        expect(error.token, 'field_locked');
      }
    });
  });

  group('LineItemsRepository.reorder', () {
    test('persists the new order on the next fetch', () async {
      final job = await arrangeJob();
      final first = await repository.addCustom(
        AddCustomLineCommand(
          jobId: job.id,
          name: 'A',
          pricingType: PricingType.fixed,
          quantity: const Quantity(100),
          priceCents: 100,
        ),
      );
      final second = await repository.addCustom(
        AddCustomLineCommand(
          jobId: job.id,
          name: 'B',
          pricingType: PricingType.fixed,
          quantity: const Quantity(100),
          priceCents: 200,
        ),
      );
      final third = await repository.addCustom(
        AddCustomLineCommand(
          jobId: job.id,
          name: 'C',
          pricingType: PricingType.fixed,
          quantity: const Quantity(100),
          priceCents: 300,
        ),
      );

      await repository.reorder(job.id, [third, first, second]);

      final fetched = await jobs.fetchForProject(job.projectId);
      expect(fetched.single.lines.map((line) => line.id).toList(), [
        third,
        first,
        second,
      ]);
      expect(fetched.single.lines.map((line) => line.position).toList(), [
        0,
        1,
        2,
      ]);
    });
  });

  group('LineItemsRepository.delete', () {
    test('removes the line from later fetches', () async {
      final job = await arrangeJob();
      final id = await repository.addCustom(
        AddCustomLineCommand(
          jobId: job.id,
          name: 'Gone',
          pricingType: PricingType.fixed,
          quantity: const Quantity(100),
          priceCents: 500,
        ),
      );

      await repository.delete(id);

      final fetched = await jobs.fetchForProject(job.projectId);
      expect(fetched.single.lines, isEmpty);
    });
  });
}
