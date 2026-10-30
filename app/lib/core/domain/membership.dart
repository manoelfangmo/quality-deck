import 'package:freezed_annotation/freezed_annotation.dart';

import 'package:app/core/domain/user_role.dart';
import 'package:app/core/utils/json_converters.dart';

part 'membership.freezed.dart';
part 'membership.g.dart';

@freezed
abstract class Membership with _$Membership {
  const factory Membership({
    required String businessId,
    required UserRole role,
    @UtcToLocalConverter() required DateTime joinedAt,
  }) = _Membership;

  factory Membership.fromJson(Map<String, dynamic> json) =>
      _$MembershipFromJson(json);
}
