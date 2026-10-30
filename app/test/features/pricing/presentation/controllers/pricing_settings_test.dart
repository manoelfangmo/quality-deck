import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import 'package:app/features/pricing/data/pricing_repository.dart';
import 'package:app/features/pricing/presentation/controllers/pricing_settings.dart';

import '../../../../helpers/fixtures.dart';
import '../../../../mocks.dart';

void main() {
  late MockPricingRepository pricing;

  ProviderContainer container() {
    return ProviderContainer(
      retry: (count, error) => null,
      overrides: [pricingRepositoryProvider.overrideWithValue(pricing)],
    );
  }

  setUp(() {
    pricing = MockPricingRepository();
    when(pricing.fetchSettings()).thenAnswer((_) async => qualityDeckSettings);
  });

  test('saving labor rate calls the repository with cents and invalidates', () async {
    when(pricing.updateLaborRate(any)).thenAnswer((_) async {});

    final c = container();
    addTearDown(c.dispose);
    c.listen(pricingSettingsProvider, (_, _) {});
    await c.read(pricingSettingsProvider.future);

    final saved = await c
        .read(pricingSettingsControllerProvider.notifier)
        .saveLaborRate('70');

    expect(saved, isTrue);
    verify(pricing.updateLaborRate(7000)).called(1);
    await c.read(pricingSettingsProvider.future);
    verify(pricing.fetchSettings()).called(2);
  });

  test('saving overhead calls the repository with bps and invalidates', () async {
    when(pricing.updateOverhead(any)).thenAnswer((_) async {});

    final c = container();
    addTearDown(c.dispose);
    c.listen(pricingSettingsProvider, (_, _) {});
    await c.read(pricingSettingsProvider.future);

    final saved = await c
        .read(pricingSettingsControllerProvider.notifier)
        .saveOverhead('15');

    expect(saved, isTrue);
    verify(pricing.updateOverhead(1500)).called(1);
    await c.read(pricingSettingsProvider.future);
    verify(pricing.fetchSettings()).called(2);
  });

  test('invalid labor rate does not call the repository', () async {
    final c = container();
    addTearDown(c.dispose);

    final saved = await c
        .read(pricingSettingsControllerProvider.notifier)
        .saveLaborRate('-5');

    expect(saved, isFalse);
    expect(
      c.read(pricingSettingsControllerProvider).laborRateError,
      r'Enter an hourly rate from $0 to $1,000.',
    );
    verifyNever(pricing.updateLaborRate(any));
  });
}
