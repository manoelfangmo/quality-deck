import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import 'package:app/core/utils/toasts.dart';
import 'package:app/features/proposals/data/proposal_export_providers.dart';
import 'package:app/features/proposals/domain/proposal_export.dart';
import 'package:app/features/proposals/presentation/controllers/export_proposal.dart';
import 'package:app/features/proposals/presentation/widgets/pdf_preview_page.dart';

class ExportHistory extends ConsumerWidget {
  const ExportHistory({required this.projectId, super.key});

  final String projectId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final async = ref.watch(proposalExportsProvider(projectId));
    return async.when(
      loading: () => const SizedBox.shrink(),
      error: (error, stackTrace) => const SizedBox.shrink(),
      data: (rows) {
        if (rows.isEmpty) return const SizedBox.shrink();
        return Card(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  'Export history',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                const SizedBox(height: 8),
                for (final row in rows)
                  _HistoryTile(
                    projectId: projectId,
                    record: row,
                  ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class _HistoryTile extends ConsumerWidget {
  const _HistoryTile({required this.projectId, required this.record});

  final String projectId;
  final ProposalExportRecord record;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final creating = ref.watch(
      exportProposalControllerProvider(projectId).select((s) => s.creating),
    );
    final when = DateFormat('MMM d, y • h:mm a').format(record.createdAt);

    return ListTile(
      contentPadding: EdgeInsets.zero,
      title: Text('Version ${record.version} · ${record.proposalNumber}'),
      subtitle: Text('$when · ${record.createdByName}'),
      trailing: const Icon(Icons.chevron_right),
      enabled: !creating,
      onTap: creating ? null : () => _open(context, ref),
    );
  }

  Future<void> _open(BuildContext context, WidgetRef ref) async {
    final result = await ref
        .read(exportProposalControllerProvider(projectId).notifier)
        .openRecord(record);
    if (!context.mounted) return;
    if (result.errorMessage != null) {
      AppSnackbars.show(context, result.errorMessage!);
      return;
    }
    final export = result.export;
    final bytes = result.bytes;
    if (export != null && bytes != null) {
      await openPdfPreview(context, export: export, bytes: bytes);
    }
  }
}
