import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'package:app/core/domain/app_exception.dart';
import 'package:app/core/domain/business_time.dart';
import 'package:app/core/utils/providers.dart';
import 'package:app/features/business/presentation/controllers/current_business.dart';
import 'package:app/features/clients/application/client_intake_service.dart';
import 'package:app/features/clients/data/models.dart';
import 'package:app/features/clients/domain/client.dart';
import 'package:app/features/clients/presentation/controllers/clients_table.dart';
import 'package:app/features/clients/presentation/models/client_form_state.dart';
import 'package:app/features/clients/presentation/validators/client_validators.dart';
import 'package:app/features/scheduling/domain/appointment_draft.dart';
import 'package:app/features/scheduling/presentation/controllers/client_appointment.dart';
import 'package:app/features/scheduling/presentation/validators/appointment_validators.dart';

part 'client_form.g.dart';

@riverpod
class ClientFormController extends _$ClientFormController {
  late ClientFormState _initial;
  Client? _savedClient;

  Client? get savedClient => _savedClient;

  @override
  ClientFormState build({Client? client}) {
    _initial = client == null
        ? const ClientFormState()
        : ClientFormState.fromClient(client);
    return _initial;
  }

  bool get isDirty =>
      state.fullName != _initial.fullName ||
      state.phone != _initial.phone ||
      state.email != _initial.email ||
      state.street != _initial.street ||
      state.city != _initial.city ||
      state.state != _initial.state ||
      state.zip != _initial.zip ||
      state.appointmentOpen != _initial.appointmentOpen ||
      state.appointmentDraft != _initial.appointmentDraft;

  void setFullName(String value) {
    state = state.copyWith(fullName: value);
    _revalidate();
  }

  void setPhone(String value) {
    state = state.copyWith(phone: value);
    _revalidate();
  }

  void setEmail(String value) {
    state = state.copyWith(email: value);
    _revalidate();
  }

  void setStreet(String value) {
    state = state.copyWith(street: value);
    _revalidate();
  }

  void setCity(String value) {
    state = state.copyWith(city: value);
    _revalidate();
  }

  void setStateCode(String value) {
    state = state.copyWith(state: value.toUpperCase());
    _revalidate();
  }

  void setZip(String value) {
    state = state.copyWith(zip: value);
    _revalidate();
  }

  void openAppointment() {
    final business = ref.read(currentBusinessProvider).value;
    final now = ref.read(clockProvider).now();
    final timeZone = business?.timezone ?? 'America/New_York';
    final tomorrow = BusinessTime(timeZone).tomorrowDate(now);
    state = state.copyWith(
      appointmentOpen: true,
      appointmentDraft: AppointmentDraft(
        date: tomorrow,
        startHour: AppointmentValidators.defaultStartHour,
        startMinute: AppointmentValidators.defaultStartMinute,
        durationMinutes: AppointmentValidators.snapDuration(
          business?.defaultOnsiteMinutes ??
              AppointmentValidators.defaultDurationMinutes,
        ),
      ),
      appointmentDateError: null,
      appointmentTimeError: null,
      appointmentDurationError: null,
      appointmentNotesError: null,
    );
  }

  void clearAppointment() {
    state = state.copyWith(
      appointmentOpen: false,
      appointmentDraft: null,
      appointmentDateError: null,
      appointmentTimeError: null,
      appointmentDurationError: null,
      appointmentNotesError: null,
    );
  }

  void setAppointmentDate(DateTime date) {
    final draft = state.appointmentDraft;
    if (draft == null) return;
    state = state.copyWith(appointmentDraft: draft.copyWith(date: date));
    _revalidate();
  }

  void setAppointmentStart(int hour, int minute) {
    final draft = state.appointmentDraft;
    if (draft == null) return;
    state = state.copyWith(
      appointmentDraft: draft.copyWith(startHour: hour, startMinute: minute),
    );
    _revalidate();
  }

  void setAppointmentDuration(int minutes) {
    final draft = state.appointmentDraft;
    if (draft == null) return;
    state = state.copyWith(
      appointmentDraft: draft.copyWith(durationMinutes: minutes),
    );
    _revalidate();
  }

  void setAppointmentNotes(String notes) {
    final draft = state.appointmentDraft;
    if (draft == null) return;
    state = state.copyWith(appointmentDraft: draft.copyWith(notes: notes));
    _revalidate();
  }

