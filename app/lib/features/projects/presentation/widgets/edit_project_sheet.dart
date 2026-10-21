import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:app/core/utils/toasts.dart';
import 'package:app/core/widgets/adaptive_sheet.dart';
import 'package:app/core/widgets/confirm_dialog.dart';
import 'package:app/features/projects/data/models.dart';
import 'package:app/features/projects/presentation/controllers/edit_project_form.dart';

Future<bool> showEditProjectSheet(
  BuildContext context, {
  required ProjectRow row,
}) async {
  final result = await showAdaptiveFormSheet<bool>(
    context: context,
    builder: (context) => EditProjectSheet(row: row),
  );
  return result ?? false;
}

class EditProjectSheet extends ConsumerStatefulWidget {
  const EditProjectSheet({required this.row, super.key});

  final ProjectRow row;

  @override
  ConsumerState<EditProjectSheet> createState() => _EditProjectSheetState();
}

class _EditProjectSheetState extends ConsumerState<EditProjectSheet> {
  late final TextEditingController _title;
  late final TextEditingController _street;
  late final TextEditingController _city;
  late final TextEditingController _state;
  late final TextEditingController _zip;

  @override
  void initState() {
    super.initState();
    _title = TextEditingController(text: widget.row.title);
    _street = TextEditingController(text: widget.row.siteAddress.street);
    _city = TextEditingController(text: widget.row.siteAddress.city);
    _state = TextEditingController(text: widget.row.siteAddress.state);
    _zip = TextEditingController(text: widget.row.siteAddress.zip);
  }

  @override
  void dispose() {
    _title.dispose();
    _street.dispose();
    _city.dispose();
    _state.dispose();
    _zip.dispose();
    super.dispose();
  }

  EditProjectFormController get _form =>
      ref.read(editProjectFormControllerProvider(widget.row).notifier);

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
    final saved = await _form.submit();
    if (!saved || !mounted) return;
    AppSnackbars.show(context, 'Project updated');
    Navigator.of(context).pop(true);
  }

  @override
  Widget build(BuildContext context) {
    final form = ref.watch(editProjectFormControllerProvider(widget.row));

    return FormSheetScaffold(
      title: 'Edit project',
      primaryLabel: 'Save',
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
          TextField(
            controller: _street,
            textInputAction: TextInputAction.next,
            textCapitalization: TextCapitalization.words,
            enabled: !form.isSubmitting,
            decoration: InputDecoration(
              labelText: 'Street',
              errorText: form.streetError,
            ),
            onChanged: _form.setStreet,
          ),
          const SizedBox(height: 16),
          TextField(
            controller: _city,
            textInputAction: TextInputAction.next,
            textCapitalization: TextCapitalization.words,
            enabled: !form.isSubmitting,
            decoration: InputDecoration(
              labelText: 'City',
              errorText: form.cityError,
            ),
            onChanged: _form.setCity,
          ),
          const SizedBox(height: 16),
          TextField(
            controller: _state,
            textInputAction: TextInputAction.next,
            textCapitalization: TextCapitalization.characters,
            enabled: !form.isSubmitting,
            inputFormatters: [
              FilteringTextInputFormatter.allow(RegExp(r'[a-zA-Z]')),
              LengthLimitingTextInputFormatter(2),
              TextInputFormatter.withFunction((oldValue, newValue) {
                return newValue.copyWith(text: newValue.text.toUpperCase());
              }),
            ],
            decoration: InputDecoration(
              labelText: 'State',
              errorText: form.stateError,
            ),
            onChanged: _form.setStateCode,
          ),
          const SizedBox(height: 16),
          TextField(
            controller: _zip,
            keyboardType: TextInputType.number,
            textInputAction: TextInputAction.done,
            enabled: !form.isSubmitting,
            inputFormatters: [
              FilteringTextInputFormatter.allow(RegExp(r'[0-9-]')),
              LengthLimitingTextInputFormatter(10),
            ],
            decoration: InputDecoration(
              labelText: 'ZIP',
              errorText: form.zipError,
            ),
            onChanged: _form.setZip,
            onSubmitted: (_) => _save(),
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
