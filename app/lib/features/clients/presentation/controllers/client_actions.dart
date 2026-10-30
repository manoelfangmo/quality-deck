import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'package:app/core/domain/app_exception.dart';
import 'package:app/features/clients/data/clients_repository.dart';
import 'package:app/features/clients/presentation/controllers/clients_table.dart';
import 'package:app/features/scheduling/presentation/controllers/client_appointment.dart';

part 'client_actions.freezed.dart';
part 'client_actions.g.dart';

@freezed
abstract class ClientActionState with _$ClientActionState {
  const factory ClientActionState({
    @Default(false) bool isRemoving,
    String? errorMessage,
  }) = _ClientActionState;
}

@riverpod
class ClientActionsController extends _$ClientActionsController {
  @override
  ClientActionState build(String clientId) => const ClientActionState();

  Future<bool> remove() async {
    final link = ref.keepAlive();
    state = state.copyWith(isRemoving: true, errorMessage: null);
    try {
      final current = ref.read(allClientsProvider).value ?? [];
      await ref.read(clientsRepositoryProvider).remove(clientId);
      if (!ref.mounted) return true;
      final remaining = current.where((c) => c.id != clientId).length;
      ref
          .read(clientsTableControllerProvider.notifier)
          .stepBackIfPageEmpty(remaining);
      ref.invalidate(allClientsProvider);
      ref.invalidate(clientAppointmentProvider(clientId));
      return true;
    } on AppException catch (error) {
      if (!ref.mounted) return false;
      state = state.copyWith(isRemoving: false, errorMessage: error.message);
      return false;
    } catch (_) {
      if (!ref.mounted) return false;
      state = state.copyWith(
        isRemoving: false,
        errorMessage: 'Something went wrong.',
      );
      return false;
    } finally {
      link.close();
    }
  }
}
