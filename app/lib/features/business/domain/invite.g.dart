// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'invite.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_Invite _$InviteFromJson(Map<String, dynamic> json) => _Invite(
  id: json['id'] as String,
  code: json['code'] as String,
  status: $enumDecode(_$InviteStatusEnumMap, json['status']),
  createdAt: const UtcToLocalConverter().fromJson(json['created_at'] as String),
  expiresAt: const UtcToLocalConverter().fromJson(json['expires_at'] as String),
  usedByName: json['used_by_name'] as String?,
);

Map<String, dynamic> _$InviteToJson(_Invite instance) => <String, dynamic>{
  'id': instance.id,
  'code': instance.code,
  'status': _$InviteStatusEnumMap[instance.status]!,
  'created_at': const UtcToLocalConverter().toJson(instance.createdAt),
  'expires_at': const UtcToLocalConverter().toJson(instance.expiresAt),
  'used_by_name': instance.usedByName,
};

const _$InviteStatusEnumMap = {
  InviteStatus.active: 'active',
  InviteStatus.used: 'used',
  InviteStatus.expired: 'expired',
  InviteStatus.revoked: 'revoked',
};
