import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'package:app/core/domain/app_exception.dart';
import 'package:app/features/clients/presentation/controllers/clients_table.dart';
import 'package:app/features/scheduling/data/appointments_repository.dart';
import 'package:app/features/scheduling/data/models.dart';
import 'package:app/features/scheduling/presentation/controllers/client_appointment.dart';

part 'appointment_actions.g.dart';

@riverpod
class AppointmentActionsController extends _$AppointmentActionsController {
  @override
  void build() {}

  Future<bool> update(
    UpdateAppointmentCommand command, {
    required String clientId,
  }) async {
    final link = ref.keepAlive();
    try {
      await ref.read(appointmentsRepositoryProvider).update(command);
      if (!ref.mounted) return true;
      _invalidate(clientId);
      return true;
    } on AppException {
      rethrow;
    } finally {
      link.close();
    }
  }

  Future<bool> remove(
    String appointmentId, {
    required String clientId,
  }) async {
    final link = ref.keepAlive();
    try {
      await ref.read(appointmentsRepositoryProvider).remove(appointmentId);
      if (!ref.mounted) return true;
      _invalidate(clientId);
      return true;
    } on AppException {
      rethrow;
    } finally {
      link.close();
    }
  }

  void _invalidate(String clientId) {
    ref.invalidate(clientAppointmentProvider(clientId));
    ref.invalidate(allClientsProvider);
  }
}
