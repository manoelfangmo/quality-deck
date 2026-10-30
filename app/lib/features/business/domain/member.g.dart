// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'member.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_Member _$MemberFromJson(Map<String, dynamic> json) => _Member(
  id: json['id'] as String,
  fullName: json['full_name'] as String,
  email: json['email'] as String,
  role: $enumDecode(_$UserRoleEnumMap, json['role']),
  joinedAt: const UtcToLocalConverter().fromJson(json['joined_at'] as String),
);

Map<String, dynamic> _$MemberToJson(_Member instance) => <String, dynamic>{
  'id': instance.id,
  'full_name': instance.fullName,
  'email': instance.email,
  'role': _$UserRoleEnumMap[instance.role]!,
  'joined_at': const UtcToLocalConverter().toJson(instance.joinedAt),
};

const _$UserRoleEnumMap = {UserRole.owner: 'owner', UserRole.member: 'member'};
