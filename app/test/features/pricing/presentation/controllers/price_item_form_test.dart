import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import 'package:app/core/domain/pricing_type.dart';
import 'package:app/features/pricing/data/models.dart';
import 'package:app/features/pricing/data/price_items_repository.dart';
import 'package:app/features/pricing/presentation/controllers/price_item_form.dart';
import 'package:app/features/pricing/presentation/controllers/price_items_table.dart';

import '../../../../helpers/fixtures.dart';
import '../../../../mocks.dart';

void main() {
  late MockPriceItemsRepository items;

  ProviderContainer container() {
    return ProviderContainer(
      retry: (count, error) => null,
      overrides: [
        priceItemsRepositoryProvider.overrideWithValue(items),
        allPriceItemsProvider.overrideWith((ref) async => [aluminumRailing]),
      ],
    );
  }

  setUp(() {
    items = MockPriceItemsRepository();
  });

  test('add calls create', () async {
    when(items.create(any)).thenAnswer((_) async => permitFiling);

    final c = container();
    addTearDown(c.dispose);
    final notifier = c.read(priceItemFormControllerProvider().notifier);
    notifier.setName('Permit filing');
    notifier.setPricingType(PricingType.fixed);
    notifier.setPrice('350');

    final saved = await notifier.submit();

    expect(saved, isTrue);
    final command =
        verify(items.create(captureAny)).captured.single
            as CreatePriceItemCommand;
    expect(command.name, 'Permit filing');
    expect(command.pricingType, PricingType.fixed);
    expect(command.priceCents, 35000);
    verifyNever(items.update(any));
  });

  test('edit calls update with the item id', () async {
    when(items.update(any)).thenAnswer((_) async => aluminumRailing);

    final c = container();
    addTearDown(c.dispose);
    final notifier = c.read(
      priceItemFormControllerProvider(item: aluminumRailing).notifier,
    );
    notifier.setPrice('40');

    final saved = await notifier.submit();

    expect(saved, isTrue);
    final command =
        verify(items.update(captureAny)).captured.single
            as UpdatePriceItemCommand;
    expect(command.id, aluminumRailing.id);
    expect(command.priceCents, 4000);
    verifyNever(items.create(any));
  });

  test('invalid draft calls neither create nor update', () async {
    final c = container();
    addTearDown(c.dispose);
    final notifier = c.read(priceItemFormControllerProvider().notifier);
    notifier.setName('Permit filing');

    final saved = await notifier.submit();

    expect(saved, isFalse);
    expect(
      c.read(priceItemFormControllerProvider()).pricingTypeError,
      'Choose how this item is priced.',
    );
    verifyNever(items.create(any));
    verifyNever(items.update(any));
  });
}
