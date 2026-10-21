import 'package:freezed_annotation/freezed_annotation.dart';

import 'package:app/core/utils/json_converters.dart';
import 'package:app/features/business/domain/invite_status.dart';

part 'invite.freezed.dart';
part 'invite.g.dart';

@freezed
abstract class Invite with _$Invite {
  const factory Invite({
    required String id,
    required String code,
    required InviteStatus status,
    @UtcToLocalConverter() required DateTime createdAt,
    @UtcToLocalConverter() required DateTime expiresAt,
    String? usedByName,
  }) = _Invite;

  factory Invite.fromJson(Map<String, dynamic> json) => _$InviteFromJson(json);
}
