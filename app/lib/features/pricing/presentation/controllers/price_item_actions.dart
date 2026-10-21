import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'package:app/core/domain/app_exception.dart';
import 'package:app/features/pricing/data/price_items_repository.dart';
import 'package:app/features/pricing/presentation/controllers/price_items_table.dart';

part 'price_item_actions.g.dart';

class PriceItemActionState {
  const PriceItemActionState({this.isDeleting = false, this.errorMessage});

  final bool isDeleting;
  final String? errorMessage;

  PriceItemActionState copyWith({bool? isDeleting, String? errorMessage}) {
    return PriceItemActionState(
      isDeleting: isDeleting ?? this.isDeleting,
      errorMessage: errorMessage,
    );
  }
}

@riverpod
class PriceItemActionsController extends _$PriceItemActionsController {
  @override
  PriceItemActionState build(String itemId) => const PriceItemActionState();

  Future<bool> delete() async {
    final link = ref.keepAlive();
    state = state.copyWith(isDeleting: true, errorMessage: null);
    try {
      final current = ref.read(allPriceItemsProvider).value ?? [];
      await ref.read(priceItemsRepositoryProvider).delete(itemId);
      if (!ref.mounted) return true;
      final remaining = current.where((item) => item.id != itemId).length;
      ref
          .read(priceItemsTableControllerProvider.notifier)
          .stepBackIfPageEmpty(remaining);
      ref.invalidate(allPriceItemsProvider);
      return true;
    } on AppException catch (error) {
      if (!ref.mounted) return false;
      state = state.copyWith(isDeleting: false, errorMessage: error.message);
      return false;
    } catch (_) {
      if (!ref.mounted) return false;
      state = state.copyWith(
        isDeleting: false,
        errorMessage: 'Something went wrong.',
      );
      return false;
    } finally {
      link.close();
    }
  }
}
