import 'package:app/core/database/rpc.dart';

class AddAppointmentCommand {
  const AddAppointmentCommand({
    required this.clientId,
    required this.startsAt,
    required this.durationMinutes,
    this.notes,
  });

  final String clientId;
  final DateTime startsAt;
  final int durationMinutes;
  final String? notes;

  Map<String, dynamic> toJson() => {
    Rpc.pClientId: clientId,
    Rpc.pStartsAt: startsAt.toUtc().toIso8601String(),
    Rpc.pDurationMinutes: durationMinutes,
    Rpc.pNotes: _blankToNull(notes),
  };
}

class UpdateAppointmentCommand {
  const UpdateAppointmentCommand({
    required this.id,
    required this.startsAt,
    required this.durationMinutes,
    this.notes,
  });

  final String id;
  final DateTime startsAt;
  final int durationMinutes;
  final String? notes;

  Map<String, dynamic> toJson() => {
    Rpc.pId: id,
    Rpc.pStartsAt: startsAt.toUtc().toIso8601String(),
    Rpc.pDurationMinutes: durationMinutes,
    Rpc.pNotes: _blankToNull(notes),
  };
}

String? _blankToNull(String? value) {
  final trimmed = value?.trim();
  if (trimmed == null || trimmed.isEmpty) return null;
  return trimmed;
}
