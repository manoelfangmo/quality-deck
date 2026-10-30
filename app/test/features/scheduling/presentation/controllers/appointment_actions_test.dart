import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import 'package:app/features/clients/data/clients_repository.dart';
import 'package:app/features/clients/presentation/controllers/clients_table.dart';
import 'package:app/features/scheduling/data/appointments_repository.dart';
import 'package:app/features/scheduling/data/models.dart';
import 'package:app/features/scheduling/presentation/controllers/appointment_actions.dart';
import 'package:app/features/scheduling/presentation/controllers/client_appointment.dart';

import '../../../../helpers/fixtures.dart';
import '../../../../mocks.dart';

void main() {
  late MockAppointmentsRepository appointments;
  late MockClientsRepository clients;
  var tableLoads = 0;

  ProviderContainer container() {
    tableLoads = 0;
    return ProviderContainer(
      retry: (count, error) => null,
      overrides: [
        appointmentsRepositoryProvider.overrideWithValue(appointments),
        clientsRepositoryProvider.overrideWithValue(clients),
        allClientsProvider.overrideWith((ref) async {
          tableLoads++;
          return [anaMelgar];
        }),
      ],
    );
  }

  setUp(() {
    appointments = MockAppointmentsRepository();
    clients = MockClientsRepository();
    when(
      appointments.fetchForClient(anaMelgar.id),
    ).thenAnswer((_) async => anaUpcomingAppointment);
    when(clients.fetchAll()).thenAnswer((_) async => [anaMelgar]);
  });

  test('update calls the repository and invalidates appointment and table', () async {
    when(appointments.update(any)).thenAnswer((_) async {});

    final c = container();
    addTearDown(c.dispose);
    c.listen(clientAppointmentProvider(anaMelgar.id), (_, _) {});
    c.listen(allClientsProvider, (_, _) {});
    await c.read(clientAppointmentProvider(anaMelgar.id).future);
    await c.read(allClientsProvider.future);

    final updated = await c
        .read(appointmentActionsControllerProvider.notifier)
        .update(
          UpdateAppointmentCommand(
            id: anaUpcomingAppointment.id,
            startsAt: DateTime.utc(2026, 10, 23, 15),
            durationMinutes: 60,
          ),
          clientId: anaMelgar.id,
        );
    await c.read(clientAppointmentProvider(anaMelgar.id).future);
    await c.read(allClientsProvider.future);

    expect(updated, isTrue);
    verify(appointments.update(any)).called(1);
    verify(appointments.fetchForClient(anaMelgar.id)).called(greaterThan(1));
    expect(tableLoads, greaterThan(1));
  });

  test('remove calls the repository and invalidates appointment and table', () async {
    when(appointments.remove(any)).thenAnswer((_) async {});

    final c = container();
    addTearDown(c.dispose);
    c.listen(clientAppointmentProvider(anaMelgar.id), (_, _) {});
    c.listen(allClientsProvider, (_, _) {});
    await c.read(clientAppointmentProvider(anaMelgar.id).future);
    await c.read(allClientsProvider.future);

    final removed = await c
        .read(appointmentActionsControllerProvider.notifier)
        .remove(anaUpcomingAppointment.id, clientId: anaMelgar.id);
    await c.read(allClientsProvider.future);

    expect(removed, isTrue);
    verify(appointments.remove(anaUpcomingAppointment.id)).called(1);
    expect(tableLoads, greaterThan(1));
  });
}
