import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:app/core/constants/breakpoints.dart';
import 'package:app/core/domain/app_exception.dart';
import 'package:app/core/domain/business_time.dart';
import 'package:app/core/widgets/loading_button.dart';
import 'package:app/features/business/presentation/controllers/current_business.dart';
import 'package:app/features/scheduling/data/models.dart';
import 'package:app/features/scheduling/domain/appointment.dart';
import 'package:app/features/scheduling/domain/appointment_draft.dart';
import 'package:app/features/scheduling/presentation/calendar_sync_note.dart';
import 'package:app/features/scheduling/presentation/controllers/appointment_actions.dart';
import 'package:app/features/scheduling/presentation/validators/appointment_validators.dart';
import 'package:app/features/scheduling/presentation/widgets/appointment_fields.dart';

Future<bool> showEditAppointmentSheet(
  BuildContext context, {
  required Appointment appointment,
  required String clientId,
}) async {
  final wide = MediaQuery.sizeOf(context).width >= Breakpoints.wide;
  if (wide) {
    final result = await showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (context) => EditAppointmentSheet(
        appointment: appointment,
        clientId: clientId,
      ),
    );
    return result ?? false;
  }

  final height = MediaQuery.sizeOf(context).height;
  final result = await showModalBottomSheet<bool>(
    context: context,
    isScrollControlled: true,
    enableDrag: false,
    isDismissible: false,
    useSafeArea: true,
    builder: (context) => SizedBox(
      height: height * 0.92,
      child: EditAppointmentSheet(
        appointment: appointment,
        clientId: clientId,
      ),
    ),
  );
  return result ?? false;
}

class EditAppointmentSheet extends ConsumerStatefulWidget {
  const EditAppointmentSheet({
    required this.appointment,
    required this.clientId,
    super.key,
  });

  final Appointment appointment;
  final String clientId;

  @override
  ConsumerState<EditAppointmentSheet> createState() =>
      _EditAppointmentSheetState();
}

class _EditAppointmentSheetState extends ConsumerState<EditAppointmentSheet> {
  late AppointmentDraft _draft;
  bool _submitting = false;
  bool _submitted = false;
  String? _error;
  String? _dateError;
  String? _timeError;
  String? _durationError;
  String? _notesError;

  @override
  void initState() {
    super.initState();
    final timeZone =
        ref.read(currentBusinessProvider).value?.timezone ??
        'America/New_York';
    final businessTime = BusinessTime(timeZone);
    final date = businessTime.calendarDate(widget.appointment.startsAt);
    final time = businessTime.timeOfDay(widget.appointment.startsAt);
    _draft = AppointmentDraft(
      date: date,
      startHour: time.hour,
      startMinute: time.minute,
      durationMinutes: AppointmentValidators.snapDuration(
        widget.appointment.durationMinutes,
      ),
      notes: widget.appointment.notes ?? '',
    );
  }

  String get _timeZone =>
      ref.read(currentBusinessProvider).value?.timezone ?? 'America/New_York';

  Future<void> _save() async {
    setState(() {
      _submitted = true;
      _dateError = AppointmentValidators.date(_draft.date);
      _timeError = AppointmentValidators.startTime(
        hour: _draft.startHour,
        minute: _draft.startMinute,
      );
      _durationError = AppointmentValidators.duration(_draft.durationMinutes);
      _notesError = AppointmentValidators.notes(_draft.notes);
      _error = null;
    });
    if (_dateError != null ||
        _timeError != null ||
        _durationError != null ||
        _notesError != null) {
      return;
    }

    setState(() => _submitting = true);
    try {
      final startsAt = BusinessTime(_timeZone).toUtc(
        date: _draft.date,
        startHour: _draft.startHour,
        startMinute: _draft.startMinute,
      );
      await ref
          .read(appointmentActionsControllerProvider.notifier)
          .update(
            UpdateAppointmentCommand(
              id: widget.appointment.id,
              startsAt: startsAt,
              durationMinutes: _draft.durationMinutes,
              notes: _draft.notes,
            ),
            clientId: widget.clientId,
          );
      if (mounted) Navigator.of(context).pop(true);
    } on AppException catch (error) {
      if (mounted) {
        setState(() {
          _submitting = false;
          _error = error.message;
        });
      }
    } catch (_) {
      if (mounted) {
        setState(() {
          _submitting = false;
          _error = 'Something went wrong.';
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final wide = MediaQuery.sizeOf(context).width >= Breakpoints.wide;
    final secondary = Theme.of(context).textTheme.bodySmall?.copyWith(
      color: Theme.of(context).colorScheme.onSurfaceVariant,
    );

    final fields = Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        AppointmentFields(
          draft: _draft,
          enabled: !_submitting,
          onDateChanged: (date) {
            setState(() {
              _draft = _draft.copyWith(date: date);
              if (_submitted) {
                _dateError = AppointmentValidators.date(date);
              }
            });
          },
          onStartChanged: (hour, minute) {
            setState(() {
              _draft = _draft.copyWith(startHour: hour, startMinute: minute);
              if (_submitted) {
                _timeError = AppointmentValidators.startTime(
                  hour: hour,
                  minute: minute,
                );
              }
            });
          },
          onDurationChanged: (minutes) {
            setState(() {
              _draft = _draft.copyWith(durationMinutes: minutes);
              if (_submitted) {
                _durationError = AppointmentValidators.duration(minutes);
              }
            });
          },
          onNotesChanged: (notes) {
            setState(() {
              _draft = _draft.copyWith(notes: notes);
              if (_submitted) {
                _notesError = AppointmentValidators.notes(notes);
              }
            });
          },
          dateError: _dateError,
          timeError: _timeError,
          durationError: _durationError,
          notesError: _notesError,
        ),
        const SizedBox(height: 8),
        Text(calendarSyncComingSoonNote, style: secondary),
        if (_error != null) ...[
          const SizedBox(height: 16),
          Text(
            _error!,
            style: TextStyle(color: Theme.of(context).colorScheme.error),
          ),
        ],
      ],
    );

    final actions = Padding(
      padding: const EdgeInsets.fromLTRB(24, 8, 24, 16),
      child: Row(
        children: [
          Expanded(
            child: OutlinedButton(
              onPressed: _submitting
                  ? null
                  : () => Navigator.of(context).pop(false),
              child: const Text('Cancel'),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: LoadingButton(
              label: 'Save',
              isLoading: _submitting,
              onPressed: _save,
            ),
          ),
        ],
      ),
    );

    final title = Padding(
      padding: const EdgeInsets.fromLTRB(24, 20, 24, 8),
      child: Text(
        'Edit appointment',
        textAlign: TextAlign.center,
        style: Theme.of(context).textTheme.titleLarge,
      ),
    );

    final body = wide
        ? Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              title,
              ConstrainedBox(
                constraints: BoxConstraints(
                  maxHeight: MediaQuery.sizeOf(context).height * 0.7,
                ),
                child: SingleChildScrollView(
                  padding: const EdgeInsets.fromLTRB(24, 8, 24, 8),
                  child: fields,
                ),
              ),
              actions,
            ],
          )
        : Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              title,
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.fromLTRB(24, 8, 24, 8),
                  child: fields,
                ),
              ),
              actions,
            ],
          );

    final material = Material(
      color: Theme.of(context).colorScheme.surface,
      child: SafeArea(child: body),
    );

    if (wide) {
      return Dialog(
        insetPadding: const EdgeInsets.all(24),
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 560),
          child: material,
        ),
      );
    }
    return material;
  }
}
