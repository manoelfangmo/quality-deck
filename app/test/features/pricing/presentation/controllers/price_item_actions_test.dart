import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import 'package:app/core/domain/app_exception.dart';
import 'package:app/features/pricing/data/price_items_repository.dart';
import 'package:app/features/pricing/domain/price_item.dart';
import 'package:app/features/pricing/presentation/controllers/price_item_actions.dart';
import 'package:app/features/pricing/presentation/controllers/price_items_table.dart';

import '../../../../helpers/fixtures.dart';
import '../../../../mocks.dart';

void main() {
  late MockPriceItemsRepository items;

  List<PriceItem> elevenItems() {
    return [
      aluminumRailing,
      ...List.generate(10, (i) {
        return permitFiling.copyWith(id: 'item-$i', name: 'Item $i');
      }),
    ];
  }

  ProviderContainer containerWith(List<PriceItem> list) {
    return ProviderContainer(
      retry: (count, error) => null,
      overrides: [
        priceItemsRepositoryProvider.overrideWithValue(items),
        allPriceItemsProvider.overrideWith((ref) async => list),
      ],
    );
  }

  setUp(() {
    items = MockPriceItemsRepository();
  });

  test('delete calls the repository and invalidates', () async {
    when(items.delete(aluminumRailing.id)).thenAnswer((_) async {});

    final c = containerWith([aluminumRailing, permitFiling]);
    addTearDown(c.dispose);
    c.listen(allPriceItemsProvider, (_, _) {});
    await c.read(allPriceItemsProvider.future);

    final deleted = await c
        .read(priceItemActionsControllerProvider(aluminumRailing.id).notifier)
        .delete();

    expect(deleted, isTrue);
    verify(items.delete(aluminumRailing.id)).called(1);
  });

  test('steps back a page when the page empties', () async {
    when(items.delete(aluminumRailing.id)).thenAnswer((_) async {});

    final c = containerWith(elevenItems());
    addTearDown(c.dispose);
    c.listen(allPriceItemsProvider, (_, _) {});
    await c.read(allPriceItemsProvider.future);
    c.read(priceItemsTableControllerProvider.notifier).goToPage(1);
    expect(c.read(priceItemsTableControllerProvider).pageIndex, 1);

    await c
        .read(priceItemActionsControllerProvider(aluminumRailing.id).notifier)
        .delete();

    expect(c.read(priceItemsTableControllerProvider).pageIndex, 0);
  });

  test('a no-row result surfaces priceItemNotFound', () async {
    when(
      items.delete(aluminumRailing.id),
    ).thenThrow(const AppException.priceItemNotFound());

    final c = containerWith([aluminumRailing]);
    addTearDown(c.dispose);
    c.listen(allPriceItemsProvider, (_, _) {});
    await c.read(allPriceItemsProvider.future);

    final deleted = await c
        .read(priceItemActionsControllerProvider(aluminumRailing.id).notifier)
        .delete();

    expect(deleted, isFalse);
    expect(
      c.read(priceItemActionsControllerProvider(aluminumRailing.id)).errorMessage,
      'This item was deleted. Refresh to see the latest list.',
    );
  });
}
