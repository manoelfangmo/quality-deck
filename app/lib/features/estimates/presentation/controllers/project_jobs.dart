import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'package:app/features/estimates/data/jobs_repository.dart';
import 'package:app/features/estimates/domain/job_with_lines.dart';

part 'project_jobs.g.dart';

@riverpod
Future<List<JobWithLines>> projectJobs(Ref ref, String projectId) {
  return ref.watch(jobsRepositoryProvider).fetchForProject(projectId);
}
