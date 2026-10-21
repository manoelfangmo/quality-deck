import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:timezone/data/latest.dart' as tzdata;

import 'package:app/core/domain/app_exception.dart';
import 'package:app/features/business/presentation/controllers/current_business.dart';
import 'package:app/features/clients/data/clients_repository.dart';
import 'package:app/features/clients/data/models.dart';
import 'package:app/features/clients/presentation/controllers/client_form.dart';
import 'package:app/features/clients/presentation/controllers/clients_table.dart';
import 'package:app/features/scheduling/data/appointments_repository.dart';

import '../../../../helpers/fixtures.dart';
import '../../../../mocks.dart';

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
        currentBusinessProvider.overrideWith((ref) async => qualityDeck),
        allClientsProvider.overrideWith((ref) async => [anaMelgar]),
      ],
    );
  }

  setUp(() {
    clients = MockClientsRepository();
    appointments = MockAppointmentsRepository();
  });

  test('add calls create', () async {
    when(clients.create(any)).thenAnswer((_) async => anaMelgar);

    final c = container();
    addTearDown(c.dispose);
    final notifier = c.read(clientFormControllerProvider().notifier);
    notifier.setFullName('Ana Melgar');
    notifier.setPhone('(301) 555-0123');

    final saved = await notifier.submit();

    expect(saved, isTrue);
    final command =
        verify(clients.create(captureAny)).captured.single as CreateClientCommand;
    expect(command.fullName, 'Ana Melgar');
    expect(command.phone, '(301) 555-0123');
    verifyNever(clients.update(any));
    expect(c.read(clientsTableControllerProvider).pageIndex, 0);
  });

  test('edit calls update with the client id', () async {
    when(clients.update(any)).thenAnswer((_) async => anaMelgar);

    final c = container();
    addTearDown(c.dispose);
    final notifier = c.read(
      clientFormControllerProvider(client: anaMelgar).notifier,
    );
    notifier.setPhone('(301) 555-9999');

    final saved = await notifier.submit();

    expect(saved, isTrue);
    final command =
        verify(clients.update(captureAny)).captured.single as UpdateClientCommand;
    expect(command.id, anaMelgar.id);
    expect(command.phone, '(301) 555-9999');
    verifyNever(clients.create(any));
  });

  test('invalid draft calls neither create nor update', () async {
    final c = container();
    addTearDown(c.dispose);
    final notifier = c.read(clientFormControllerProvider().notifier);
    notifier.setFullName('Ana Melgar');

    final saved = await notifier.submit();

    expect(saved, isFalse);
    expect(
      c.read(clientFormControllerProvider()).phoneError,
      'Add a phone number or an email.',
    );
    verifyNever(clients.create(any));
    verifyNever(clients.update(any));
  });

  test('repository error leaves the sheet open with the message', () async {
    when(
      clients.create(any),
    ).thenThrow(const AppException.clientNotFound());

    final c = container();
    addTearDown(c.dispose);
    final notifier = c.read(clientFormControllerProvider().notifier);
    notifier.setFullName('Ana Melgar');
    notifier.setPhone('3015550123');

    final saved = await notifier.submit();

    expect(saved, isFalse);
    final state = c.read(clientFormControllerProvider());
    expect(state.isSubmitting, isFalse);
    expect(
      state.errorMessage,
      'This client was removed. Refresh to see the latest list.',
    );
  });

  test('appointment add failure keeps the client and switches to edit', () async {
    when(clients.create(any)).thenAnswer((_) async => anaMelgar);
    when(
      appointments.add(any),
    ).thenThrow(const AppException.clientHasAppointment());

    final c = container();
    addTearDown(c.dispose);
    final notifier = c.read(clientFormControllerProvider().notifier);
    notifier.setFullName('Ana Melgar');
    notifier.setPhone('(301) 555-0123');
    notifier.openAppointment();

    final saved = await notifier.submit();

    expect(saved, isFalse);
    final state = c.read(clientFormControllerProvider());
    expect(state.isAdd, isFalse);
    expect(state.clientId, anaMelgar.id);
    expect(state.appointmentOpen, isTrue);
    expect(
      state.errorMessage,
      startsWith("Client saved, but the appointment wasn't added:"),
    );
    expect(state.errorMessage, contains('already has an appointment'));
  });
}
