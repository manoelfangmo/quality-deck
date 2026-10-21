import 'package:freezed_annotation/freezed_annotation.dart';

import 'package:app/core/database/projects_table.dart';
import 'package:app/core/domain/address.dart';
import 'package:app/core/utils/json_converters.dart';

part 'project.freezed.dart';

@freezed
abstract class Project with _$Project {
  const Project._();

  const factory Project({
    required String id,
    required String clientId,
    required String title,
    required Address siteAddress,
    DateTime? archivedAt,
    required DateTime createdAt,
  }) = _Project;

  factory Project.fromJson(Map<String, dynamic> json) {
    return Project(
      id: json[ProjectsTable.id] as String,
      clientId: json[ProjectsTable.clientId] as String,
      title: json[ProjectsTable.title] as String,
      siteAddress: Address(
        street: json[ProjectsTable.siteStreet] as String,
        city: json[ProjectsTable.siteCity] as String,
        state: json[ProjectsTable.siteState] as String,
        zip: json[ProjectsTable.siteZip] as String,
      ),
      archivedAt: const UtcToLocalNullableConverter().fromJson(
        json[ProjectsTable.archivedAt] as String?,
      ),
      createdAt: const UtcToLocalConverter().fromJson(
        json[ProjectsTable.createdAt] as String,
      ),
    );
  }

  bool get isArchived => archivedAt != null;
}
