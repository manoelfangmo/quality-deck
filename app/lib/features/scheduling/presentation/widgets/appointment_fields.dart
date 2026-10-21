import 'package:flutter/material.dart';

import 'package:app/core/domain/business_time.dart';
import 'package:app/features/scheduling/domain/appointment_draft.dart';
import 'package:app/features/scheduling/presentation/validators/appointment_validators.dart';

class AppointmentFields extends StatefulWidget {
  const AppointmentFields({
    required this.draft,
    required this.enabled,
    required this.onDateChanged,
    required this.onStartChanged,
    required this.onDurationChanged,
    required this.onNotesChanged,
    this.dateError,
    this.timeError,
    this.durationError,
    this.notesError,
    super.key,
  });

  final AppointmentDraft draft;
  final bool enabled;
  final ValueChanged<DateTime> onDateChanged;
  final void Function(int hour, int minute) onStartChanged;
  final ValueChanged<int> onDurationChanged;
  final ValueChanged<String> onNotesChanged;
  final String? dateError;
  final String? timeError;
  final String? durationError;
  final String? notesError;

  @override
  State<AppointmentFields> createState() => _AppointmentFieldsState();
}

class _AppointmentFieldsState extends State<AppointmentFields> {
  late final TextEditingController _notes;

  @override
  void initState() {
    super.initState();
    _notes = TextEditingController(text: widget.draft.notes);
  }

  @override
  void didUpdateWidget(covariant AppointmentFields oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.draft.notes != widget.draft.notes &&
        _notes.text != widget.draft.notes) {
      _notes.text = widget.draft.notes;
    }
  }

  @override
  void dispose() {
    _notes.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final draft = widget.draft;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _PickerField(
          label: 'Date',
          value: _dateLabel(draft.date),
          errorText: widget.dateError,
          enabled: widget.enabled,
          onTap: () => _pickDate(context),
        ),
        const SizedBox(height: 16),
        _PickerField(
          label: 'Start time',
          value: BusinessTime.formatClock(draft.startHour, draft.startMinute),
          errorText: widget.timeError,
          enabled: widget.enabled,
          onTap: () => _pickTime(context),
        ),
        const SizedBox(height: 16),
        DropdownButtonFormField<int>(
          key: ValueKey(draft.durationMinutes),
          initialValue: draft.durationMinutes,
          decoration: InputDecoration(
            labelText: 'Duration',
            errorText: widget.durationError,
          ),
          items: [
            for (final minutes in AppointmentValidators.durations)
              DropdownMenuItem(
                value: minutes,
                child: Text(BusinessTime.formatDuration(minutes)),
              ),
          ],
          onChanged: widget.enabled
              ? (value) {
                  if (value != null) widget.onDurationChanged(value);
                }
              : null,
        ),
        const SizedBox(height: 16),
        TextField(
          controller: _notes,
          enabled: widget.enabled,
          minLines: 2,
          maxLines: 4,
          maxLength: AppointmentValidators.maxNotes,
          textCapitalization: TextCapitalization.sentences,
          decoration: InputDecoration(
            labelText: 'Notes',
            errorText: widget.notesError,
          ),
          onChanged: widget.onNotesChanged,
        ),
      ],
    );
  }

  Future<void> _pickDate(BuildContext context) async {
    final picked = await showDatePicker(
      context: context,
      initialDate: widget.draft.date,
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );
    if (picked != null) widget.onDateChanged(picked);
  }

  Future<void> _pickTime(BuildContext context) async {
    final picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay(
        hour: widget.draft.startHour,
        minute: widget.draft.startMinute,
      ),
    );
    if (picked != null) widget.onStartChanged(picked.hour, picked.minute);
  }

  static String _dateLabel(DateTime date) {
    const months = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec',
    ];
    return '${months[date.month - 1]} ${date.day}, ${date.year}';
  }
}

class _PickerField extends StatelessWidget {
  const _PickerField({
    required this.label,
    required this.value,
    required this.enabled,
    required this.onTap,
    this.errorText,
  });

  final String label;
  final String value;
  final bool enabled;
  final VoidCallback onTap;
  final String? errorText;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: enabled ? onTap : null,
      child: InputDecorator(
        decoration: InputDecoration(
          labelText: label,
          errorText: errorText,
          suffixIcon: const Icon(Icons.event),
        ),
        child: Text(value),
      ),
    );
  }
}
