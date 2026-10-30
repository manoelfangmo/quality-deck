import 'package:freezed_annotation/freezed_annotation.dart';

import 'package:app/core/database/appointments_table.dart';

part 'appointment.freezed.dart';

@freezed
abstract class Appointment with _$Appointment {
  const Appointment._();

  const factory Appointment({
    required String id,
    required String clientId,
    required DateTime startsAt,
    required int durationMinutes,
    String? notes,
  }) = _Appointment;

  factory Appointment.fromJson(Map<String, dynamic> json) {
    return Appointment(
      id: json[AppointmentsTable.id] as String,
      clientId: json[AppointmentsTable.clientId] as String,
      startsAt: DateTime.parse(
        json[AppointmentsTable.startsAt] as String,
      ).toUtc(),
      durationMinutes: json[AppointmentsTable.durationMinutes] as int,
      notes: json[AppointmentsTable.notes] as String?,
    );
  }

  DateTime get end => startsAt.add(Duration(minutes: durationMinutes));

  bool isPast(DateTime now) => startsAt.isBefore(now.toUtc());

  String? get notesPreview {
    final value = notes?.trim();
    if (value == null || value.isEmpty) return null;
    return value.split('\n').first;
  }
}
