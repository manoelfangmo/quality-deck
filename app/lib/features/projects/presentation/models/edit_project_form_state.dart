import 'package:freezed_annotation/freezed_annotation.dart';

import 'package:app/features/projects/data/models.dart';

part 'edit_project_form_state.freezed.dart';

@freezed
abstract class EditProjectFormState with _$EditProjectFormState {
  const factory EditProjectFormState({
    required String projectId,
    @Default('') String title,
    @Default('') String street,
    @Default('') String city,
    @Default('') String state,
    @Default('') String zip,
    @Default(false) bool isSubmitting,
    @Default(false) bool submitted,
    String? errorMessage,
    String? titleError,
    String? streetError,
    String? cityError,
    String? stateError,
    String? zipError,
  }) = _EditProjectFormState;

  factory EditProjectFormState.fromRow(ProjectRow row) {
    return EditProjectFormState(
      projectId: row.id,
      title: row.title,
      street: row.siteAddress.street,
      city: row.siteAddress.city,
      state: row.siteAddress.state,
      zip: row.siteAddress.zip,
    );
  }
}
