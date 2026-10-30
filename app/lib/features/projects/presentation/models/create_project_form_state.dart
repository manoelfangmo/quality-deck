import 'package:freezed_annotation/freezed_annotation.dart';

import 'package:app/features/clients/domain/client.dart';

part 'create_project_form_state.freezed.dart';

@freezed
abstract class CreateProjectFormState with _$CreateProjectFormState {
  const CreateProjectFormState._();

  const factory CreateProjectFormState({
    Client? client,
    @Default('') String street,
    @Default('') String city,
    @Default('') String state,
    @Default('') String zip,
    @Default('') String title,
    @Default(false) bool titleEdited,
    @Default(false) bool addressEdited,
    @Default(false) bool isSubmitting,
    @Default(false) bool submitted,
    String? errorMessage,
    String? clientError,
    String? streetError,
    String? cityError,
    String? stateError,
    String? zipError,
    String? titleError,
  }) = _CreateProjectFormState;

  bool get clientHasNoAddress => client != null && client!.address == null;

  bool get isDirty =>
      client != null ||
      street.isNotEmpty ||
      city.isNotEmpty ||
      state.isNotEmpty ||
      zip.isNotEmpty ||
      title.isNotEmpty;
}
