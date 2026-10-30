import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:app/core/domain/app_exception.dart';
import 'package:app/core/utils/toasts.dart';
import 'package:app/features/estimates/data/jobs_repository.dart';
import 'package:app/features/estimates/domain/job.dart';
import 'package:app/features/estimates/domain/job_with_lines.dart';
import 'package:app/features/estimates/domain/line_item.dart';
import 'package:app/features/estimates/presentation/controllers/line_removal.dart';
import 'package:app/features/estimates/presentation/controllers/line_reorder.dart';
import 'package:app/features/estimates/presentation/controllers/project_jobs.dart';
import 'package:app/features/estimates/presentation/widgets/add_from_price_list_sheet.dart';
import 'package:app/features/estimates/presentation/widgets/delete_job_dialog.dart';
import 'package:app/features/estimates/presentation/widgets/job_form_sheet.dart';
import 'package:app/features/estimates/presentation/widgets/labor_row.dart';
import 'package:app/features/estimates/presentation/widgets/labor_sheet.dart';
import 'package:app/features/estimates/presentation/widgets/line_form_sheet.dart';
import 'package:app/features/estimates/presentation/widgets/line_item_list.dart';
import 'package:app/features/onsite/presentation/widgets/job_photo_galleries.dart';
import 'package:app/features/pricing/presentation/controllers/pricing_settings.dart';

class JobCard extends ConsumerWidget {
  const JobCard({
    required this.projectId,
    required this.jobWithLines,
    required this.readOnly,
    super.key,
  });

  final String projectId;
  final JobWithLines jobWithLines;
  final bool readOnly;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final job = jobWithLines.job;
    final hidden = ref
        .watch(lineRemovalControllerProvider(projectId))
        .hiddenIds;
    final reorder = ref.watch(
      lineReorderControllerProvider(projectId: projectId, jobId: job.id),
    );
    final visible = _visibleLines(jobWithLines.lines, hidden, reorder.ids);
    final displayed = JobWithLines(job: job, lines: visible);
    final theme = Theme.of(context);

    return Card(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(8, 12, 16, 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              children: [
                Expanded(
                  child: Wrap(
                    spacing: 8,
                    runSpacing: 4,
                    crossAxisAlignment: WrapCrossAlignment.center,
                    children: [
                      Text(
                        job.numberedTitle,
                        style: theme.textTheme.titleMedium,
                      ),
                      Chip(
                        label: Text(job.jobType.label),
                        visualDensity: VisualDensity.compact,
                        materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      ),
                      if (job.isAlternate)
                        _AlternateChip(
                          projectId: projectId,
                          alternateOfJobId: job.alternateOfJobId!,
                        ),
                    ],
                  ),
                ),
                if (!readOnly)
                  PopupMenuButton<String>(
                    onSelected: (value) {
                      if (value == 'edit') {
                        showJobFormSheet(
                          context,
                          projectId: projectId,
                          job: job,
                        );
                      } else if (value == 'delete') {
                        _delete(context, ref);
                      }
                    },
                    itemBuilder: (context) => const [
                      PopupMenuItem(value: 'edit', child: Text('Edit job')),
                      PopupMenuItem(value: 'delete', child: Text('Delete job')),
                    ],
                  ),
              ],
            ),
            if (job.description != null && job.description!.isNotEmpty)
              Padding(
                padding: const EdgeInsets.fromLTRB(8, 4, 0, 8),
                child: _ExpandableDescription(text: job.description!),
              ),
            LineItemList(
              projectId: projectId,
              jobId: job.id,
              lines: visible,
              fullIds: jobWithLines.lines.map((line) => line.id).toList(),
              hiddenIds: hidden,
              readOnly: readOnly,
            ),
            if (job.labor != null)
              LaborRow(
                labor: job.labor!,
                onTap: () => showLaborSheet(
                  context,
                  projectId: projectId,
                  job: job,
                  readOnly: readOnly,
                ),
              ),
            if (!readOnly) ...[
              const SizedBox(height: 8),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: [
                  TextButton(
                    onPressed: () => showAddFromPriceListSheet(
                      context,
                      projectId: projectId,
                      jobId: job.id,
                    ),
                    child: const Text('+ Add from price list'),
                  ),
                  TextButton(
                    onPressed: () => showLineFormSheet(
                      context,
                      projectId: projectId,
                      jobId: job.id,
                    ),
                    child: const Text('+ Add custom line'),
                  ),
                  if (job.labor == null)
                    TextButton(
                      onPressed: () => showLaborSheet(
                        context,
                        projectId: projectId,
                        job: job,
                        prefilledRate: ref
                            .read(pricingSettingsProvider)
                            .value
                            ?.laborRate,
                      ),
                      child: const Text('+ Add labor'),
                    ),
                ],
              ),
            ],
            const SizedBox(height: 16),
            JobPhotoGalleries(jobId: job.id, readOnly: readOnly),
            const SizedBox(height: 8),
            Align(
              alignment: Alignment.centerRight,
              child: Text(
                'Job total ${displayed.total.format()}',
                style: theme.textTheme.titleSmall,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _delete(BuildContext context, WidgetRef ref) async {
    final job = jobWithLines.job;
    final confirmed = await showDeleteJobDialog(
      context: context,
      title: job.title,
      lineCount: jobWithLines.lines.length,
    );
    if (!confirmed) return;
    try {
      await ref.read(jobsRepositoryProvider).delete(job.id);
      ref.invalidate(projectJobsProvider(projectId));
      if (context.mounted) {
        AppSnackbars.show(context, 'Job deleted');
      }
    } on AppException catch (error) {
      if (context.mounted) AppSnackbars.show(context, error.message);
    } catch (_) {
      if (context.mounted) {
        AppSnackbars.show(context, 'Something went wrong.');
      }
    }
  }
}

List<LineItem> _visibleLines(
  List<LineItem> lines,
  Set<String> hidden,
  List<String>? optimisticIds,
) {
  final byId = {for (final line in lines) line.id: line};
  final ordered = optimisticIds == null
      ? lines
      : [
          for (final id in optimisticIds)
            if (byId[id] != null) byId[id]!,
        ];
  return [
    for (final line in ordered)
      if (!hidden.contains(line.id)) line,
  ];
}

class _AlternateChip extends ConsumerWidget {
  const _AlternateChip({
    required this.projectId,
    required this.alternateOfJobId,
  });

  final String projectId;
  final String alternateOfJobId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final jobs = ref.watch(projectJobsProvider(projectId)).value;
    Job? base;
    if (jobs != null) {
      for (final row in jobs) {
        if (row.job.id == alternateOfJobId) {
          base = row.job;
          break;
        }
      }
    }
    if (base == null) return const SizedBox.shrink();
    return Chip(
      label: Text('Option for: ${base.title}'),
      visualDensity: VisualDensity.compact,
      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
    );
  }
}

class _ExpandableDescription extends StatefulWidget {
  const _ExpandableDescription({required this.text});

  final String text;

  @override
  State<_ExpandableDescription> createState() => _ExpandableDescriptionState();
}

class _ExpandableDescriptionState extends State<_ExpandableDescription> {
  bool _expanded = false;

  @override
  Widget build(BuildContext context) {
    final style = Theme.of(context).textTheme.bodyMedium;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          widget.text,
          style: style,
          maxLines: _expanded ? null : 3,
          overflow: _expanded ? TextOverflow.visible : TextOverflow.ellipsis,
        ),
        if (!_expanded && widget.text.split('\n').length > 3)
          TextButton(
            onPressed: () => setState(() => _expanded = true),
            child: const Text('More'),
          ),
      ],
    );
  }
}
