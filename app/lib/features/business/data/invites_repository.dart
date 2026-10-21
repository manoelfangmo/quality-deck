import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'package:app/core/database/invites_table.dart';
import 'package:app/core/database/rpc.dart';
import 'package:app/core/domain/app_exception.dart';
import 'package:app/core/utils/providers.dart';
import 'package:app/features/business/domain/invite.dart';

part 'invites_repository.g.dart';

@riverpod
InvitesRepository invitesRepository(Ref ref) {
  return InvitesRepository(ref.watch(supabaseProvider));
}

class InvitesRepository {
  InvitesRepository(this._supabase);

  final SupabaseClient _supabase;

  Future<List<Invite>> fetchInvites() async {
    final rows = await _supabase
        .from(InviteListView.name)
        .select()
        .order(InviteListView.createdAt, ascending: false);
    return rows.map(Invite.fromJson).toList();
  }

  Future<Invite> createInvite() async {
    try {
      final result = await _supabase.rpc(Rpc.createInvite);
      return Invite.fromJson(Map<String, dynamic>.from(result as Map));
    } catch (error, stackTrace) {
      AppException.throwFrom(error, stackTrace);
    }
  }

  Future<void> revokeInvite(String inviteId) async {
    try {
      await _supabase.rpc(
        Rpc.revokeInvite,
        params: {Rpc.pInviteId: inviteId},
      );
    } catch (error, stackTrace) {
      AppException.throwFrom(error, stackTrace);
    }
  }
}
