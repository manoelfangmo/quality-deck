import 'package:flutter/foundation.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'package:app/core/database/pricing_settings_table.dart';
import 'package:app/core/database/users_table.dart';
import 'package:app/core/domain/app_exception.dart';
import 'package:app/core/utils/providers.dart';
import 'package:app/features/pricing/domain/pricing_settings.dart';

part 'pricing_repository.g.dart';

@riverpod
PricingRepository pricingRepository(Ref ref) {
  return PricingRepository(ref.watch(supabaseProvider));
}

class PricingRepository {
  PricingRepository(this._supabase);

  final SupabaseClient _supabase;

  static const _settingsSelect =
      '${PricingSettingsTable.laborRateCents}, '
      '${PricingSettingsTable.overheadBps}, '
      '${PricingSettingsTable.updatedAt}, '
      '${UsersTable.name}!${PricingSettingsTable.updatedBy} '
      '(${UsersTable.fullName})';

  Future<PricingSettings?> fetchSettings() async {
    final row = await _supabase
        .from(PricingSettingsTable.name)
        .select(_settingsSelect)
        .maybeSingle();
    if (row == null) return null;
    return PricingSettings.fromJson(row);
  }

  Future<void> updateLaborRate(int cents) async {
    try {
      await _supabase.from(PricingSettingsTable.name).update({
        PricingSettingsTable.laborRateCents: cents,
      });
    } catch (error, stackTrace) {
      debugPrint('error: $error');
      AppException.throwFrom(error, stackTrace);
    }
  }

  Future<void> updateOverhead(int basisPoints) async {
    try {
      await _supabase.from(PricingSettingsTable.name).update({
        PricingSettingsTable.overheadBps: basisPoints,
      });
    } catch (error, stackTrace) {
      AppException.throwFrom(error, stackTrace);
    }
  }
}
