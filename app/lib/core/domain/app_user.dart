import 'package:freezed_annotation/freezed_annotation.dart';

import 'package:app/core/database/memberships_table.dart';
import 'package:app/core/domain/membership.dart';
import 'package:app/core/domain/user_role.dart';

part 'app_user.freezed.dart';
part 'app_user.g.dart';

@freezed
abstract class AppUser with _$AppUser {
  const AppUser._();

  const factory AppUser({
    required String id,
    required String email,
    required String fullName,
    Membership? membership,
  }) = _AppUser;

  factory AppUser.fromJson(Map<String, dynamic> json) =>
      _$AppUserFromJson(_normalize(json));

  bool get hasBusiness => membership != null;

  bool get isOwner => membership?.role == UserRole.owner;

  static Map<String, dynamic> _normalize(Map<String, dynamic> json) {
    final copy = Map<String, dynamic>.from(json);
    final raw = copy['membership'] ?? copy[MembershipsTable.name];
    if (raw is List) {
      copy['membership'] = raw.isEmpty ? null : raw.first;
    } else {
      copy['membership'] = raw;
    }
    return copy;
  }
}
