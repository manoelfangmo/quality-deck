import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:app/core/utils/toasts.dart';
import 'package:app/features/projects/data/models.dart';
import 'package:app/features/projects/presentation/controllers/project_actions.dart';
import 'package:app/features/projects/presentation/widgets/edit_project_sheet.dart';
import 'package:app/features/proposals/presentation/widgets/export_pdf_button.dart';

class ProjectAppBarActions extends ConsumerWidget {
  const ProjectAppBarActions({required this.row, super.key});

  final ProjectRow row;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        ExportPdfButton(projectId: row.id),
        PopupMenuButton<String>(
          onSelected: (value) => _onSelected(context, ref, value),
          itemBuilder: (context) => [
            if (!row.isArchived)
              const PopupMenuItem(
                value: 'edit',
                child: Text('Edit project'),
              ),
            PopupMenuItem(
              value: row.isArchived ? 'unarchive' : 'archive',
              child: Text(row.isArchived ? 'Unarchive' : 'Archive'),
            ),
          ],
        ),
      ],
    );
  }

  Future<void> _onSelected(
    BuildContext context,
    WidgetRef ref,
    String value,
  ) async {
    if (value == 'edit') {
      await showEditProjectSheet(context, row: row);
    } else if (value == 'archive') {
      await _archive(context, ref);
    } else if (value == 'unarchive') {
      await _unarchive(context, ref);
    }
  }

  Future<void> _archive(BuildContext context, WidgetRef ref) async {
    final ok = await ref
        .read(projectActionsControllerProvider(row.id).notifier)
        .archive();
    if (!context.mounted) return;
    if (ok) {
      AppSnackbars.showUndo(
        context,
        'Project archived',
        onUndo: () {
          ref.read(projectActionsControllerProvider(row.id).notifier).unarchive();
        },
      );
    } else {
      final message = ref.read(projectActionsControllerProvider(row.id)).errorMessage;
      if (message != null) AppSnackbars.show(context, message);
    }
  }

  Future<void> _unarchive(BuildContext context, WidgetRef ref) async {
    final ok = await ref
        .read(projectActionsControllerProvider(row.id).notifier)
        .unarchive();
    if (!context.mounted) return;
    if (ok) {
      AppSnackbars.showUndo(
        context,
        'Project unarchived',
        onUndo: () {
          ref.read(projectActionsControllerProvider(row.id).notifier).archive();
        },
      );
    } else {
      final message = ref.read(projectActionsControllerProvider(row.id)).errorMessage;
      if (message != null) AppSnackbars.show(context, message);
    }
  }
}
