import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'package:app/core/database/price_items_table.dart';
import 'package:app/core/domain/app_exception.dart';
import 'package:app/core/utils/providers.dart';
import 'package:app/features/pricing/data/models.dart';
import 'package:app/features/pricing/domain/price_item.dart';

part 'price_items_repository.g.dart';

@riverpod
PriceItemsRepository priceItemsRepository(Ref ref) {
  return PriceItemsRepository(ref.watch(supabaseProvider));
}

class PriceItemsRepository {
  PriceItemsRepository(this._supabase);

  final SupabaseClient _supabase;

  /// Fetches every item. The paginated table pages in memory — a price list
  /// is a few hundred rows at most, and the table has no page-fetch callback.
  Future<List<PriceItem>> fetchAll() async {
    final rows = await _supabase.from(PriceItemsTable.name).select();
    return _sorted(rows.map(PriceItem.fromJson));
  }

  Future<PriceItemPage> fetchPage({
    required int page,
    required int pageSize,
  }) async {
    final all = await fetchAll();
    final from = page * pageSize;
    if (from >= all.length) {
      return PriceItemPage(items: const [], total: all.length);
    }
    final to = from + pageSize > all.length ? all.length : from + pageSize;
    return PriceItemPage(items: all.sublist(from, to), total: all.length);
  }

  Future<PriceItem> create(CreatePriceItemCommand command) async {
    try {
      final row = await _supabase
          .from(PriceItemsTable.name)
          .insert(command.toJson())
          .select()
          .single();
      return PriceItem.fromJson(row);
    } catch (error, stackTrace) {
      AppException.throwFrom(error, stackTrace);
    }
  }

  Future<PriceItem> update(UpdatePriceItemCommand command) async {
    try {
      final row = await _supabase
          .from(PriceItemsTable.name)
          .update(command.toJson())
          .eq(PriceItemsTable.id, command.id)
          .select()
          .maybeSingle();
      if (row == null) {
        throw const AppException.priceItemNotFound();
      }
      return PriceItem.fromJson(row);
    } catch (error, stackTrace) {
      AppException.throwFrom(error, stackTrace);
    }
  }

  Future<void> delete(String id) async {
    try {
      final row = await _supabase
          .from(PriceItemsTable.name)
          .delete()
          .eq(PriceItemsTable.id, id)
          .select()
          .maybeSingle();
      if (row == null) {
        throw const AppException.priceItemNotFound();
      }
    } catch (error, stackTrace) {
      AppException.throwFrom(error, stackTrace);
    }
  }

  List<PriceItem> _sorted(Iterable<PriceItem> items) {
    return items.toList()..sort((a, b) {
      final byName = a.name.toLowerCase().compareTo(b.name.toLowerCase());
      if (byName != 0) return byName;
      return a.id.compareTo(b.id);
    });
  }
}
