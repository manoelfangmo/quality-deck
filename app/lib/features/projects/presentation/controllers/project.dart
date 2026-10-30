import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'package:app/features/projects/data/models.dart';
import 'package:app/features/projects/data/projects_repository.dart';

part 'project.g.dart';

@riverpod
Future<ProjectRow?> project(Ref ref, String projectId) {
  return ref.watch(projectsRepositoryProvider).fetchOne(projectId);
}
