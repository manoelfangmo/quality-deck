@Tags(<String>['contract'])
library;

import 'package:flutter_test/flutter_test.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'package:app/features/clients/data/clients_repository.dart';
import 'package:app/features/scheduling/data/appointments_repository.dart';
import 'package:app/features/scheduling/data/models.dart';

import 'clean_up.dart';
import 'helpers.dart';

void main() {
  SupabaseClient? supabase;
  late AppointmentsRepository repository;
  late ClientsRepository clients;
  late ContractCleanup cleanup;

  setUpAll(() async {
    supabase = await signInAsSeededOwner();
    repository = AppointmentsRepository(supabase!);
    clients = ClientsRepository(supabase!);
    cleanup = ContractCleanup();
  });

  tearDown(() async {
    await cleanup.teardown();
  });

  tearDownAll(() async {
    await cleanup.dispose();
    await supabase?.auth.signOut();
    await supabase?.dispose();
  });

  group('AppointmentsRepository.fetchForClient', () {
    test('returns the seeded upcoming appointment', () async {
      final appointment = await repository.fetchForClient(
        SeedClients.anaMelgarId,
      );

      expect(appointment, isNotNull);
      expect(appointment!.id, SeedAppointments.anaUpcomingId);
      expect(appointment.clientId, SeedClients.anaMelgarId);
      expect(appointment.durationMinutes, 60);
      expect(appointment.notes, 'Measure back deck');
    });

    test('returns null when the only appointment was removed', () async {
      expect(await repository.fetchForClient(SeedClients.priyaShahId), isNull);
    });
  });

  group('AppointmentsRepository.add', () {
    test('persists an appointment that the next fetch returns', () async {
      final client = await createUniqueClient(clients);
      cleanup.trackClient(client.id);
      final startsAt = DateTime.utc(2027, 6, 1, 13, 0);

      final id = await repository.add(
        AddAppointmentCommand(
          clientId: client.id,
          startsAt: startsAt,
          durationMinutes: 45,
          notes: 'Contract visit',
        ),
      );
      cleanup.trackAppointment(id);

      expect(id, isUuid);
      final fetched = await repository.fetchForClient(client.id);
      expect(fetched, isNotNull);
      expect(fetched!.id, id);
      expect(fetched.clientId, client.id);
      expect(fetched.durationMinutes, 45);
      expect(fetched.notes, 'Contract visit');
      expectSameUtcParts(fetched.startsAt, startsAt);
    });
  });

  group('AppointmentsRepository.update', () {
    test('persists edits that the next fetch returns', () async {
      final client = await createUniqueClient(clients);
      cleanup.trackClient(client.id);
      final id = await repository.add(
        AddAppointmentCommand(
          clientId: client.id,
          startsAt: DateTime.utc(2027, 6, 1, 13, 0),
          durationMinutes: 45,
          notes: 'Before',
        ),
      );
      cleanup.trackAppointment(id);
      final startsAt = DateTime.utc(2027, 6, 2, 15, 30);

      await repository.update(
        UpdateAppointmentCommand(
          id: id,
          startsAt: startsAt,
          durationMinutes: 90,
          notes: 'After',
        ),
      );

      final fetched = await repository.fetchForClient(client.id);
      expect(fetched, isNotNull);
      expect(fetched!.durationMinutes, 90);
      expect(fetched.notes, 'After');
      expectSameUtcParts(fetched.startsAt, startsAt);
    });
  });

  group('AppointmentsRepository.remove', () {
    test('hides the appointment from later fetches', () async {
      final client = await createUniqueClient(clients);
      cleanup.trackClient(client.id);
      final id = await repository.add(
        AddAppointmentCommand(
          clientId: client.id,
          startsAt: DateTime.utc(2027, 6, 3, 10, 0),
          durationMinutes: 30,
        ),
      );
      cleanup.trackAppointment(id);

      await repository.remove(id);

      expect(await repository.fetchForClient(client.id), isNull);
    });
  });
}
