import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import 'package:app/features/clients/data/clients_repository.dart';
import 'package:app/features/clients/domain/client.dart';
import 'package:app/features/clients/presentation/controllers/client_actions.dart';
import 'package:app/features/clients/presentation/controllers/clients_table.dart';

import '../../../../helpers/fixtures.dart';
import '../../../../mocks.dart';

void main() {
  late MockClientsRepository clients;

  List<Client> elevenClients() {
    return [
      anaMelgar,
      ...List.generate(10, (i) {
        return jamesWhitaker.copyWith(id: 'client-$i', fullName: 'Client $i');
      }),
    ];
  }

  ProviderContainer containerWith(List<Client> list) {
    return ProviderContainer(
      retry: (count, error) => null,
      overrides: [
        clientsRepositoryProvider.overrideWithValue(clients),
        allClientsProvider.overrideWith((ref) async => list),
      ],
    );
  }

  setUp(() {
    clients = MockClientsRepository();
  });

  test('remove calls repository and invalidates', () async {
    when(clients.remove(anaMelgar.id)).thenAnswer((_) async {});

    final c = containerWith([anaMelgar, jamesWhitaker]);
    addTearDown(c.dispose);
    c.listen(allClientsProvider, (_, _) {});
    await c.read(allClientsProvider.future);

    final removed = await c
        .read(clientActionsControllerProvider(anaMelgar.id).notifier)
        .remove();

    expect(removed, isTrue);
    verify(clients.remove(anaMelgar.id)).called(1);
  });

  test('steps back a page when the page empties', () async {
    when(clients.remove(anaMelgar.id)).thenAnswer((_) async {});

    final c = containerWith(elevenClients());
    addTearDown(c.dispose);
    c.listen(allClientsProvider, (_, _) {});
    await c.read(allClientsProvider.future);
    c.read(clientsTableControllerProvider.notifier).goToPage(1);
    expect(c.read(clientsTableControllerProvider).pageIndex, 1);

    await c.read(clientActionsControllerProvider(anaMelgar.id).notifier).remove();

    expect(c.read(clientsTableControllerProvider).pageIndex, 0);
  });
}
