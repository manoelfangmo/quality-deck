import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:app/core/constants/breakpoints.dart';
import 'package:app/core/utils/toasts.dart';
import 'package:app/core/widgets/confirm_dialog.dart';
import 'package:app/core/widgets/loading_button.dart';
import 'package:app/features/projects/presentation/controllers/create_project_form.dart';
import 'package:app/features/projects/presentation/models/create_project_form_state.dart';
import 'package:app/features/projects/presentation/routes.dart';
import 'package:app/features/projects/presentation/widgets/client_picker.dart';

Future<void> showCreateProjectSheet(BuildContext context) async {
  final wide = MediaQuery.sizeOf(context).width >= Breakpoints.wide;
  if (wide) {
    await showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (context) => const CreateProjectSheet(),
    );
    return;
  }

  final height = MediaQuery.sizeOf(context).height;
  await showModalBottomSheet<void>(
    context: context,
    isScrollControlled: true,
    enableDrag: false,
    isDismissible: false,
    useSafeArea: true,
    builder: (context) => SizedBox(
      height: height,
      child: const CreateProjectSheet(),
    ),
  );
}

class CreateProjectSheet extends ConsumerStatefulWidget {
  const CreateProjectSheet({super.key});

  @override
  ConsumerState<CreateProjectSheet> createState() => _CreateProjectSheetState();
}

class _CreateProjectSheetState extends ConsumerState<CreateProjectSheet> {
  late final TextEditingController _street;
  late final TextEditingController _city;
  late final TextEditingController _state;
  late final TextEditingController _zip;
  late final TextEditingController _title;

  @override
  void initState() {
    super.initState();
    _street = TextEditingController();
    _city = TextEditingController();
    _state = TextEditingController();
    _zip = TextEditingController();
    _title = TextEditingController();
  }

  @override
  void dispose() {
    _street.dispose();
    _city.dispose();
    _state.dispose();
    _zip.dispose();
    _title.dispose();
    super.dispose();
  }

  CreateProjectFormController get _form =>
      ref.read(createProjectFormControllerProvider.notifier);

  void _syncControllers(CreateProjectFormState form) {
    if (_street.text != form.street) _street.text = form.street;
    if (_city.text != form.city) _city.text = form.city;
    if (_state.text != form.state) _state.text = form.state;
    if (_zip.text != form.zip) _zip.text = form.zip;
    if (_title.text != form.title) _title.text = form.title;
  }

  Future<void> _cancel() async {
    if (_form.isDirty) {
      final discard = await showConfirmDialog(
        context: context,
        title: 'Discard this project?',
        body: 'Your entries will be lost.',
        confirmLabel: 'Discard',
      );
      if (!discard) return;
    }
    if (mounted) Navigator.of(context).pop();
  }

  Future<void> _save() async {
    final id = await _form.submit();
    if (id == null || !mounted) return;
    final router = GoRouter.of(context);
    AppSnackbars.show(context, 'Project created');
    Navigator.of(context).pop();
    router.go(ProjectRoute(id).location);
  }

  @override
  Widget build(BuildContext context) {
    final form = ref.watch(createProjectFormControllerProvider);
    ref.listen(createProjectFormControllerProvider, (_, next) {
      _syncControllers(next);
    });
    final wide = MediaQuery.sizeOf(context).width >= Breakpoints.wide;

    final fields = Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        ClientPicker(
          client: form.client,
          enabled: !form.isSubmitting,
          errorText: form.clientError,
          onPicked: _form.pickClient,
          onCleared: _form.clearClient,
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
            helperText: form.clientHasNoAddress
                ? 'This client has no address on file. Enter the site address.'
                : null,
            helperMaxLines: 2,
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
          textInputAction: TextInputAction.next,
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
        ),
        const SizedBox(height: 16),
        TextField(
          controller: _title,
          textInputAction: TextInputAction.done,
          textCapitalization: TextCapitalization.sentences,
          enabled: !form.isSubmitting,
          decoration: InputDecoration(
            labelText: 'Title',
            errorText: form.titleError,
          ),
          onChanged: _form.setTitle,
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
    );

    final actions = Padding(
      padding: const EdgeInsets.fromLTRB(24, 8, 24, 16),
      child: Row(
        children: [
          Expanded(
            child: OutlinedButton(
              onPressed: form.isSubmitting ? null : _cancel,
              child: const Text('Cancel'),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: LoadingButton(
              label: 'Create project',
              isLoading: form.isSubmitting,
              onPressed: _save,
            ),
          ),
        ],
      ),
    );

    final titleWidget = Padding(
      padding: const EdgeInsets.fromLTRB(24, 20, 24, 8),
      child: Text(
        'New project',
        textAlign: TextAlign.center,
        style: Theme.of(context).textTheme.titleLarge,
      ),
    );

    final body = wide
        ? Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              titleWidget,
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
              titleWidget,
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
      child: SafeArea(
        child: PopScope(
          canPop: !form.isSubmitting,
          onPopInvokedWithResult: (didPop, result) async {
            if (didPop || form.isSubmitting) return;
            await _cancel();
          },
          child: body,
        ),
      ),
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
