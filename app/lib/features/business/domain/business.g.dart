// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'business.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_Business _$BusinessFromJson(Map<String, dynamic> json) => _Business(
  id: json['id'] as String,
  name: json['name'] as String,
  ownerId: json['owner_id'] as String,
  timezone: json['timezone'] as String? ?? 'America/New_York',
  defaultOnsiteMinutes: (json['default_onsite_minutes'] as num?)?.toInt() ?? 60,
);

Map<String, dynamic> _$BusinessToJson(_Business instance) => <String, dynamic>{
  'id': instance.id,
  'name': instance.name,
  'owner_id': instance.ownerId,
  'timezone': instance.timezone,
  'default_onsite_minutes': instance.defaultOnsiteMinutes,
};
