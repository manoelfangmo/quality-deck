import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'package:app/core/domain/app_exception.dart';
import 'package:app/core/domain/business_time.dart';
import 'package:app/features/clients/data/clients_repository.dart';
import 'package:app/features/clients/data/models.dart';
import 'package:app/features/clients/domain/client.dart';
import 'package:app/features/scheduling/data/appointments_repository.dart';
import 'package:app/features/scheduling/data/models.dart';
import 'package:app/features/scheduling/domain/appointment_draft.dart';

part 'client_intake_service.g.dart';

class ClientIntakeResult {
  const ClientIntakeResult({
    required this.client,
    required this.addedAppointment,
    this.appointmentError,
  });

  final Client client;
  final bool addedAppointment;
  final String? appointmentError;

  bool get ok => appointmentError == null;
}

@Riverpod(keepAlive: true)
ClientIntakeService clientIntakeService(Ref ref) {
  return ClientIntakeService(ref);
}

class ClientIntakeService {
  ClientIntakeService(this._ref);

  final Ref _ref;

  Future<ClientIntakeResult> save({
    required bool isAdd,
    CreateClientCommand? create,
    UpdateClientCommand? update,
    AppointmentDraft? draft,
    required String timeZone,
  }) async {
    final clients = _ref.read(clientsRepositoryProvider);
    final client = isAdd
        ? await clients.create(create!)
        : await clients.update(update!);

    if (draft == null) {
      return ClientIntakeResult(client: client, addedAppointment: false);
    }

    try {
      final startsAt = BusinessTime(timeZone).toUtc(
        date: draft.date,
        startHour: draft.startHour,
        startMinute: draft.startMinute,
      );
      await _ref
          .read(appointmentsRepositoryProvider)
          .add(
            AddAppointmentCommand(
              clientId: client.id,
              startsAt: startsAt,
              durationMinutes: draft.durationMinutes,
              notes: draft.notes,
            ),
          );
      return ClientIntakeResult(client: client, addedAppointment: true);
    } on AppException catch (error) {
      return ClientIntakeResult(
        client: client,
        addedAppointment: false,
        appointmentError: error.message,
      );
    } catch (_) {
      return ClientIntakeResult(
        client: client,
        addedAppointment: false,
        appointmentError: 'Something went wrong.',
      );
    }
  }
}
