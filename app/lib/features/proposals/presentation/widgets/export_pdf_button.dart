import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:app/core/constants/breakpoints.dart';
import 'package:app/core/utils/toasts.dart';
import 'package:app/features/proposals/presentation/controllers/export_proposal.dart';
import 'package:app/features/proposals/presentation/widgets/missing_data_sheet.dart';
import 'package:app/features/proposals/presentation/widgets/pdf_preview_page.dart';

class ExportPdfButton extends ConsumerWidget {
  const ExportPdfButton({required this.projectId, super.key});

  final String projectId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(exportProposalControllerProvider(projectId));
    final compact = MediaQuery.sizeOf(context).width < Breakpoints.phone;
    final creating = state.creating;

    if (compact) {
      return Tooltip(
        message: creating ? 'Creating PDF…' : 'Export PDF',
        child: IconButton(
          onPressed: creating ? null : () => _export(context, ref),
          icon: creating
              ? const SizedBox(
                  width: 22,
                  height: 22,
                  child: CircularProgressIndicator(strokeWidth: 2),
                )
              : const Icon(Icons.request_quote_outlined),
        ),
      );
    }

    return FilledButton.icon(
      onPressed: creating ? null : () => _export(context, ref),
      style: FilledButton.styleFrom(
        minimumSize: const Size(0, 40),
        padding: const EdgeInsets.symmetric(horizontal: 16),
      ),
      icon: creating
          ? const SizedBox(
              width: 18,
              height: 18,
              child: CircularProgressIndicator(strokeWidth: 2),
            )
          : const Icon(Icons.picture_as_pdf_outlined, size: 18),
      label: Text(creating ? 'Creating PDF…' : 'Export PDF'),
    );
  }

  Future<void> _export(BuildContext context, WidgetRef ref) async {
    final result = await ref
        .read(exportProposalControllerProvider(projectId).notifier)
        .export();
    if (!context.mounted) return;
    await _handleResult(context, ref, result);
  }

  Future<void> _handleResult(
    BuildContext context,
    WidgetRef ref,
    ExportProposalState result,
  ) async {
    if (result.missing != null) {
      await showMissingDataSheet(context, missing: result.missing!);
      return;
    }
    if (result.errorMessage != null) {
      if (result.canRetry) {
        AppSnackbars.showAction(
          context,
          result.errorMessage!,
          actionLabel: 'Retry',
          onAction: () => _export(context, ref),
        );
        return;
      }
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
