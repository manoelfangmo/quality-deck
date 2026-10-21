import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'package:app/core/domain/app_exception.dart';
import 'package:app/features/projects/data/models.dart';
import 'package:app/features/projects/data/projects_repository.dart';
import 'package:app/features/projects/presentation/controllers/project.dart';
import 'package:app/features/projects/presentation/controllers/projects_table.dart';
import 'package:app/features/projects/presentation/models/edit_project_form_state.dart';
import 'package:app/features/projects/presentation/validators/project_validators.dart';

part 'edit_project_form.g.dart';

@riverpod
class EditProjectFormController extends _$EditProjectFormController {
  late EditProjectFormState _initial;

  @override
  EditProjectFormState build(ProjectRow row) {
    _initial = EditProjectFormState.fromRow(row);
    return _initial;
  }

  bool get isDirty =>
      state.title != _initial.title ||
      state.street != _initial.street ||
      state.city != _initial.city ||
      state.state != _initial.state ||
      state.zip != _initial.zip;

  void setTitle(String value) {
    state = state.copyWith(title: value);
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

  Future<bool> submit() async {
    final errors = _fieldErrors();
    if (errors.hasAny) {
      state = state.copyWith(
        submitted: true,
        isSubmitting: false,
        titleError: errors.title,
        streetError: errors.street,
        cityError: errors.city,
        stateError: errors.state,
        zipError: errors.zip,
      );
      return false;
    }

    state = state.copyWith(
      submitted: true,
      isSubmitting: true,
      errorMessage: null,
    );
    try {
      await ref
          .read(projectsRepositoryProvider)
          .update(
            UpdateProjectCommand(
              id: state.projectId,
              title: state.title,
              siteStreet: state.street,
              siteCity: state.city,
              siteState: state.state,
              siteZip: state.zip,
            ),
          );
      ref.invalidate(projectProvider(state.projectId));
      ref.invalidate(projectRowsProvider);
      ref.invalidate(projectRowsPageProvider);
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
      titleError: errors.title,
      streetError: errors.street,
      cityError: errors.city,
      stateError: errors.state,
      zipError: errors.zip,
    );
  }

  _FieldErrors _fieldErrors() {
    return _FieldErrors(
      title: ProjectValidators.title(state.title),
      street: ProjectValidators.street(state.street),
      city: ProjectValidators.city(state.city),
      state: ProjectValidators.state(state.state),
      zip: ProjectValidators.zip(state.zip),
    );
  }
}

class _FieldErrors {
  const _FieldErrors({
    this.title,
    this.street,
    this.city,
    this.state,
    this.zip,
  });

  final String? title;
  final String? street;
  final String? city;
  final String? state;
  final String? zip;

  bool get hasAny =>
      title != null ||
      street != null ||
      city != null ||
      state != null ||
      zip != null;
}
