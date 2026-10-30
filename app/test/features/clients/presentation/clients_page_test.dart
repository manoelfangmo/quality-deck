import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import 'package:app/features/business/presentation/controllers/current_business.dart';
import 'package:app/features/clients/data/clients_repository.dart';
import 'package:app/features/clients/presentation/clients_page.dart';
import 'package:app/features/clients/presentation/controllers/clients_table.dart';
import 'package:app/features/scheduling/data/appointments_repository.dart';

import '../../../helpers/fixtures.dart';
import '../../../mocks.dart';

void main() {
  late MockClientsRepository clients;
  late MockAppointmentsRepository appointments;

  setUp(() {
    clients = MockClientsRepository();
    appointments = MockAppointmentsRepository();
    when(clients.fetchAll()).thenAnswer((_) async => [anaMelgar, jamesWhitaker]);
    when(appointments.fetchForClient(any)).thenAnswer((_) async => null);
  });

  Future<void> pumpPage(WidgetTester tester) async {
    tester.view.physicalSize = const Size(1800, 900);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          clientsRepositoryProvider.overrideWithValue(clients),
          appointmentsRepositoryProvider.overrideWithValue(appointments),
          currentBusinessProvider.overrideWith((ref) async => qualityDeck),
          allClientsProvider.overrideWith(
            (ref) => ref.watch(clientsRepositoryProvider).fetchAll(),
          ),
        ],
        child: const MaterialApp(home: Scaffold(body: ClientsPage())),
      ),
    );
    await tester.pumpAndSettle();
  }

  testWidgets('Add client opens an empty form', (tester) async {
    await pumpPage(tester);

    await tester.tap(find.widgetWithText(FilledButton, 'Add client'));
    await tester.pumpAndSettle();

    expect(find.text('Add client'), findsWidgets);
    final nameField = tester.widget<TextField>(find.byType(TextField).first);
    expect(nameField.controller?.text, isEmpty);
  });

  testWidgets('row Edit opens the form filled in', (tester) async {
    await pumpPage(tester);

    await tester.tap(find.byIcon(Icons.more_horiz).first);
    await tester.pumpAndSettle();
    await tester.tap(find.text('Edit'));
    await tester.pumpAndSettle();

    expect(find.text('Edit client'), findsOneWidget);
    final nameField = tester.widget<TextField>(find.byType(TextField).first);
    expect(nameField.controller?.text, anaMelgar.fullName);
  });

  testWidgets('Remove shows confirmation and only calls the repository after Remove', (
    tester,
  ) async {
    when(clients.remove(any)).thenAnswer((_) async {});
    await pumpPage(tester);

    await tester.tap(find.byIcon(Icons.more_horiz).first);
    await tester.pumpAndSettle();
    await tester.tap(find.text('Remove'));
    await tester.pumpAndSettle();

    expect(find.text('Remove Ana Melgar?'), findsOneWidget);
    verifyNever(clients.remove(any));

    await tester.tap(find.widgetWithText(TextButton, 'Remove'));
    await tester.pumpAndSettle();

    verify(clients.remove(anaMelgar.id)).called(1);
  });
}
