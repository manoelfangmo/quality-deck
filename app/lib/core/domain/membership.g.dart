// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'membership.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_Membership _$MembershipFromJson(Map<String, dynamic> json) => _Membership(
  businessId: json['business_id'] as String,
  role: $enumDecode(_$UserRoleEnumMap, json['role']),
  joinedAt: const UtcToLocalConverter().fromJson(json['joined_at'] as String),
);

Map<String, dynamic> _$MembershipToJson(_Membership instance) =>
    <String, dynamic>{
      'business_id': instance.businessId,
      'role': _$UserRoleEnumMap[instance.role]!,
      'joined_at': const UtcToLocalConverter().toJson(instance.joinedAt),
    };

const _$UserRoleEnumMap = {UserRole.owner: 'owner', UserRole.member: 'member'};
