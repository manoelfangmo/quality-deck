import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'package:app/core/domain/app_exception.dart';
import 'package:app/features/estimates/data/line_items_repository.dart';
import 'package:app/features/estimates/presentation/controllers/project_jobs.dart';

part 'line_reorder.g.dart';

class LineReorderState {
  const LineReorderState({
    this.ids,
    this.inFlight = false,
    this.errorMessage,
  });

  final List<String>? ids;
  final bool inFlight;
  final String? errorMessage;
}

@riverpod
class LineReorderController extends _$LineReorderController {
  @override
  LineReorderState build({required String projectId, required String jobId}) {
    return const LineReorderState();
  }

  Future<void> reorder({
    required List<String> fullIds,
    required Set<String> hiddenIds,
    required int oldIndex,
    required int newIndex,
  }) async {
    if (state.inFlight) return;

    final nextIds = _mergedIds(
      fullIds: fullIds,
      hiddenIds: hiddenIds,
      oldIndex: oldIndex,
      newIndex: newIndex,
    );
    state = LineReorderState(ids: nextIds, inFlight: true);

    try {
      await ref.read(lineItemsRepositoryProvider).reorder(jobId, nextIds);
      if (!ref.mounted) return;
      ref.invalidate(projectJobsProvider(projectId));
      state = const LineReorderState();
    } on AppException catch (error) {
      if (!ref.mounted) return;
      state = LineReorderState(errorMessage: error.message);
    } catch (_) {
      if (!ref.mounted) return;
      state = const LineReorderState(
        errorMessage: "Couldn't save the new order. Try again.",
      );
    }
  }
}

List<String> _mergedIds({
  required List<String> fullIds,
  required Set<String> hiddenIds,
  required int oldIndex,
  required int newIndex,
}) {
  final visible = fullIds.where((id) => !hiddenIds.contains(id)).toList();
  final item = visible.removeAt(oldIndex);
  visible.insert(newIndex, item);
  var i = 0;
  return [
    for (final id in fullIds)
      if (hiddenIds.contains(id)) id else visible[i++],
  ];
}
