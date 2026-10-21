import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:app/core/constants/breakpoints.dart';
import 'package:app/core/domain/phone.dart';
import 'package:app/core/utils/toasts.dart';
import 'package:app/core/widgets/confirm_dialog.dart';
import 'package:app/core/widgets/loading_button.dart';
import 'package:app/features/clients/domain/client.dart';
import 'package:app/features/clients/presentation/controllers/client_form.dart';
import 'package:app/features/clients/presentation/models/client_form_state.dart';
import 'package:app/features/scheduling/presentation/widgets/add_appointment_section.dart';
import 'package:app/features/scheduling/presentation/widgets/client_appointment_section.dart';

Future<Client?> showClientForm(BuildContext context, {Client? client}) async {
  final wide = MediaQuery.sizeOf(context).width >= Breakpoints.wide;
  if (wide) {
    return showDialog<Client>(
      context: context,
      barrierDismissible: false,
      builder: (context) => ClientFormSheet(client: client),
    );
  }

  final height = MediaQuery.sizeOf(context).height;
  return showModalBottomSheet<Client>(
    context: context,
    isScrollControlled: true,
    enableDrag: false,
    isDismissible: false,
    useSafeArea: true,
    builder: (context) => SizedBox(
      height: height,
      child: ClientFormSheet(client: client),
    ),
  );
}

class ClientFormSheet extends ConsumerStatefulWidget {
  const ClientFormSheet({this.client, super.key});

  final Client? client;

  @override
  ConsumerState<ClientFormSheet> createState() => _ClientFormSheetState();
}

class _ClientFormSheetState extends ConsumerState<ClientFormSheet> {
  late final TextEditingController _name;
  late final TextEditingController _phone;
  late final TextEditingController _email;
  late final TextEditingController _street;
  late final TextEditingController _city;
  late final TextEditingController _state;
  late final TextEditingController _zip;

  @override
  void initState() {
    super.initState();
    final initial = widget.client == null
        ? const ClientFormState()
        : ClientFormState.fromClient(widget.client!);
    _name = TextEditingController(text: initial.fullName);
    _phone = TextEditingController(text: initial.phone);
    _email = TextEditingController(text: initial.email);
    _street = TextEditingController(text: initial.street);
    _city = TextEditingController(text: initial.city);
    _state = TextEditingController(text: initial.state);
    _zip = TextEditingController(text: initial.zip);
  }

  @override
  void dispose() {
    _name.dispose();
    _phone.dispose();
    _email.dispose();
    _street.dispose();
    _city.dispose();
    _state.dispose();
    _zip.dispose();
    super.dispose();
  }

  ClientFormController get _form =>
      ref.read(clientFormControllerProvider(client: widget.client).notifier);

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
    if (mounted) Navigator.of(context).pop();
  }

  Future<void> _save() async {
    final adding = ref
        .read(clientFormControllerProvider(client: widget.client))
        .isAdd;
    final addingAppointment = ref
        .read(clientFormControllerProvider(client: widget.client))
        .appointmentOpen;
    final saved = await _form.submit();
    if (!saved || !mounted) return;
    final message = adding
        ? (addingAppointment
              ? 'Client and appointment added'
              : 'Client added')
        : (addingAppointment ? 'Appointment added' : 'Client updated');
    AppSnackbars.show(context, message);
    Navigator.of(context).pop(_form.savedClient);
  }

  Widget _appointmentSection(ClientFormState form) {
    final addSection = AddAppointmentSection(
      isOpen: form.appointmentOpen,
      enabled: !form.isSubmitting,
      draft: form.appointmentDraft,
      onOpen: _form.openAppointment,
      onClear: _form.clearAppointment,
      onDateChanged: _form.setAppointmentDate,
      onStartChanged: _form.setAppointmentStart,
      onDurationChanged: _form.setAppointmentDuration,
      onNotesChanged: _form.setAppointmentNotes,
      dateError: form.appointmentDateError,
      timeError: form.appointmentTimeError,
      durationError: form.appointmentDurationError,
      notesError: form.appointmentNotesError,
    );

    final clientId = form.clientId;
    if (form.isAdd || clientId == null) return addSection;
    return ClientAppointmentSection(clientId: clientId, addSection: addSection);
  }

  @override
  Widget build(BuildContext context) {
    final form = ref.watch(clientFormControllerProvider(client: widget.client));
    final wide = MediaQuery.sizeOf(context).width >= Breakpoints.wide;
    final title = form.isAdd ? 'Add client' : 'Edit client';

    final fields = AutofillGroup(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          TextField(
            controller: _name,
            textInputAction: TextInputAction.next,
            textCapitalization: TextCapitalization.words,
            autofillHints: const [],
            enabled: !form.isSubmitting,
            decoration: InputDecoration(
              labelText: 'Full name',
              errorText: form.nameError,
            ),
            onChanged: _form.setFullName,
          ),
          const SizedBox(height: 16),
          TextField(
            controller: _phone,
            keyboardType: TextInputType.phone,
            textInputAction: TextInputAction.next,
            autofillHints: const [],
            enableSuggestions: false,
            autocorrect: false,
            enabled: !form.isSubmitting,
            inputFormatters: const [_UsPhoneInputFormatter()],
            decoration: InputDecoration(
              labelText: 'Phone',
              errorText: form.phoneError,
            ),
            onChanged: _form.setPhone,
          ),
          const SizedBox(height: 16),
          TextField(
            controller: _email,
            keyboardType: TextInputType.emailAddress,
            textInputAction: TextInputAction.next,
            autofillHints: const [],
            autocorrect: false,
            enableSuggestions: false,
            enabled: !form.isSubmitting,
            decoration: InputDecoration(
              labelText: 'Email',
              errorText: form.emailError,
            ),
            onChanged: _form.setEmail,
          ),
          const SizedBox(height: 16),
          TextField(
            controller: _street,
            textInputAction: TextInputAction.next,
            textCapitalization: TextCapitalization.words,
            autofillHints: const [],
            enabled: !form.isSubmitting,
            decoration: InputDecoration(
              labelText: 'Street',
              errorText: form.addressError,
            ),
            onChanged: _form.setStreet,
          ),
          const SizedBox(height: 16),
          TextField(
            controller: _city,
            textInputAction: TextInputAction.next,
            textCapitalization: TextCapitalization.words,
            autofillHints: const [],
            enabled: !form.isSubmitting,
            decoration: InputDecoration(
              labelText: 'City',
              errorText: form.addressError,
            ),
            onChanged: _form.setCity,
          ),
          const SizedBox(height: 16),
          TextField(
            controller: _state,
            textInputAction: TextInputAction.next,
            textCapitalization: TextCapitalization.characters,
            autofillHints: const [],
            enableSuggestions: false,
            autocorrect: false,
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
            autofillHints: const [],
            enableSuggestions: false,
            autocorrect: false,
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
          const SizedBox(height: 24),
          _appointmentSection(form),
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
              label: 'Save',
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
        title,
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

class _UsPhoneInputFormatter extends TextInputFormatter {
  const _UsPhoneInputFormatter();

  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    final formatted = Phone.formatPartial(newValue.text);
    return TextEditingValue(
      text: formatted,
      selection: TextSelection.collapsed(offset: formatted.length),
    );
  }
}
