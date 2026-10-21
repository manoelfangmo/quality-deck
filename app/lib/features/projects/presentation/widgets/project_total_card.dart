import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:app/features/estimates/domain/job_with_lines.dart';
import 'package:app/features/estimates/presentation/controllers/line_removal.dart';
import 'package:app/features/estimates/presentation/controllers/project_jobs.dart';
import 'package:app/features/pricing/presentation/controllers/pricing_settings.dart';
import 'package:app/features/projects/data/models.dart';
import 'package:app/features/projects/presentation/widgets/overhead_sheet.dart';

class ProjectTotalCard extends ConsumerWidget {
  const ProjectTotalCard({
    required this.row,
    required this.readOnly,
    super.key,
  });

  final ProjectRow row;
  final bool readOnly;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final jobsAsync = ref.watch(projectJobsProvider(row.id));
    final hidden = ref.watch(lineRemovalControllerProvider(row.id)).hiddenIds;

    return jobsAsync.when(
      loading: () => const SizedBox.shrink(),
      error: (error, stackTrace) => const SizedBox.shrink(),
      data: (jobs) {
        if (jobs.isEmpty) return const SizedBox.shrink();
        final visible = [
          for (final job in jobs)
            JobWithLines(
              job: job.job,
              lines: [
                for (final line in job.lines)
                  if (!hidden.contains(line.id)) line,
              ],
            ),
        ];
        final totals = projectTotals(visible, row.overhead);
        return _TotalCard(
          row: row,
          totals: totals,
          readOnly: readOnly,
        );
      },
    );
  }
}

class _TotalCard extends ConsumerWidget {
  const _TotalCard({
    required this.row,
    required this.totals,
    required this.readOnly,
  });

  final ProjectRow row;
  final ProjectTotals totals;
  final bool readOnly;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text('Project total', style: theme.textTheme.titleMedium),
            const SizedBox(height: 12),
            for (final job in totals.jobs)
              _Line(
                label: job.job.numberedTitle,
                amount: job.total.format(),
              ),
            const Divider(),
            _Line(label: 'Subtotal', amount: totals.subtotal.format()),
            if (totals.hasOverhead)
              InkWell(
                onTap: () => _openOverhead(context, ref),
                child: _Line(
                  label: 'Overhead (${totals.overhead!.format()})',
                  amount: totals.overheadCents!.format(),
                ),
              )
            else if (!readOnly)
              Align(
                alignment: Alignment.centerLeft,
                child: TextButton(
                  onPressed: () => _openOverhead(context, ref),
                  child: const Text('+ Add overhead'),
                ),
              ),
            const SizedBox(height: 8),
            _Line(
              label: 'Total',
              amount: totals.total.format(),
              emphasized: true,
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _openOverhead(BuildContext context, WidgetRef ref) {
    return showOverheadSheet(
      context,
      projectId: row.id,
      current: row.overhead,
      prefilled: row.overhead == null
          ? ref.read(pricingSettingsProvider).value?.overhead
          : null,
      subtotal: totals.subtotal,
      readOnly: readOnly,
    );
  }
}

class _Line extends StatelessWidget {
  const _Line({
    required this.label,
    required this.amount,
    this.emphasized = false,
  });

  final String label;
  final String amount;
  final bool emphasized;

  @override
  Widget build(BuildContext context) {
    final style = emphasized
        ? Theme.of(context).textTheme.titleSmall
        : Theme.of(context).textTheme.bodyMedium;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Expanded(child: Text(label, style: style)),
          Text(amount, style: style),
        ],
      ),
    );
  }
}
