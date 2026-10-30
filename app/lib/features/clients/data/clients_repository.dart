import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'package:app/core/database/client_rows_view.dart';
import 'package:app/core/database/clients_table.dart';
import 'package:app/core/database/rpc.dart';
import 'package:app/core/domain/app_exception.dart';
import 'package:app/core/utils/providers.dart';
import 'package:app/features/clients/data/models.dart';
import 'package:app/features/clients/domain/client.dart';

part 'clients_repository.g.dart';

@riverpod
ClientsRepository clientsRepository(Ref ref) {
  return ClientsRepository(ref.watch(supabaseProvider));
}

class ClientsRepository {
  ClientsRepository(this._supabase);

  final SupabaseClient _supabase;

  Future<ClientPage> fetchPage({
    required int page,
    required int pageSize,
  }) async {
    final from = page * pageSize;
    final res = await _supabase
        .from(ClientRowsView.name)
        .select()
        .order(ClientsTable.lastActivityAt, ascending: false)
        .order(ClientsTable.id)
        .range(from, from + pageSize - 1)
        .count(CountOption.exact);
    return ClientPage(
      clients: res.data.map(Client.fromJson).toList(),
      total: res.count,
    );
  }

  Future<List<Client>> fetchAll() async {
    final rows = await _supabase
        .from(ClientRowsView.name)
        .select()
        .order(ClientsTable.lastActivityAt, ascending: false)
        .order(ClientsTable.id);
    return rows.map(Client.fromJson).toList();
  }

  /// Active clients matching [query] on name or phone, ordered by name.
  Future<List<Client>> search(String query, {int limit = 20}) async {
    final trimmed = query.trim();
    var q = _supabase.from(ClientRowsView.name).select();
    if (trimmed.isNotEmpty) {
      final pattern = '%$trimmed%';
      final digits = trimmed.replaceAll(RegExp(r'\D'), '');
      if (digits.isNotEmpty) {
        q = q.or(
          '${ClientsTable.fullName}.ilike.$pattern,'
          '${ClientsTable.phone}.ilike.%$digits%',
        );
      } else {
        q = q.ilike(ClientsTable.fullName, pattern);
      }
    }
    final rows = await q.order(ClientsTable.fullName).limit(limit);
    return rows.map(Client.fromJson).toList();
  }

  Future<Client> create(CreateClientCommand command) async {
    try {
      final row = await _supabase
          .from(ClientsTable.name)
          .insert(command.toJson())
          .select()
          .single();
      return Client.fromJson(row);
    } catch (error, stackTrace) {
      AppException.throwFrom(error, stackTrace);
    }
  }

  Future<Client> update(UpdateClientCommand command) async {
    try {
      final row = await _supabase
          .from(ClientsTable.name)
          .update(command.toJson())
          .eq(ClientsTable.id, command.id)
          .select()
          .maybeSingle();
      if (row == null) {
        throw const AppException.clientNotFound();
      }
      return Client.fromJson(row);
    } catch (error, stackTrace) {
      AppException.throwFrom(error, stackTrace);
    }
  }

  Future<void> remove(String clientId) async {
    try {
      await _supabase.rpc(Rpc.removeClient, params: {Rpc.pClientId: clientId});
    } catch (error, stackTrace) {
      AppException.throwFrom(error, stackTrace);
    }
  }
}