  /// Returns true when the save succeeded and the sheet should close.
  Future<bool> submit() async {
    final errors = _fieldErrors();
    if (errors.hasAny) {
      state = state.copyWith(
        submitted: true,
        isSubmitting: false,
        nameError: errors.name,
        phoneError: errors.phone,
        emailError: errors.email,
        addressError: errors.address,
        stateError: errors.state,
        zipError: errors.zip,
        appointmentDateError: errors.appointmentDate,
        appointmentTimeError: errors.appointmentTime,
        appointmentDurationError: errors.appointmentDuration,
        appointmentNotesError: errors.appointmentNotes,
      );
      return false;
    }

    state = state.copyWith(
      submitted: true,
      isSubmitting: true,
      errorMessage: null,
    );
    try {
      final wasAdd = state.isAdd;
      final timeZone =
          ref.read(currentBusinessProvider).value?.timezone ??
          'America/New_York';
      final result = await ref
          .read(clientIntakeServiceProvider)
          .save(
            isAdd: wasAdd,
            create: wasAdd ? _toCreateCommand() : null,
            update: wasAdd ? null : _toUpdateCommand(),
            draft: state.appointmentOpen ? state.appointmentDraft : null,
            timeZone: timeZone,
          );
      if (wasAdd) {
        ref.read(clientsTableControllerProvider.notifier).resetToFirstPage();
      }
      ref.invalidate(allClientsProvider);
      ref.invalidate(clientAppointmentProvider(result.client.id));

      _savedClient = result.client;
      if (!result.ok) {
        final saved = ClientFormState.fromClient(result.client);
        _initial = saved;
        state = state.copyWith(
          mode: ClientFormMode.edit,
          clientId: result.client.id,
          isSubmitting: false,
          errorMessage:
              "Client saved, but the appointment wasn't added: "
              '${result.appointmentError}',
        );
        return false;
      }
      return true;
    } on AppException catch (error) {
      state = state.copyWith(isSubmitting: false, errorMessage: error.message);
      return false;
    } catch (_) {
      state = state.copyWith(
        isSubmitting: false,
        errorMessage: 'Something went wrong.',
      );
      return false;
    }
  }

  void _revalidate() {
    if (!state.submitted) return;
    final errors = _fieldErrors();
    state = state.copyWith(
      nameError: errors.name,
      phoneError: errors.phone,
      emailError: errors.email,
      addressError: errors.address,
      stateError: errors.state,
      zipError: errors.zip,
      appointmentDateError: errors.appointmentDate,
      appointmentTimeError: errors.appointmentTime,
      appointmentDurationError: errors.appointmentDuration,
      appointmentNotesError: errors.appointmentNotes,
    );
  }

  _FieldErrors _fieldErrors() {
    final contact = ClientValidators.contact(
      phone: state.phone,
      email: state.email,
    );
    final draft = state.appointmentDraft;
    return _FieldErrors(
      name: ClientValidators.name(state.fullName),
      phone: ClientValidators.phone(state.phone) ?? contact,
      email: ClientValidators.email(state.email) ?? contact,
      address: ClientValidators.address(
        street: state.street,
        city: state.city,
        state: state.state,
        zip: state.zip,
      ),
      state: ClientValidators.state(state.state),
      zip: ClientValidators.zip(state.zip),
      appointmentDate: state.appointmentOpen
          ? AppointmentValidators.date(draft?.date)
          : null,
      appointmentTime: state.appointmentOpen
          ? AppointmentValidators.startTime(
              hour: draft?.startHour,
              minute: draft?.startMinute,
            )
          : null,
      appointmentDuration: state.appointmentOpen
          ? AppointmentValidators.duration(draft?.durationMinutes)
          : null,
      appointmentNotes: state.appointmentOpen
          ? AppointmentValidators.notes(draft?.notes)
          : null,
    );
  }

  CreateClientCommand _toCreateCommand() {
    return CreateClientCommand(
      fullName: state.fullName,
      email: state.email,
      phone: state.phone,
      street: state.street,
      city: state.city,
      state: state.state,
      zip: state.zip,
    );
  }

  UpdateClientCommand _toUpdateCommand() {
    return UpdateClientCommand(
      id: state.clientId!,
      fullName: state.fullName,
      email: state.email,
      phone: state.phone,
      street: state.street,
      city: state.city,
      state: state.state,
      zip: state.zip,
    );
  }
}

class _FieldErrors {
  const _FieldErrors({
    this.name,
    this.phone,
    this.email,
    this.address,
    this.state,
    this.zip,
    this.appointmentDate,
    this.appointmentTime,
    this.appointmentDuration,
    this.appointmentNotes,
  });

  final String? name;
  final String? phone;
  final String? email;
  final String? address;
  final String? state;
  final String? zip;
  final String? appointmentDate;
  final String? appointmentTime;
  final String? appointmentDuration;
  final String? appointmentNotes;

  bool get hasAny =>
      name != null ||
      phone != null ||
      email != null ||
      address != null ||
      state != null ||
      zip != null ||
      appointmentDate != null ||
      appointmentTime != null ||
      appointmentDuration != null ||
      appointmentNotes != null;
}
