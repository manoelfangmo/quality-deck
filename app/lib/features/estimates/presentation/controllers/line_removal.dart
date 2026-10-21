import 'dart:async';

import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'package:app/core/domain/app_exception.dart';
import 'package:app/features/estimates/data/line_items_repository.dart';
import 'package:app/features/estimates/presentation/controllers/project_jobs.dart';

part 'line_removal.g.dart';

class LineRemovalState {
  const LineRemovalState({
    this.hiddenIds = const <String>{},
    this.errorMessage,
  });

  final Set<String> hiddenIds;
  final String? errorMessage;

  LineRemovalState copyWith({
    Set<String>? hiddenIds,
    String? errorMessage,
    bool clearError = false,
  }) {
    return LineRemovalState(
      hiddenIds: hiddenIds ?? this.hiddenIds,
      errorMessage: clearError ? null : (errorMessage ?? this.errorMessage),
    );
  }
}

@riverpod
class LineRemovalController extends _$LineRemovalController {
  final _timers = <String, Timer>{};
  final _pending = <String>{};
  LineItemsRepository? _repo;

  @override
  LineRemovalState build(String projectId) {
    ref.onDispose(() {
      for (final id in [..._pending]) {
        _timers.remove(id)?.cancel();
        final repo = _repo;
        if (repo != null) unawaited(repo.delete(id));
      }
    });
    return const LineRemovalState();
  }

  void hide(String lineId) {
    _repo = ref.read(lineItemsRepositoryProvider);
    _timers[lineId]?.cancel();
    _pending.add(lineId);
    _timers[lineId] = Timer(const Duration(seconds: 5), () {
      unawaited(commit(lineId));
    });
    state = state.copyWith(
      hiddenIds: {...state.hiddenIds, lineId},
      clearError: true,
    );
  }

  void undo(String lineId) {
    _timers.remove(lineId)?.cancel();
    _pending.remove(lineId);
    state = state.copyWith(
      hiddenIds: {...state.hiddenIds}..remove(lineId),
      clearError: true,
    );
  }

  Future<void> commit(String lineId) async {
    _timers.remove(lineId)?.cancel();
    if (!_pending.contains(lineId)) return;
    _pending.remove(lineId);
    final repo = _repo;
    if (repo == null) return;
    try {
      await repo.delete(lineId);
      if (!ref.mounted) return;
      state = state.copyWith(
        hiddenIds: {...state.hiddenIds}..remove(lineId),
        clearError: true,
      );
      ref.invalidate(projectJobsProvider(projectId));
    } on AppException catch (error) {
      if (!ref.mounted) return;
      state = state.copyWith(
        hiddenIds: {...state.hiddenIds}..remove(lineId),
        errorMessage: error.message,
      );
    } catch (_) {
      if (!ref.mounted) return;
      state = state.copyWith(
        hiddenIds: {...state.hiddenIds}..remove(lineId),
        errorMessage: 'Something went wrong.',
      );
    }
  }
}
