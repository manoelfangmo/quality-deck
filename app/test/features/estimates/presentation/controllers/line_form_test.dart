import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import 'package:app/core/domain/pricing_type.dart';
import 'package:app/features/estimates/data/line_items_repository.dart';
import 'package:app/features/estimates/data/models.dart';
import 'package:app/features/estimates/presentation/controllers/line_form.dart';
import 'package:app/features/estimates/presentation/controllers/project_jobs.dart';

import '../../../../helpers/fixtures.dart';
import '../../../../mocks.dart';

void main() {
  late MockLineItemsRepository lines;

  ProviderContainer container() {
    return ProviderContainer(
      retry: (count, error) => null,
      overrides: [
        lineItemsRepositoryProvider.overrideWithValue(lines),
        projectJobsProvider(backDeckJob.projectId).overrideWith(
          (ref) async => [backDeckWithLines],
        ),
      ],
    );
  }

  setUp(() {
    lines = MockLineItemsRepository();
  });

  test('add custom sends name, type, quantity, description and price', () async {
    when(lines.addCustom(any)).thenAnswer((_) async => 'new-id');

    final c = container();
    addTearDown(c.dispose);
    final notifier = c.read(
      lineFormControllerProvider(
        projectId: backDeckJob.projectId,
        jobId: backDeckJob.id,
      ).notifier,
    );
    notifier.setName('Haul-away');
    notifier.setPricingType(PricingType.fixed);
    notifier.setPrice('250');

    final saved = await notifier.submit();

    expect(saved, isTrue);
    final command =
        verify(lines.addCustom(captureAny)).captured.single as AddCustomLineCommand;
    expect(command.name, 'Haul-away');
    expect(command.pricingType, PricingType.fixed);
    expect(command.quantity.hundredths, 100);
    expect(command.priceCents, 25000);
    verifyNever(lines.update(any));
  });

  test('price-list edit sends quantity, description and override', () async {
    when(lines.update(any)).thenAnswer((_) async {});

    final c = container();
    addTearDown(c.dispose);
    final notifier = c.read(
      lineFormControllerProvider(
        projectId: backDeckJob.projectId,
        jobId: backDeckJob.id,
        item: compositeLine,
      ).notifier,
    );
    notifier.setPrice('4.25');
    notifier.setQuantity('200');

    final saved = await notifier.submit();

    expect(saved, isTrue);
    final command =
        verify(lines.update(captureAny)).captured.single as UpdateLineCommand;
    expect(command.id, compositeLine.id);
    expect(command.quantity.hundredths, 20000);
    expect(command.overridePriceCents, 425);
    expect(command.name, isNull);
    expect(command.pricingType, isNull);
    expect(command.priceCents, isNull);
  });

  test('Reset sends a null override', () async {
    when(lines.update(any)).thenAnswer((_) async {});

    final c = container();
    addTearDown(c.dispose);
    final notifier = c.read(
      lineFormControllerProvider(
        projectId: backDeckJob.projectId,
        jobId: backDeckJob.id,
        item: overriddenRailing,
      ).notifier,
    );
    notifier.resetOverride();

    final saved = await notifier.submit();

    expect(saved, isTrue);
    final command =
        verify(lines.update(captureAny)).captured.single as UpdateLineCommand;
    expect(command.overridePriceCents, isNull);
  });

  test('preview total updates as quantity or price change, before saving', () {
    final c = container();
    addTearDown(c.dispose);
    final notifier = c.read(
      lineFormControllerProvider(
        projectId: backDeckJob.projectId,
        jobId: backDeckJob.id,
        item: compositeLine,
      ).notifier,
    );

    expect(notifier.previewTotal?.cents, 86625);
    notifier.setQuantity('200');
    expect(notifier.previewTotal?.cents, 90000);
    notifier.setPrice('4.25');
    expect(notifier.previewTotal?.cents, 85000);
    verifyNever(lines.update(any));
  });
}
