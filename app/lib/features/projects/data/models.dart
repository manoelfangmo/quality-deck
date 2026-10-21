import 'package:app/core/database/project_rows_view.dart';
import 'package:app/core/database/rpc.dart';
import 'package:app/core/domain/address.dart';
import 'package:app/core/utils/json_converters.dart';

class ProjectPage {
  const ProjectPage({required this.projects, required this.total});

  final List<ProjectRow> projects;
  final int total;
}

class CreateProjectCommand {
  const CreateProjectCommand({
    required this.clientId,
    required this.title,
    required this.siteStreet,
    required this.siteCity,
    required this.siteState,
    required this.siteZip,
  });

  final String clientId;
  final String title;
  final String siteStreet;
  final String siteCity;
  final String siteState;
  final String siteZip;

  Map<String, dynamic> toJson() => {
    Rpc.pClientId: clientId,
    Rpc.pTitle: title.trim(),
    Rpc.pSiteStreet: siteStreet.trim(),
    Rpc.pSiteCity: siteCity.trim(),
    Rpc.pSiteState: siteState.trim().toUpperCase(),
    Rpc.pSiteZip: siteZip.trim(),
  };
}

class ProjectRow {
  const ProjectRow({
    required this.id,
    required this.title,
    required this.createdAt,
    this.archivedAt,
    required this.siteAddress,
    required this.clientId,
    required this.clientName,
    this.clientPhone,
    required this.clientRemoved,
    this.appointmentStartsAt,
    this.appointmentDurationMinutes,
  });

  final String id;
  final String title;
  final DateTime createdAt;
  final DateTime? archivedAt;
  final Address siteAddress;
  final String clientId;
  final String clientName;
  final String? clientPhone;
  final bool clientRemoved;
  final DateTime? appointmentStartsAt;
  final int? appointmentDurationMinutes;

  bool get isArchived => archivedAt != null;

  factory ProjectRow.fromJson(Map<String, dynamic> json) {
    final appointmentStartsAt = json[ProjectRowsView.appointmentStartsAt];
    return ProjectRow(
      id: json[ProjectRowsView.id] as String,
      title: json[ProjectRowsView.title] as String,
      createdAt: const UtcToLocalConverter().fromJson(
        json[ProjectRowsView.createdAt] as String,
      ),
      archivedAt: const UtcToLocalNullableConverter().fromJson(
        json[ProjectRowsView.archivedAt] as String?,
      ),
      siteAddress: Address(
        street: json[ProjectRowsView.siteStreet] as String,
        city: json[ProjectRowsView.siteCity] as String,
        state: json[ProjectRowsView.siteState] as String,
        zip: json[ProjectRowsView.siteZip] as String,
      ),
      clientId: json[ProjectRowsView.clientId] as String,
      clientName: json[ProjectRowsView.clientName] as String,
      clientPhone: json[ProjectRowsView.clientPhone] as String?,
      clientRemoved: json[ProjectRowsView.clientRemoved] as bool,
      appointmentStartsAt: appointmentStartsAt == null
          ? null
          : DateTime.parse(appointmentStartsAt as String).toUtc(),
      appointmentDurationMinutes:
          json[ProjectRowsView.appointmentDurationMinutes] as int?,
    );
  }
}
