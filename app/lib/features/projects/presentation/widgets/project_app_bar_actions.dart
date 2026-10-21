import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:app/core/constants/breakpoints.dart';
import 'package:app/core/utils/toasts.dart';
import 'package:app/features/projects/data/models.dart';
import 'package:app/features/projects/presentation/controllers/project_actions.dart';
import 'package:app/features/projects/presentation/widgets/edit_project_sheet.dart';

class ProjectAppBarActions extends ConsumerWidget {
  const ProjectAppBarActions({required this.row, super.key});

  final ProjectRow row;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final compact = MediaQuery.sizeOf(context).width < Breakpoints.phone;
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        _GenerateProposalButton(compact: compact),
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

class _GenerateProposalButton extends StatelessWidget {
  const _GenerateProposalButton({required this.compact});

  final bool compact;

  @override
  Widget build(BuildContext context) {
    if (compact) {
      return Tooltip(
        message: 'Coming soon',
        child: Semantics(
          label: 'Generate proposal',
          button: true,
          child: IconButton(
            onPressed: null,
            icon: const Icon(Icons.request_quote_outlined),
          ),
        ),
      );
    }

    return Tooltip(
      message: 'Coming soon',
      child: FilledButton(
        onPressed: null,
        style: FilledButton.styleFrom(
          minimumSize: const Size(0, 40),
          padding: const EdgeInsets.symmetric(horizontal: 16),
        ),
        child: const Text('Generate proposal'),
      ),
    );
  }
}
