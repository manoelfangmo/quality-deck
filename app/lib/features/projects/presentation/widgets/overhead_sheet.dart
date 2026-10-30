import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:app/core/domain/app_exception.dart';
import 'package:app/core/domain/money.dart';
import 'package:app/core/domain/percent.dart';
import 'package:app/core/utils/toasts.dart';
import 'package:app/core/widgets/adaptive_sheet.dart';
import 'package:app/core/widgets/confirm_dialog.dart';
import 'package:app/features/estimates/domain/line_math.dart';
import 'package:app/features/estimates/presentation/validators/estimate_validators.dart';
import 'package:app/features/projects/data/projects_repository.dart';
import 'package:app/features/projects/presentation/controllers/project.dart';

Future<bool> showOverheadSheet(
  BuildContext context, {
  required String projectId,
  Percent? current,
  Percent? prefilled,
  required Money subtotal,
  bool readOnly = false,
}) async {
  final result = await showAdaptiveFormSheet<bool>(
    context: context,
    builder: (context) => OverheadSheet(
      projectId: projectId,
      current: current,
      prefilled: prefilled,
      subtotal: subtotal,
      readOnly: readOnly,
    ),
  );
  return result ?? false;
}

class OverheadSheet extends ConsumerStatefulWidget {
  const OverheadSheet({
    required this.projectId,
    this.current,
    this.prefilled,
    required this.subtotal,
    this.readOnly = false,
    super.key,
  });

  final String projectId;
  final Percent? current;
  final Percent? prefilled;
  final Money subtotal;
  final bool readOnly;

  @override
  ConsumerState<OverheadSheet> createState() => _OverheadSheetState();
}

class _OverheadSheetState extends ConsumerState<OverheadSheet> {
  late final TextEditingController _percent;
  late final String _initial;
  String? _error;
  String? _errorMessage;
  bool _submitting = false;

  bool get _isAdd => widget.current == null;

  @override
  void initState() {
    super.initState();
    final bps = widget.current?.basisPoints ?? widget.prefilled?.basisPoints;
    _initial = bps == null ? '' : _percentInput(bps);
    _percent = TextEditingController(text: _initial);
  }

  @override
  void dispose() {
    _percent.dispose();
    super.dispose();
  }

  Future<void> _cancel() async {
    if (!widget.readOnly && _percent.text != _initial) {
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
    final error = EstimateValidators.overhead(_percent.text);
    if (error != null) {
      setState(() => _error = error);
      return;
    }
    setState(() {
      _submitting = true;
      _error = null;
      _errorMessage = null;
    });
    try {
      await ref
          .read(projectsRepositoryProvider)
          .setOverhead(widget.projectId, Percent.tryParse(_percent.text));
      ref.invalidate(projectProvider(widget.projectId));
      if (!mounted) return;
      AppSnackbars.show(
        context,
        _isAdd ? 'Overhead added' : 'Overhead updated',
      );
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
    final previous = widget.current;
    if (previous == null) return;
    Navigator.of(context).pop(true);
    try {
      await ref.read(projectsRepositoryProvider).setOverhead(widget.projectId, null);
      ref.invalidate(projectProvider(widget.projectId));
      if (!mounted) return;
      AppSnackbars.showUndo(
        context,
        'Overhead removed',
        onUndo: () async {
          await ref
              .read(projectsRepositoryProvider)
              .setOverhead(widget.projectId, previous);
          ref.invalidate(projectProvider(widget.projectId));
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
    final percent = Percent.tryParse(_percent.text);
    if (percent == null) return null;
    final amount = Money(
      overheadAmount(widget.subtotal.cents, percent.basisPoints),
    );
    return '${percent.format()} of ${widget.subtotal.format()} = ${amount.format()}';
  }

  @override
  Widget build(BuildContext context) {
    final hint = _isAdd && widget.prefilled == null
        ? 'Set overhead on the Pricing page to fill this in.'
        : null;
    final preview = _preview();

    return FormSheetScaffold(
      title: _isAdd ? 'Add overhead' : 'Edit overhead',
      primaryLabel: _isAdd ? 'Add overhead' : 'Save',
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
              child: const Text('Remove overhead'),
            ),
      fields: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          TextField(
            controller: _percent,
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
            enabled: !_submitting && !widget.readOnly,
            decoration: InputDecoration(
              labelText: 'Percentage',
              suffixText: '%',
              errorText: _error,
              helperText: hint,
              helperMaxLines: 2,
            ),
            onChanged: (_) => setState(() => _error = null),
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

String _percentInput(int basisPoints) {
  final whole = basisPoints ~/ 100;
  final fraction = basisPoints % 100;
  if (fraction == 0) return whole.toString();
  if (fraction % 10 == 0) return '$whole.${fraction ~/ 10}';
  return '$whole.${fraction.toString().padLeft(2, '0')}';
}
