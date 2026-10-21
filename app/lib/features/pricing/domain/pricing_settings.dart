import 'package:freezed_annotation/freezed_annotation.dart';

import 'package:app/core/database/pricing_settings_table.dart';
import 'package:app/core/database/users_table.dart';
import 'package:app/core/domain/money.dart';
import 'package:app/core/domain/percent.dart';
import 'package:app/core/utils/json_converters.dart';

part 'pricing_settings.freezed.dart';

@freezed
abstract class PricingSettings with _$PricingSettings {
  const factory PricingSettings({
    Money? laborRate,
    Percent? overhead,
    required DateTime updatedAt,
    String? updatedByName,
  }) = _PricingSettings;

  factory PricingSettings.fromJson(Map<String, dynamic> json) {
    final user = json[UsersTable.name];
    return PricingSettings(
      laborRate: _money(json[PricingSettingsTable.laborRateCents]),
      overhead: _percent(json[PricingSettingsTable.overheadBps]),
      updatedAt: const UtcToLocalConverter().fromJson(
        json[PricingSettingsTable.updatedAt] as String,
      ),
      updatedByName: user is Map<String, dynamic>
          ? user[UsersTable.fullName] as String?
          : null,
    );
  }

  static Money? _money(Object? value) {
    if (value == null) return null;
    return Money(value as int);
  }

  static Percent? _percent(Object? value) {
    if (value == null) return null;
    return Percent(value as int);
  }
}
