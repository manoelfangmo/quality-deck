import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import 'package:app/core/constants/breakpoints.dart';
import 'package:app/core/utils/providers.dart';
import 'package:app/core/utils/toasts.dart';
import 'package:app/core/widgets/error_retry.dart';
import 'package:app/core/widgets/paginated_table_component.dart';
import 'package:app/core/widgets/table_dropdown_button.dart';
import 'package:app/features/business/presentation/controllers/current_business.dart';
import 'package:app/features/projects/data/models.dart';
import 'package:app/features/projects/domain/project_view.dart';
import 'package:app/features/projects/presentation/controllers/project_actions.dart';
import 'package:app/features/projects/presentation/controllers/projects_table.dart';
import 'package:app/features/projects/presentation/routes.dart';
import 'package:app/features/projects/presentation/widgets/create_project_sheet.dart';
import 'package:app/features/projects/presentation/widgets/project_client_cell.dart';

class ProjectsPage extends ConsumerWidget {
  const ProjectsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final table = ref.watch(projectsTableControllerProvider);
    final rows = ref.watch(projectRowsProvider(table.view));
    final compact = MediaQuery.sizeOf(context).width < Breakpoints.phone;
    final now = ref.watch(clockProvider).now();
    final timeZone =
        ref.watch(currentBusinessProvider).value?.timezone ??
        'America/New_York';

    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text('Projects', style: Theme.of(context).textTheme.headlineSmall),
            const SizedBox(height: 12),
            Row(
              children: [
                Flexible(
                  child: SegmentedButton<ProjectView>(
                    segments: const [
                      ButtonSegment(
                        value: ProjectView.active,
                        label: Text('Active'),
                      ),
                      ButtonSegment(
                        value: ProjectView.archived,
                        label: Text('Archived'),
                      ),
                    ],
                    selected: {table.view},
                    showSelectedIcon: false,
                    onSelectionChanged: (selected) {
                      ref
                          .read(projectsTableControllerProvider.notifier)
                          .setView(selected.first);
                    },
                  ),
                ),
                const SizedBox(width: 12),
                _AddProjectButton(
                  compact: compact,
                  onPressed: () => showCreateProjectSheet(context),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Expanded(
              child: rows.when(
                loading: () => const Center(child: CircularProgressIndicator()),
                error: (error, stackTrace) => ErrorRetry(
                  onRetry: () =>
                      ref.invalidate(projectRowsProvider(table.view)),
                ),
                data: (list) {
                  if (list.isEmpty) {
                    return _EmptyProjects(
                      view: table.view,
                      compact: compact,
                      onAdd: () => showCreateProjectSheet(context),
                    );
                  }
                  return PaginatedTableComponent<ProjectRow>(
                    showSearchField: false,
                    hasFlexibleRowHeight: true,
                    onTap: (row) =>
                        context.go(ProjectRoute(row.id).location),
                    columns: _columns(
                      context,
                      ref,
                      view: table.view,
                      compact: compact,
                      now: now,
                      timeZone: timeZone,
                    ),
                    data: list,
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  List<TableColumn<ProjectRow>> _columns(
    BuildContext context,
    WidgetRef ref, {
    required ProjectView view,
    required bool compact,
    required DateTime now,
    required String timeZone,
  }) {
    return [
      TableColumn(
        columnName: 'Title',
        onBuild: (row) => Text(row.title),
      ),
      TableColumn(
        columnName: 'Client',
        onBuild: (row) => ProjectClientCell(
          row: row,
          now: now,
          timeZone: timeZone,
        ),
      ),
      if (!compact)
        TableColumn(
          columnName: 'Site',
          onBuild: (row) => Text(row.siteAddress.cityState),
        ),
      if (!compact)
        TableColumn(
          columnName: view == ProjectView.active ? 'Created' : 'Archived',
          onBuild: (row) {
            final date = view == ProjectView.active
                ? row.createdAt
                : row.archivedAt ?? row.createdAt;
            return Text(DateFormat('MMM d').format(date));
          },
        ),
      TableColumn(
        columnName: '',
        onBuild: (row) => TableDropdownButton(
          actions: [
            DropDownAction(
              actionName: view == ProjectView.active ? 'Archive' : 'Unarchive',
              onClick: () => _toggleArchive(context, ref, row, view),
            ),
          ],
        ),
      ),
    ];
  }

  Future<void> _toggleArchive(
    BuildContext context,
    WidgetRef ref,
    ProjectRow row,
    ProjectView view,
  ) async {
    final actions = ref.read(projectActionsControllerProvider(row.id).notifier);
    final archived = view == ProjectView.active;
    final ok = archived ? await actions.archive() : await actions.unarchive();
    if (!context.mounted) return;
    if (ok) {
      AppSnackbars.showUndo(
        context,
        archived ? 'Project archived' : 'Project unarchived',
        onUndo: () {
          if (archived) {
            actions.unarchive();
          } else {
            actions.archive();
          }
        },
      );
    } else {
      final message = ref
          .read(projectActionsControllerProvider(row.id))
          .errorMessage;
      if (message != null) AppSnackbars.show(context, message);
    }
  }
}

class _AddProjectButton extends StatelessWidget {
  const _AddProjectButton({required this.compact, required this.onPressed});

  final bool compact;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    if (compact) {
      return Semantics(
        label: 'Add project',
        button: true,
        child: IconButton.filled(
          tooltip: 'Add project',
          onPressed: onPressed,
          icon: const Icon(Icons.add),
        ),
      );
    }
    return FilledButton.icon(
      onPressed: onPressed,
      style: FilledButton.styleFrom(minimumSize: const Size(44, 48)),
      icon: const Icon(Icons.add),
      label: const Text('Add project'),
    );
  }
}

class _EmptyProjects extends StatelessWidget {
  const _EmptyProjects({
    required this.view,
    required this.compact,
    required this.onAdd,
  });

  final ProjectView view;
  final bool compact;
  final VoidCallback onAdd;

  @override
  Widget build(BuildContext context) {
    if (view == ProjectView.archived) {
      return Center(
        child: Text(
          'No archived projects.',
          style: Theme.of(context).textTheme.titleMedium,
        ),
      );
    }
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            'No projects yet',
            style: Theme.of(context).textTheme.titleMedium,
          ),
          const SizedBox(height: 16),
          _AddProjectButton(compact: compact, onPressed: onAdd),
        ],
      ),
    );
  }
}
