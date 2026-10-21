import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'package:app/core/database/rpc.dart';
import 'package:app/core/domain/app_exception.dart';
import 'package:app/core/utils/providers.dart';
import 'package:app/features/estimates/data/models.dart';

part 'line_items_repository.g.dart';

@riverpod
LineItemsRepository lineItemsRepository(Ref ref) {
  return LineItemsRepository(ref.watch(supabaseProvider));
}

class LineItemsRepository {
  LineItemsRepository(this._supabase);

  final SupabaseClient _supabase;

  Future<String> addFromPriceList(AddPriceListLineCommand command) async {
    try {
      final result = await _supabase.rpc(
        Rpc.addPriceListLine,
        params: command.toJson(),
      );
      return result as String;
    } catch (error, stackTrace) {
      AppException.throwFrom(error, stackTrace);
    }
  }

  Future<String> addCustom(AddCustomLineCommand command) async {
    try {
      final result = await _supabase.rpc(
        Rpc.addCustomLine,
        params: command.toJson(),
      );
      return result as String;
    } catch (error, stackTrace) {
      AppException.throwFrom(error, stackTrace);
    }
  }

  Future<void> update(UpdateLineCommand command) async {
    try {
      await _supabase.rpc(Rpc.updateLine, params: command.toJson());
    } catch (error, stackTrace) {
      AppException.throwFrom(error, stackTrace);
    }
  }

  Future<void> reorder(String jobId, List<String> ids) async {
    try {
      await _supabase.rpc(
        Rpc.reorderLines,
        params: {Rpc.pJobId: jobId, Rpc.pIds: ids},
      );
    } catch (error, stackTrace) {
      AppException.throwFrom(error, stackTrace);
    }
  }

  Future<void> delete(String id) async {
    try {
      await _supabase.rpc(Rpc.deleteLine, params: {Rpc.pId: id});
    } catch (error, stackTrace) {
      AppException.throwFrom(error, stackTrace);
    }
  }
}
