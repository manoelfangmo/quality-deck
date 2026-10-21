import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:app/core/constants/breakpoints.dart';
import 'package:app/core/utils/toasts.dart';
import 'package:app/core/widgets/adaptive_sheet.dart';
import 'package:app/core/widgets/confirm_dialog.dart';
import 'package:app/features/estimates/domain/job.dart';
import 'package:app/features/estimates/domain/job_type.dart';
import 'package:app/features/estimates/presentation/controllers/job_form.dart';

Future<bool> showJobFormSheet(
  BuildContext context, {
  required String projectId,
  Job? job,
}) async {
  final result = await showAdaptiveFormSheet<bool>(
    context: context,
    builder: (context) => JobFormSheet(projectId: projectId, job: job),
  );
  return result ?? false;
}

class JobFormSheet extends ConsumerStatefulWidget {
  const JobFormSheet({required this.projectId, this.job, super.key});

  final String projectId;
  final Job? job;

  @override
  ConsumerState<JobFormSheet> createState() => _JobFormSheetState();
}

class _JobFormSheetState extends ConsumerState<JobFormSheet> {
  late final TextEditingController _title;
  late final TextEditingController _description;

  @override
  void initState() {
    super.initState();
    _title = TextEditingController(text: widget.job?.title ?? '');
    _description = TextEditingController(text: widget.job?.description ?? '');
  }

  @override
  void dispose() {
    _title.dispose();
    _description.dispose();
    super.dispose();
  }

  JobFormController get _form => ref.read(
    jobFormControllerProvider(projectId: widget.projectId, job: widget.job).notifier,
  );

  Future<void> _cancel() async {
    if (_form.isDirty) {
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
    final adding = widget.job == null;
    final saved = await _form.submit();
    if (!saved || !mounted) return;
    AppSnackbars.show(context, adding ? 'Job added' : 'Job updated');
    Navigator.of(context).pop(true);
  }

  @override
  Widget build(BuildContext context) {
    final form = ref.watch(
      jobFormControllerProvider(projectId: widget.projectId, job: widget.job),
    );
    final wide = MediaQuery.sizeOf(context).width >= Breakpoints.wide;

    return FormSheetScaffold(
      title: form.isAdd ? 'Add job' : 'Edit job',
      primaryLabel: form.isAdd ? 'Add job' : 'Save',
      isSubmitting: form.isSubmitting,
      onCancel: _cancel,
      onPrimary: _save,
      fields: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          TextField(
            controller: _title,
            textInputAction: TextInputAction.next,
            textCapitalization: TextCapitalization.sentences,
            enabled: !form.isSubmitting,
            decoration: InputDecoration(
              labelText: 'Title',
              errorText: form.titleError,
            ),
            onChanged: _form.setTitle,
          ),
          const SizedBox(height: 16),
          _JobTypeField(
            value: form.jobType,
            errorText: form.jobTypeError,
            enabled: !form.isSubmitting,
            wide: wide,
            onChanged: _form.setJobType,
          ),
          const SizedBox(height: 16),
          TextField(
            controller: _description,
            minLines: 2,
            maxLines: 4,
            textCapitalization: TextCapitalization.sentences,
            enabled: !form.isSubmitting,
            decoration: InputDecoration(
              labelText: 'Description',
              errorText: form.descriptionError,
            ),
            onChanged: _form.setDescription,
          ),
          if (form.errorMessage != null) ...[
            const SizedBox(height: 16),
            Text(
              form.errorMessage!,
              style: TextStyle(color: Theme.of(context).colorScheme.error),
            ),
          ],
        ],
      ),
    );
  }
}

class _JobTypeField extends StatelessWidget {
  const _JobTypeField({
    required this.value,
    required this.enabled,
    required this.wide,
    required this.onChanged,
    this.errorText,
  });

  final JobType? value;
  final String? errorText;
  final bool enabled;
  final bool wide;
  final ValueChanged<JobType?> onChanged;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        SegmentedButton<JobType>(
          segments: [
            for (final type in JobType.values)
              ButtonSegment(value: type, label: Text(type.label)),
          ],
          selected: {?value},
          emptySelectionAllowed: true,
          showSelectedIcon: false,
          onSelectionChanged: enabled
              ? (selected) => onChanged(selected.isEmpty ? null : selected.first)
              : null,
        ),
        if (errorText != null) ...[
          const SizedBox(height: 8),
          Text(
            errorText!,
            style: TextStyle(
              color: Theme.of(context).colorScheme.error,
              fontSize: 12,
            ),
          ),
        ],
      ],
    );
  }
}
