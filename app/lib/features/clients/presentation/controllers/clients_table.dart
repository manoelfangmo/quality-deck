import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'package:app/features/clients/data/clients_repository.dart';
import 'package:app/features/clients/domain/client.dart';

part 'clients_table.g.dart';

class ClientsTableState {
  const ClientsTableState({this.pageIndex = 0, this.pageSize = 10});

  final int pageIndex;
  final int pageSize;

  ClientsTableState copyWith({int? pageIndex, int? pageSize}) {
    return ClientsTableState(
      pageIndex: pageIndex ?? this.pageIndex,
      pageSize: pageSize ?? this.pageSize,
    );
  }
}

@riverpod
class ClientsTableController extends _$ClientsTableController {
  @override
  ClientsTableState build() => const ClientsTableState();

  void resetToFirstPage() {
    state = state.copyWith(pageIndex: 0);
  }

  void goToPage(int index) {
    state = state.copyWith(pageIndex: index);
  }

  void stepBackIfPageEmpty(int remainingCount) {
    if (state.pageIndex == 0) return;
    final start = state.pageIndex * state.pageSize;
    if (remainingCount <= start) {
      state = state.copyWith(pageIndex: state.pageIndex - 1);
    }
  }
}

@riverpod
Future<List<Client>> allClients(Ref ref) {
  return ref.watch(clientsRepositoryProvider).fetchAll();
}
