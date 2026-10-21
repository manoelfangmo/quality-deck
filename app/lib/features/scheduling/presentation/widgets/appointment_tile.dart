import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:app/core/domain/business_time.dart';
import 'package:app/core/utils/providers.dart';
import 'package:app/core/utils/toasts.dart';
import 'package:app/core/widgets/confirm_dialog.dart';
import 'package:app/features/business/presentation/controllers/current_business.dart';
import 'package:app/features/scheduling/domain/appointment.dart';
import 'package:app/features/scheduling/presentation/calendar_sync_note.dart';
import 'package:app/features/scheduling/presentation/controllers/appointment_actions.dart';
import 'package:app/features/scheduling/presentation/widgets/edit_appointment_sheet.dart';

class AppointmentTile extends ConsumerWidget {
  const AppointmentTile({
    required this.appointment,
    required this.clientId,
    super.key,
  });

  final Appointment appointment;
  final String clientId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final now = ref.watch(clockProvider).now();
    final timeZone =
        ref.watch(currentBusinessProvider).value?.timezone ??
        'America/New_York';
    final businessTime = BusinessTime(timeZone);
    final past = appointment.isPast(now);
    final title = businessTime.formatTile(
      appointment.startsAt,
      appointment.durationMinutes,
    );
    final preview = appointment.notesPreview;
    final secondary = Theme.of(context).textTheme.bodySmall?.copyWith(
      color: Theme.of(context).colorScheme.onSurfaceVariant,
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text('Appointment', style: Theme.of(context).textTheme.titleMedium),
        const SizedBox(height: 8),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: Theme.of(context).textTheme.bodyLarge),
                  if (past) ...[
                    const SizedBox(height: 2),
                    Text('Past', style: secondary),
                  ],
                  if (preview != null) ...[
                    const SizedBox(height: 4),
                    Text(preview, style: secondary),
                  ],
                ],
              ),
            ),
            // Trailing slot reserved for a later calendar-sync chip.
            const SizedBox(width: 8),
          ],
        ),
        const SizedBox(height: 8),
        Row(
          children: [
            TextButton(
              onPressed: () => _edit(context, ref),
              child: const Text('Edit'),
            ),
            TextButton(
              onPressed: () => _remove(context, ref),
              child: const Text('Remove'),
            ),
          ],
        ),
        const SizedBox(height: 4),
        Text(calendarSyncComingSoonNote, style: secondary),
      ],
    );
  }

  Future<void> _edit(BuildContext context, WidgetRef ref) async {
    final updated = await showEditAppointmentSheet(
      context,
      appointment: appointment,
      clientId: clientId,
    );
    if (updated && context.mounted) {
      AppSnackbars.show(context, 'Appointment updated');
    }
  }

  Future<void> _remove(BuildContext context, WidgetRef ref) async {
    final confirmed = await showConfirmDialog(
      context: context,
      title: 'Remove this appointment?',
      body: 'It will be hidden from the app.',
      confirmLabel: 'Remove',
    );
    if (!confirmed) return;
    try {
      await ref
          .read(appointmentActionsControllerProvider.notifier)
          .remove(appointment.id, clientId: clientId);
      if (context.mounted) {
        AppSnackbars.show(context, 'Appointment removed');
      }
    } catch (error) {
      if (context.mounted) {
        AppSnackbars.show(context, error.toString());
      }
    }
  }
}
