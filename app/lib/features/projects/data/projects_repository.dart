import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'package:app/core/database/project_rows_view.dart';
import 'package:app/core/database/rpc.dart';
import 'package:app/core/domain/app_exception.dart';
import 'package:app/core/utils/providers.dart';
import 'package:app/features/projects/data/models.dart';
import 'package:app/features/projects/domain/project_view.dart';

part 'projects_repository.g.dart';

@riverpod
ProjectsRepository projectsRepository(Ref ref) {
  return ProjectsRepository(ref.watch(supabaseProvider));
}

class ProjectsRepository {
  ProjectsRepository(this._supabase);

  final SupabaseClient _supabase;

  /// Active: archived_at is null, created_at desc. Archived: archived_at
  /// not null, archived_at desc. Then id.
  Future<ProjectPage> fetchPage({
    required ProjectView view,
    required int page,
    required int pageSize,
  }) async {
    final from = page * pageSize;
    final orderColumn = view == ProjectView.active
        ? ProjectRowsView.createdAt
        : ProjectRowsView.archivedAt;
    var query = _supabase.from(ProjectRowsView.name).select();
    query = view == ProjectView.active
        ? query.isFilter(ProjectRowsView.archivedAt, null)
        : query.not(ProjectRowsView.archivedAt, 'is', null);
    final res = await query
        .order(orderColumn, ascending: false)
        .order(ProjectRowsView.id)
        .range(from, from + pageSize - 1)
        .count(CountOption.exact);
    return ProjectPage(
      projects: res.data.map(ProjectRow.fromJson).toList(),
      total: res.count,
    );
  }

  /// The paginated table pages in memory, so the list screen loads the
  /// current view in one query. [fetchPage] is still used by tests and
  /// [projectRowsPageProvider].
  Future<List<ProjectRow>> fetchAll({required ProjectView view}) async {
    final orderColumn = view == ProjectView.active
        ? ProjectRowsView.createdAt
        : ProjectRowsView.archivedAt;
    var query = _supabase.from(ProjectRowsView.name).select();
    query = view == ProjectView.active
        ? query.isFilter(ProjectRowsView.archivedAt, null)
        : query.not(ProjectRowsView.archivedAt, 'is', null);
    final rows = await query
        .order(orderColumn, ascending: false)
        .order(ProjectRowsView.id);
    return rows.map(ProjectRow.fromJson).toList();
  }

  Future<ProjectRow?> fetchOne(String projectId) async {
    final row = await _supabase
        .from(ProjectRowsView.name)
        .select()
        .eq(ProjectRowsView.id, projectId)
        .maybeSingle();
    if (row == null) return null;
    return ProjectRow.fromJson(row);
  }

  Future<String> create(CreateProjectCommand command) async {
    try {
      final result = await _supabase.rpc(
        Rpc.createProject,
        params: command.toJson(),
      );
      return result as String;
    } catch (error, stackTrace) {
      AppException.throwFrom(error, stackTrace);
    }
  }

  Future<void> archive(String projectId) async {
    try {
      await _supabase.rpc(
        Rpc.archiveProject,
        params: {Rpc.pProjectId: projectId},
      );
    } catch (error, stackTrace) {
      AppException.throwFrom(error, stackTrace);
    }
  }

  Future<void> unarchive(String projectId) async {
    try {
      await _supabase.rpc(
        Rpc.unarchiveProject,
        params: {Rpc.pProjectId: projectId},
      );
    } catch (error, stackTrace) {
      AppException.throwFrom(error, stackTrace);
    }
  }
}
