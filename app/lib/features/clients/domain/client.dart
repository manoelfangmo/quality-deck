import 'package:freezed_annotation/freezed_annotation.dart';

import 'package:app/core/database/client_rows_view.dart';
import 'package:app/core/database/clients_table.dart';
import 'package:app/core/domain/address.dart';
import 'package:app/core/utils/json_converters.dart';

part 'client.freezed.dart';

@freezed
abstract class Client with _$Client {
  const Client._();

  const factory Client({
    required String id,
    required String fullName,
    String? email,
    String? phone,
    Address? address,
    required DateTime lastActivityAt,
    required DateTime createdAt,
    String? appointmentId,
    DateTime? appointmentStartsAt,
    int? appointmentDurationMinutes,
  }) = _Client;

  factory Client.fromJson(Map<String, dynamic> json) {
    final appointmentStartsAt = json[ClientRowsView.appointmentStartsAt];
    return Client(
      id: json[ClientsTable.id] as String,
      fullName: json[ClientsTable.fullName] as String,
      email: json[ClientsTable.email] as String?,
      phone: json[ClientsTable.phone] as String?,
      address: Address.maybeFromRow(json),
      lastActivityAt: const UtcToLocalConverter().fromJson(
        json[ClientsTable.lastActivityAt] as String,
      ),
      createdAt: const UtcToLocalConverter().fromJson(
        json[ClientsTable.createdAt] as String,
      ),
      appointmentId: json[ClientRowsView.appointmentId] as String?,
      appointmentStartsAt: appointmentStartsAt == null
          ? null
          : DateTime.parse(appointmentStartsAt as String).toUtc(),
      appointmentDurationMinutes:
          json[ClientRowsView.appointmentDurationMinutes] as int?,
    );
  }

  bool get hasAppointment => appointmentId != null;
}
