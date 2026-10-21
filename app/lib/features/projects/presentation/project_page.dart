import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:app/core/constants/breakpoints.dart';
import 'package:app/core/routing/app_routes.dart';
import 'package:app/core/utils/providers.dart';
import 'package:app/core/utils/toasts.dart';
import 'package:app/features/business/presentation/controllers/current_business.dart';
import 'package:app/features/estimates/presentation/widgets/jobs_section.dart';
import 'package:app/features/onsite/presentation/widgets/photo_leave_scope.dart';
import 'package:app/features/projects/data/models.dart';
import 'package:app/features/projects/presentation/controllers/project.dart';
import 'package:app/features/projects/presentation/controllers/project_actions.dart';
import 'package:app/features/projects/presentation/widgets/project_app_bar_actions.dart';
import 'package:app/features/projects/presentation/widgets/project_client_cell.dart';
import 'package:app/features/projects/presentation/widgets/project_total_card.dart';

class ProjectPage extends ConsumerWidget {
  const ProjectPage({required this.projectId, super.key});

  final String projectId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final async = ref.watch(projectProvider(projectId));
    final now = ref.watch(clockProvider).now();
    final timeZone =
        ref.watch(currentBusinessProvider).value?.timezone ??
        'America/New_York';

    return async.when(
      loading: () =>
          const Scaffold(body: Center(child: CircularProgressIndicator())),
      error: (_, _) => _NotFound(onBack: () => context.go(AppRoutes.projects)),
      data: (row) {
        if (row == null) {
          return _NotFound(onBack: () => context.go(AppRoutes.projects));
        }
        return _ProjectBody(row: row, now: now, timeZone: timeZone);
      },
    );
  }
}

class _NotFound extends StatelessWidget {
  const _NotFound({required this.onBack});

  final VoidCallback onBack;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Project')),
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              "This project couldn't be found.",
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 16),
            FilledButton(
              onPressed: onBack,
              child: const Text('Back to projects'),
            ),
          ],
        ),
      ),
    );
  }
}

class _ProjectBody extends ConsumerWidget {
  const _ProjectBody({
    required this.row,
    required this.now,
    required this.timeZone,
  });

  final ProjectRow row;
  final DateTime now;
  final String timeZone;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final wide = MediaQuery.sizeOf(context).width >= Breakpoints.wide;
    final archived = row.isArchived;

    return PhotoLeaveScope(
      child: Scaffold(
        appBar: AppBar(
          title: Text(row.title),
          actions: [ProjectAppBarActions(row: row)],
        ),
        body: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            if (archived) ...[
              _ArchivedBanner(onUnarchive: () => _unarchive(context, ref)),
              const SizedBox(height: 16),
            ],
            if (wide)
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: _ClientCard(row: row, now: now, timeZone: timeZone),
                  ),
                  const SizedBox(width: 16),
                  Expanded(child: _SiteCard(row: row)),
                ],
              )
            else ...[
              _ClientCard(row: row, now: now, timeZone: timeZone),
              const SizedBox(height: 16),
              _SiteCard(row: row),
            ],
            const SizedBox(height: 24),
            JobsSection(projectId: row.id, readOnly: archived),
            const SizedBox(height: 16),
            ProjectTotalCard(row: row, readOnly: archived),
          ],
        ),
      ),
    );
  }

  Future<void> _unarchive(BuildContext context, WidgetRef ref) async {
    final ok = await ref
        .read(projectActionsControllerProvider(row.id).notifier)
        .unarchive();
    if (ok && context.mounted) {
      AppSnackbars.showUndo(
        context,
        'Project unarchived',
        onUndo: () {
          ref.read(projectActionsControllerProvider(row.id).notifier).archive();
        },
      );
    } else if (context.mounted) {
      final message = ref
          .read(projectActionsControllerProvider(row.id))
          .errorMessage;
      if (message != null) AppSnackbars.show(context, message);
    }
  }
}

class _ClientCard extends StatelessWidget {
  const _ClientCard({
    required this.row,
    required this.now,
    required this.timeZone,
  });

  final ProjectRow row;
  final DateTime now;
  final String timeZone;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Client', style: Theme.of(context).textTheme.labelLarge),
            const SizedBox(height: 8),
            ProjectClientCell(
              row: row,
              now: now,
              timeZone: timeZone,
              expanded: true,
            ),
          ],
        ),
      ),
    );
  }
}

class _SiteCard extends StatelessWidget {
  const _SiteCard({required this.row});

  final ProjectRow row;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Site', style: Theme.of(context).textTheme.labelLarge),
            const SizedBox(height: 8),
            Text(row.siteAddress.street),
            Text(
              '${row.siteAddress.city}, ${row.siteAddress.state} ${row.siteAddress.zip}',
            ),
          ],
        ),
      ),
    );
  }
}

class _ArchivedBanner extends StatelessWidget {
  const _ArchivedBanner({required this.onUnarchive});

  final VoidCallback onUnarchive;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Theme.of(context).colorScheme.surfaceContainerHighest,
      borderRadius: BorderRadius.circular(8),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 8, 8, 8),
        child: Row(
          children: [
            const Expanded(child: Text('This project is archived.')),
            TextButton(onPressed: onUnarchive, child: const Text('Unarchive')),
          ],
        ),
      ),
    );
  }
}
