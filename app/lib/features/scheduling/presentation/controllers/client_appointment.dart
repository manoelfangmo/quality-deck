import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'package:app/features/scheduling/data/appointments_repository.dart';
import 'package:app/features/scheduling/domain/appointment.dart';

part 'client_appointment.g.dart';

@riverpod
Future<Appointment?> clientAppointment(Ref ref, String clientId) {
  return ref.watch(appointmentsRepositoryProvider).fetchForClient(clientId);
}
