import 'package:clock/clock.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:timezone/data/latest.dart' as tzdata;

import 'package:app/core/utils/providers.dart';
import 'package:app/features/business/presentation/controllers/current_business.dart';
import 'package:app/features/clients/data/clients_repository.dart';
import 'package:app/features/clients/presentation/controllers/clients_table.dart';
import 'package:app/features/scheduling/data/appointments_repository.dart';
import 'package:app/features/scheduling/presentation/widgets/client_appointment_section.dart';

import '../../../../helpers/fixtures.dart';
import '../../../../mocks.dart';

void main() {
  late MockAppointmentsRepository appointments;

  setUpAll(tzdata.initializeTimeZones);

  setUp(() {
    appointments = MockAppointmentsRepository();
  });

  Future<void> pumpSection(WidgetTester tester) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          appointmentsRepositoryProvider.overrideWithValue(appointments),
          clientsRepositoryProvider.overrideWithValue(MockClientsRepository()),
          allClientsProvider.overrideWith((ref) async => [anaMelgar]),
          currentBusinessProvider.overrideWith((ref) async => qualityDeck),
          clockProvider.overrideWithValue(
            Clock.fixed(DateTime.utc(2026, 10, 20, 12)),
          ),
        ],
        child: MaterialApp(
          home: Scaffold(
            body: ClientAppointmentSection(
              clientId: anaMelgar.id,
              addSection: const Text('+ Add appointment'),
            ),
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();
  }

  testWidgets('shows the tile when the client has an appointment', (
    tester,
  ) async {
    when(
      appointments.fetchForClient(anaMelgar.id),
    ).thenAnswer((_) async => anaUpcomingAppointment);

    await pumpSection(tester);

    expect(find.textContaining('Fri Oct 23'), findsOneWidget);
    expect(find.text('Edit'), findsOneWidget);
    expect(find.text('Remove'), findsOneWidget);
    expect(find.text('+ Add appointment'), findsNothing);
  });

  testWidgets('shows the Add button when there is no appointment', (
    tester,
  ) async {
    when(
      appointments.fetchForClient(anaMelgar.id),
    ).thenAnswer((_) async => null);

    await pumpSection(tester);

    expect(find.text('+ Add appointment'), findsOneWidget);
    expect(find.text('Edit'), findsNothing);
  });

  testWidgets('after Remove it shows the Add button', (tester) async {
    when(
      appointments.fetchForClient(anaMelgar.id),
    ).thenAnswer((_) async => anaUpcomingAppointment);
    when(appointments.remove(any)).thenAnswer((_) async {
      when(
        appointments.fetchForClient(anaMelgar.id),
      ).thenAnswer((_) async => null);
    });

    await pumpSection(tester);
    await tester.tap(find.text('Remove'));
    await tester.pumpAndSettle();
    expect(find.text('Remove this appointment?'), findsOneWidget);
    verifyNever(appointments.remove(any));

    await tester.tap(find.widgetWithText(TextButton, 'Remove').last);
    await tester.pumpAndSettle();

    verify(appointments.remove(anaUpcomingAppointment.id)).called(1);
    expect(find.text('+ Add appointment'), findsOneWidget);
  });
}
