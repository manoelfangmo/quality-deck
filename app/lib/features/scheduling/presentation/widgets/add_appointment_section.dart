import 'package:flutter/material.dart';

import 'package:app/features/scheduling/domain/appointment_draft.dart';
import 'package:app/features/scheduling/presentation/calendar_sync_note.dart';
import 'package:app/features/scheduling/presentation/widgets/appointment_fields.dart';

class AddAppointmentSection extends StatelessWidget {
  const AddAppointmentSection({
    required this.isOpen,
    required this.enabled,
    required this.onOpen,
    required this.onClear,
    required this.onDateChanged,
    required this.onStartChanged,
    required this.onDurationChanged,
    required this.onNotesChanged,
    this.draft,
    this.dateError,
    this.timeError,
    this.durationError,
    this.notesError,
    super.key,
  });

  final bool isOpen;
  final bool enabled;
  final AppointmentDraft? draft;
  final VoidCallback onOpen;
  final VoidCallback onClear;
  final ValueChanged<DateTime> onDateChanged;
  final void Function(int hour, int minute) onStartChanged;
  final ValueChanged<int> onDurationChanged;
  final ValueChanged<String> onNotesChanged;
  final String? dateError;
  final String? timeError;
  final String? durationError;
  final String? notesError;

  @override
  Widget build(BuildContext context) {
    final secondary = Theme.of(context).textTheme.bodySmall?.copyWith(
      color: Theme.of(context).colorScheme.onSurfaceVariant,
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        if (!isOpen)
          Align(
            alignment: Alignment.centerLeft,
            child: TextButton(
              onPressed: enabled ? onOpen : null,
              child: const Text('+ Add appointment'),
            ),
          )
        else ...[
          Row(
            children: [
              Expanded(
                child: Text(
                  'Appointment',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
              ),
              TextButton(
                onPressed: enabled ? onClear : null,
                child: const Text('Remove'),
              ),
            ],
          ),
          if (draft != null)
            AppointmentFields(
              draft: draft!,
              enabled: enabled,
              onDateChanged: onDateChanged,
              onStartChanged: onStartChanged,
              onDurationChanged: onDurationChanged,
              onNotesChanged: onNotesChanged,
              dateError: dateError,
              timeError: timeError,
              durationError: durationError,
              notesError: notesError,
            ),
        ],
        const SizedBox(height: 8),
        Text(calendarSyncComingSoonNote, style: secondary),
      ],
    );
  }
}
