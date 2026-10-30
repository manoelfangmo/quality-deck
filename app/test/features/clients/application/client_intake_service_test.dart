import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:timezone/data/latest.dart' as tzdata;

import 'package:app/core/domain/app_exception.dart';
import 'package:app/features/clients/application/client_intake_service.dart';
import 'package:app/features/clients/data/clients_repository.dart';
import 'package:app/features/clients/data/models.dart';
import 'package:app/features/scheduling/data/appointments_repository.dart';
import 'package:app/features/scheduling/data/models.dart';

import '../../../helpers/fixtures.dart';
import '../../../mocks.dart';

void main() {
  late MockClientsRepository clients;
  late MockAppointmentsRepository appointments;

  setUpAll(tzdata.initializeTimeZones);

  ProviderContainer container() {
    return ProviderContainer(
      retry: (count, error) => null,
      overrides: [
        clientsRepositoryProvider.overrideWithValue(clients),
        appointmentsRepositoryProvider.overrideWithValue(appointments),
      ],
    );
  }

  setUp(() {
    clients = MockClientsRepository();
    appointments = MockAppointmentsRepository();
  });

  test('no draft creates the client only', () async {
    when(clients.create(any)).thenAnswer((_) async => anaMelgar);

    final c = container();
    addTearDown(c.dispose);
    final result = await c
        .read(clientIntakeServiceProvider)
        .save(
          isAdd: true,
          create: const CreateClientCommand(
            fullName: 'Ana Melgar',
            phone: '3015550123',
          ),
          timeZone: qualityDeck.timezone,
        );

    expect(result.ok, isTrue);
    expect(result.addedAppointment, isFalse);
    expect(result.client.id, anaMelgar.id);
    verify(clients.create(any)).called(1);
    verifyNever(appointments.add(any));
  });

  test('with draft creates the client then adds with that id', () async {
    when(clients.create(any)).thenAnswer((_) async => anaMelgar);
    when(appointments.add(any)).thenAnswer((_) async => 'appt-1');

    final c = container();
    addTearDown(c.dispose);
    final result = await c
        .read(clientIntakeServiceProvider)
        .save(
          isAdd: true,
          create: const CreateClientCommand(
            fullName: 'Ana Melgar',
            phone: '3015550123',
          ),
          draft: tomorrowNineDraft,
          timeZone: qualityDeck.timezone,
        );

    expect(result.ok, isTrue);
    expect(result.addedAppointment, isTrue);
    final command =
        verify(appointments.add(captureAny)).captured.single
            as AddAppointmentCommand;
    expect(command.clientId, anaMelgar.id);
    expect(command.startsAt, DateTime.utc(2026, 10, 21, 13));
    expect(command.durationMinutes, 60);
    expect(command.notes, 'Measure back deck');
  });

  test('add failure keeps the client and returns the error', () async {
    when(clients.create(any)).thenAnswer((_) async => anaMelgar);
    when(
      appointments.add(any),
    ).thenThrow(const AppException.clientHasAppointment());

    final c = container();
    addTearDown(c.dispose);
    final result = await c
        .read(clientIntakeServiceProvider)
        .save(
          isAdd: true,
          create: const CreateClientCommand(
            fullName: 'Ana Melgar',
            phone: '3015550123',
          ),
          draft: tomorrowNineDraft,
          timeZone: qualityDeck.timezone,
        );

    expect(result.ok, isFalse);
    expect(result.client.id, anaMelgar.id);
    expect(result.addedAppointment, isFalse);
    expect(
      result.appointmentError,
      'This client already has an appointment. Edit or remove it first.',
    );
  });
}
