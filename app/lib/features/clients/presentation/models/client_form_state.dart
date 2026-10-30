import 'package:freezed_annotation/freezed_annotation.dart';

import 'package:app/core/domain/phone.dart';
import 'package:app/features/clients/domain/client.dart';
import 'package:app/features/scheduling/domain/appointment_draft.dart';

part 'client_form_state.freezed.dart';

enum ClientFormMode { add, edit }

@freezed
abstract class ClientFormState with _$ClientFormState {
  const ClientFormState._();

  const factory ClientFormState({
    @Default(ClientFormMode.add) ClientFormMode mode,
    String? clientId,
    @Default('') String fullName,
    @Default('') String phone,
    @Default('') String email,
    @Default('') String street,
    @Default('') String city,
    @Default('') String state,
    @Default('') String zip,
    @Default(false) bool appointmentOpen,
    AppointmentDraft? appointmentDraft,
    @Default(false) bool isSubmitting,
    @Default(false) bool submitted,
    String? errorMessage,
    String? nameError,
    String? phoneError,
    String? emailError,
    String? addressError,
    String? stateError,
    String? zipError,
    String? appointmentDateError,
    String? appointmentTimeError,
    String? appointmentDurationError,
    String? appointmentNotesError,
  }) = _ClientFormState;

  factory ClientFormState.fromClient(Client client) {
    return ClientFormState(
      mode: ClientFormMode.edit,
      clientId: client.id,
      fullName: client.fullName,
      phone: client.phone == null ? '' : Phone.format(client.phone!),
      email: client.email ?? '',
      street: client.address?.street ?? '',
      city: client.address?.city ?? '',
      state: client.address?.state ?? '',
      zip: client.address?.zip ?? '',
    );
  }

  bool get isAdd => mode == ClientFormMode.add;
}
