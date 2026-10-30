import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'package:app/features/pricing/data/models.dart';
import 'package:app/features/pricing/data/price_items_repository.dart';
import 'package:app/features/pricing/domain/price_item.dart';

part 'price_items_table.g.dart';

class PriceItemsTableState {
  const PriceItemsTableState({this.pageIndex = 0, this.pageSize = 10});

  final int pageIndex;
  final int pageSize;

  PriceItemsTableState copyWith({int? pageIndex, int? pageSize}) {
    return PriceItemsTableState(
      pageIndex: pageIndex ?? this.pageIndex,
      pageSize: pageSize ?? this.pageSize,
    );
  }
}

@riverpod
class PriceItemsTableController extends _$PriceItemsTableController {
  @override
  PriceItemsTableState build() => const PriceItemsTableState();

  void resetToFirstPage() {
    state = state.copyWith(pageIndex: 0);
  }

  void goToPage(int index) {
    state = state.copyWith(pageIndex: index);
  }

  void stepBackIfPageEmpty(int remainingCount) {
    if (state.pageIndex == 0) return;
    final start = state.pageIndex * state.pageSize;
    if (remainingCount <= start) {
      state = state.copyWith(pageIndex: state.pageIndex - 1);
    }
  }
}

@riverpod
Future<List<PriceItem>> allPriceItems(Ref ref) {
  return ref.watch(priceItemsRepositoryProvider).fetchAll();
}

@riverpod
Future<PriceItemPage> priceItemsPage(Ref ref, int page) {
  final pageSize = ref.watch(priceItemsTableControllerProvider).pageSize;
  return ref
      .watch(priceItemsRepositoryProvider)
      .fetchPage(page: page, pageSize: pageSize);
}
