import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:app/core/domain/app_exception.dart';
import 'package:app/core/domain/money.dart';
import 'package:app/core/domain/quantity.dart';
import 'package:app/core/utils/toasts.dart';
import 'package:app/core/widgets/adaptive_sheet.dart';
import 'package:app/core/widgets/confirm_dialog.dart';
import 'package:app/features/estimates/data/jobs_repository.dart';
import 'package:app/features/estimates/domain/job.dart';
import 'package:app/features/estimates/domain/labor.dart';
import 'package:app/features/estimates/domain/line_math.dart';
import 'package:app/features/estimates/presentation/controllers/project_jobs.dart';
import 'package:app/features/estimates/presentation/validators/estimate_validators.dart';

Future<bool> showLaborSheet(
  BuildContext context, {
  required String projectId,
  required Job job,
  Money? prefilledRate,
  bool readOnly = false,
}) async {
  final result = await showAdaptiveFormSheet<bool>(
    context: context,
    builder: (context) => LaborSheet(
      projectId: projectId,
      job: job,
      prefilledRate: prefilledRate,
      readOnly: readOnly,
    ),
  );
  return result ?? false;
}

class LaborSheet extends ConsumerStatefulWidget {
  const LaborSheet({
    required this.projectId,
    required this.job,
    this.prefilledRate,
    this.readOnly = false,
    super.key,
  });

  final String projectId;
  final Job job;
  final Money? prefilledRate;
  final bool readOnly;

  @override
  ConsumerState<LaborSheet> createState() => _LaborSheetState();
}

class _LaborSheetState extends ConsumerState<LaborSheet> {
  late final TextEditingController _hours;
  late final TextEditingController _rate;
  late final String _initialHours;
  late final String _initialRate;
  String? _hoursError;
  String? _rateError;
  String? _errorMessage;
  bool _submitting = false;

  bool get _isAdd => widget.job.labor == null;

  @override
  void initState() {
    super.initState();
    final labor = widget.job.labor;
    _initialHours = labor?.hours.format() ?? '';
    _hours = TextEditingController(text: _initialHours);
    final cents = labor?.rate.cents ?? widget.prefilledRate?.cents;
    _initialRate = cents == null ? '' : _moneyInput(cents);
    _rate = TextEditingController(text: _initialRate);
  }

  @override
  void dispose() {
    _hours.dispose();
    _rate.dispose();
    super.dispose();
  }

  bool get _isDirty =>
      _hours.text != _initialHours || _rate.text != _initialRate;

  Future<void> _cancel() async {
    if (!widget.readOnly && _isDirty) {
      final discard = await showConfirmDialog(
        context: context,
        title: 'Discard changes?',
        body: 'Your edits will be lost.',
        confirmLabel: 'Discard',
      );
      if (!discard) return;
    }
    if (mounted) Navigator.of(context).pop(false);
  }

  Future<void> _save() async {
    final hoursError = EstimateValidators.laborHours(_hours.text);
    final rateError = EstimateValidators.laborRate(_rate.text);
    if (hoursError != null || rateError != null) {
      setState(() {
        _hoursError = hoursError;
        _rateError = rateError;
      });
      return;
    }
    setState(() {
      _submitting = true;
      _errorMessage = null;
      _hoursError = null;
      _rateError = null;
    });
    try {
      await ref
          .read(jobsRepositoryProvider)
          .setLabor(
            widget.job.id,
            Labor(
              hours: Quantity.tryParse(_hours.text)!,
              rate: Money.tryParse(_rate.text)!,
            ),
          );
      ref.invalidate(projectJobsProvider(widget.projectId));
      if (!mounted) return;
      AppSnackbars.show(context, _isAdd ? 'Labor added' : 'Labor updated');
      Navigator.of(context).pop(true);
    } on AppException catch (error) {
      if (!mounted) return;
      setState(() {
        _submitting = false;
        _errorMessage = error.message;
      });
    } catch (_) {
      if (!mounted) return;
      setState(() {
        _submitting = false;
        _errorMessage = 'Something went wrong.';
      });
    }
  }

  Future<void> _remove() async {
    final previous = widget.job.labor;
    if (previous == null) return;
    Navigator.of(context).pop(true);
    try {
      await ref.read(jobsRepositoryProvider).setLabor(widget.job.id, null);
      ref.invalidate(projectJobsProvider(widget.projectId));
      if (!mounted) return;
      AppSnackbars.showUndo(
        context,
        'Labor removed',
        onUndo: () async {
          await ref
              .read(jobsRepositoryProvider)
              .setLabor(widget.job.id, previous);
          ref.invalidate(projectJobsProvider(widget.projectId));
        },
      );
    } on AppException catch (error) {
      if (!mounted) return;
      AppSnackbars.show(context, error.message);
    } catch (_) {
      if (!mounted) return;
      AppSnackbars.show(context, 'Something went wrong.');
    }
  }

  String? _preview() {
    final hours = Quantity.tryParse(_hours.text);
    final rate = Money.tryParse(_rate.text);
    if (hours == null || rate == null) return null;
    final total = Money(laborTotal(hours, rate.cents));
    return '${hours.format()} hrs × ${rate.format()} = ${total.format()}';
  }

  @override
  Widget build(BuildContext context) {
    final noRateHint = _isAdd && widget.prefilledRate == null
        ? 'Set a labor rate on the Pricing page to fill this in.'
        : null;
    final preview = _preview();

    return FormSheetScaffold(
      title: _isAdd ? 'Add labor' : 'Edit labor',
      primaryLabel: _isAdd ? 'Add labor' : 'Save',
      isSubmitting: _submitting,
      readOnly: widget.readOnly,
      onCancel: _cancel,
      onPrimary: _save,
      bottom: widget.readOnly || _isAdd
          ? null
          : TextButton(
              onPressed: _submitting ? null : _remove,
              style: TextButton.styleFrom(
                foregroundColor: Theme.of(context).colorScheme.error,
              ),
              child: const Text('Remove labor'),
            ),
      fields: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          TextField(
            controller: _hours,
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
            textInputAction: TextInputAction.next,
            enabled: !_submitting && !widget.readOnly,
            decoration: InputDecoration(
              labelText: 'Hours',
              errorText: _hoursError,
            ),
            onChanged: (_) => setState(() => _hoursError = null),
          ),
          const SizedBox(height: 16),
          TextField(
            controller: _rate,
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
            textInputAction: TextInputAction.done,
            enabled: !_submitting && !widget.readOnly,
            decoration: InputDecoration(
              labelText: 'Rate per hour',
              errorText: _rateError,
              helperText: noRateHint,
              helperMaxLines: 2,
            ),
            onChanged: (_) => setState(() => _rateError = null),
            onSubmitted: widget.readOnly ? null : (_) => _save(),
          ),
          if (preview != null) ...[
            const SizedBox(height: 12),
            Text(
              preview,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: Theme.of(context).colorScheme.onSurfaceVariant,
              ),
            ),
          ],
          if (_errorMessage != null) ...[
            const SizedBox(height: 16),
            Text(
              _errorMessage!,
              style: TextStyle(color: Theme.of(context).colorScheme.error),
            ),
          ],
        ],
      ),
    );
  }
}

String _moneyInput(int cents) {
  final dollars = cents ~/ 100;
  final remainder = cents % 100;
  if (remainder == 0) return dollars.toString();
  if (remainder % 10 == 0) return '$dollars.${remainder ~/ 10}';
  return '$dollars.${remainder.toString().padLeft(2, '0')}';
}
