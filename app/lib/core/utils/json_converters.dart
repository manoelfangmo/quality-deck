import 'package:json_annotation/json_annotation.dart';

class UtcToLocalConverter implements JsonConverter<DateTime, String> {
  const UtcToLocalConverter();

  @override
  DateTime fromJson(String json) => DateTime.parse(json).toLocal();

  @override
  String toJson(DateTime object) => object.toUtc().toIso8601String();
}

class UtcToLocalNullableConverter implements JsonConverter<DateTime?, String?> {
  const UtcToLocalNullableConverter();

  @override
  DateTime? fromJson(String? json) {
    if (json == null) return null;
    return DateTime.parse(json).toLocal();
  }

  @override
  String? toJson(DateTime? object) => object?.toUtc().toIso8601String();
}
