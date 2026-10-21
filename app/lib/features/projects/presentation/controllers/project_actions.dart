import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'package:app/core/domain/app_exception.dart';
import 'package:app/features/projects/data/projects_repository.dart';
import 'package:app/features/projects/presentation/controllers/project.dart';
import 'package:app/features/projects/presentation/controllers/projects_table.dart';

part 'project_actions.freezed.dart';
part 'project_actions.g.dart';

@freezed
abstract class ProjectActionState with _$ProjectActionState {
  const factory ProjectActionState({
    @Default(false) bool inProgress,
    String? errorMessage,
  }) = _ProjectActionState;
}

@riverpod
class ProjectActionsController extends _$ProjectActionsController {
  @override
  ProjectActionState build(String projectId) => const ProjectActionState();

  Future<bool> archive() => _run(archive: true);

  Future<bool> unarchive() => _run(archive: false);

  Future<bool> undoArchive() => unarchive();

  Future<bool> undoUnarchive() => archive();

  Future<bool> _run({required bool archive}) async {
    final link = ref.keepAlive();
    state = state.copyWith(inProgress: true, errorMessage: null);
    try {
      final view = ref.read(projectsTableControllerProvider).view;
      final current = ref.read(projectRowsProvider(view)).value ?? [];
      if (archive) {
        await ref.read(projectsRepositoryProvider).archive(projectId);
      } else {
        await ref.read(projectsRepositoryProvider).unarchive(projectId);
      }
      if (!ref.mounted) return true;
      final remaining = current.where((row) => row.id != projectId).length;
      ref
          .read(projectsTableControllerProvider.notifier)
          .stepBackIfPageEmpty(remaining);
      _invalidate();
      return true;
    } on AppException catch (error) {
      if (!ref.mounted) return false;
      state = state.copyWith(inProgress: false, errorMessage: error.message);
      return false;
    } catch (_) {
      if (!ref.mounted) return false;
      state = state.copyWith(
        inProgress: false,
        errorMessage: 'Something went wrong.',
      );
      return false;
    } finally {
      link.close();
    }
  }

  void _invalidate() {
    ref.invalidate(projectRowsPageProvider);
    ref.invalidate(projectRowsProvider);
    ref.invalidate(projectProvider(projectId));
  }
}
