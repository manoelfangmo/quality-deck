import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'package:app/features/projects/data/models.dart';
import 'package:app/features/projects/data/projects_repository.dart';
import 'package:app/features/projects/domain/project_view.dart';

part 'projects_table.g.dart';

class ProjectsTableState {
  const ProjectsTableState({
    this.view = ProjectView.active,
    this.pageIndex = 0,
    this.pageSize = 10,
  });

  final ProjectView view;
  final int pageIndex;
  final int pageSize;

  ProjectsTableState copyWith({
    ProjectView? view,
    int? pageIndex,
    int? pageSize,
  }) {
    return ProjectsTableState(
      view: view ?? this.view,
      pageIndex: pageIndex ?? this.pageIndex,
      pageSize: pageSize ?? this.pageSize,
    );
  }
}

@Riverpod(keepAlive: true)
class ProjectsTableController extends _$ProjectsTableController {
  @override
  ProjectsTableState build() => const ProjectsTableState();

  void setView(ProjectView view) {
    if (state.view == view) return;
    state = state.copyWith(view: view, pageIndex: 0);
  }

  void showActive() {
    state = state.copyWith(view: ProjectView.active, pageIndex: 0);
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

typedef ProjectRowsPageArgs = ({ProjectView view, int page});

@riverpod
Future<ProjectPage> projectRowsPage(Ref ref, ProjectRowsPageArgs args) {
  final pageSize = ref.watch(projectsTableControllerProvider).pageSize;
  return ref
      .watch(projectsRepositoryProvider)
      .fetchPage(view: args.view, page: args.page, pageSize: pageSize);
}

@riverpod
Future<List<ProjectRow>> projectRows(Ref ref, ProjectView view) {
  return ref.watch(projectsRepositoryProvider).fetchAll(view: view);
}
