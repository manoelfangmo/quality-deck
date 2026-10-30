import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'package:app/core/database/businesses_table.dart';
import 'package:app/core/database/memberships_table.dart';
import 'package:app/core/database/rpc.dart';
import 'package:app/core/database/users_table.dart';
import 'package:app/core/domain/app_exception.dart';
import 'package:app/core/domain/user_role.dart';
import 'package:app/core/utils/json_converters.dart';
import 'package:app/core/utils/providers.dart';
import 'package:app/features/business/data/models.dart';
import 'package:app/features/business/domain/business.dart';
import 'package:app/features/business/domain/member.dart';

part 'business_repository.g.dart';

@riverpod
BusinessRepository businessRepository(Ref ref) {
  return BusinessRepository(ref.watch(supabaseProvider));
}

class BusinessRepository {
  BusinessRepository(this._supabase);

  final SupabaseClient _supabase;

  Future<Business?> fetchBusiness() async {
    final row = await _supabase
        .from(BusinessesTable.name)
        .select(
          '${BusinessesTable.id}, ${BusinessesTable.businessName}, '
          '${BusinessesTable.ownerId}, ${BusinessesTable.timezone}, '
          '${BusinessesTable.defaultOnsiteMinutes}',
        )
        .maybeSingle();
    if (row == null) return null;
    return Business.fromJson(row);
  }

  Future<List<Member>> fetchMembers() async {
    final rows = await _supabase
        .from(MembershipsTable.name)
        .select(
          '${MembershipsTable.userId}, ${MembershipsTable.role}, '
          '${MembershipsTable.joinedAt}, '
          '${UsersTable.name} (${UsersTable.id}, ${UsersTable.fullName}, '
          '${UsersTable.email})',
        )
        .order(MembershipsTable.joinedAt);
    return rows.map(_memberFromRow).toList();
  }

  Future<String> createBusiness(CreateBusinessCommand command) async {
    try {
      final result = await _supabase.rpc(
        Rpc.createBusiness,
        params: command.toJson(),
      );
      return result as String;
    } catch (error, stackTrace) {
      AppException.throwFrom(error, stackTrace);
    }
  }

  Future<String> redeemInvite(RedeemInviteCommand command) async {
    try {
      final result = await _supabase.rpc(
        Rpc.redeemInvite,
        params: command.toJson(),
      );
      return result as String;
    } catch (error, stackTrace) {
      AppException.throwFrom(error, stackTrace);
    }
  }

  Future<void> removeMember(String userId) async {
    try {
      await _supabase.rpc(Rpc.removeMember, params: {Rpc.pUserId: userId});
    } catch (error, stackTrace) {
      AppException.throwFrom(error, stackTrace);
    }
  }

  Future<void> renameBusiness({
    required String businessId,
    required String name,
  }) async {
    try {
      await _supabase
          .from(BusinessesTable.name)
          .update({BusinessesTable.businessName: name.trim()})
          .eq(BusinessesTable.id, businessId);
    } catch (error, stackTrace) {
      AppException.throwFrom(error, stackTrace);
    }
  }

  Member _memberFromRow(Map<String, dynamic> row) {
    final user = row[UsersTable.name] as Map<String, dynamic>;
    return Member(
      id: user[UsersTable.id] as String,
      fullName: user[UsersTable.fullName] as String,
      email: user[UsersTable.email] as String,
      role: UserRole.fromDb(row[MembershipsTable.role] as String),
      joinedAt: const UtcToLocalConverter().fromJson(
        row[MembershipsTable.joinedAt] as String,
      ),
    );
  }
}
