import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:app/core/utils/toasts.dart';
import 'package:app/core/widgets/error_retry.dart';
import 'package:app/features/estimates/domain/job_with_lines.dart';
import 'package:app/features/estimates/presentation/controllers/line_removal.dart';
import 'package:app/features/estimates/presentation/controllers/project_jobs.dart';
import 'package:app/features/estimates/presentation/widgets/job_card.dart';
import 'package:app/features/estimates/presentation/widgets/job_form_sheet.dart';

class JobsSection extends ConsumerWidget {
  const JobsSection({
    required this.projectId,
    required this.readOnly,
    super.key,
  });

  final String projectId;
  final bool readOnly;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final jobs = ref.watch(projectJobsProvider(projectId));

    ref.listen(lineRemovalControllerProvider(projectId), (previous, next) {
      final message = next.errorMessage;
      if (message != null && message != previous?.errorMessage) {
        AppSnackbars.show(context, message);
      }
    });

    return jobs.when(
      loading: () => const Padding(
        padding: EdgeInsets.symmetric(vertical: 24),
        child: Center(child: CircularProgressIndicator()),
      ),
      error: (error, stackTrace) => ErrorRetry(
        onRetry: () => ref.invalidate(projectJobsProvider(projectId)),
      ),
      data: (list) => _JobsBody(
        projectId: projectId,
        jobs: list,
        readOnly: readOnly,
      ),
    );
  }
}

class _JobsBody extends StatelessWidget {
  const _JobsBody({
    required this.projectId,
    required this.jobs,
    required this.readOnly,
  });

  final String projectId;
  final List<JobWithLines> jobs;
  final bool readOnly;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Row(
          children: [
            Expanded(
              child: Text('Jobs', style: Theme.of(context).textTheme.titleLarge),
            ),
            if (!readOnly)
              TextButton(
                onPressed: () =>
                    showJobFormSheet(context, projectId: projectId),
                child: const Text('+ Add job'),
              ),
          ],
        ),
        const SizedBox(height: 8),
        if (jobs.isEmpty)
          _EmptyJobs(
            readOnly: readOnly,
            onAdd: () => showJobFormSheet(context, projectId: projectId),
          )
        else ...[
          for (final job in jobs) ...[
            JobCard(
              projectId: projectId,
              jobWithLines: job,
              readOnly: readOnly,
            ),
            const SizedBox(height: 12),
          ],
        ],
      ],
    );
  }
}

class _EmptyJobs extends StatelessWidget {
  const _EmptyJobs({required this.readOnly, required this.onAdd});

  final bool readOnly;
  final VoidCallback onAdd;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16),
      child: Column(
        children: [
          Text(
            'No jobs yet. Add the first scope of work.',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: Theme.of(context).colorScheme.onSurfaceVariant,
            ),
            textAlign: TextAlign.center,
          ),
          if (!readOnly) ...[
            const SizedBox(height: 12),
            FilledButton(onPressed: onAdd, child: const Text('Add job')),
          ],
        ],
      ),
    );
  }
}
