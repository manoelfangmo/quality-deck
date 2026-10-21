import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'package:app/core/domain/app_exception.dart';
import 'package:app/features/clients/domain/client.dart';
import 'package:app/features/projects/data/models.dart';
import 'package:app/features/projects/data/projects_repository.dart';
import 'package:app/features/projects/domain/suggested_title.dart';
import 'package:app/features/projects/presentation/controllers/projects_table.dart';
import 'package:app/features/projects/presentation/models/create_project_form_state.dart';
import 'package:app/features/projects/presentation/validators/project_validators.dart';

part 'create_project_form.g.dart';

@riverpod
class CreateProjectFormController extends _$CreateProjectFormController {
  @override
  CreateProjectFormState build() => const CreateProjectFormState();

  bool get isDirty => state.isDirty;

  void clearClient() {
    state = state.copyWith(client: null);
    _revalidate();
  }

  void pickClient(Client client) {
    final address = client.address;
    final next = state.addressEdited
        ? state.copyWith(client: client)
        : state.copyWith(
            client: client,
            street: address?.street ?? '',
            city: address?.city ?? '',
            state: address?.state ?? '',
            zip: address?.zip ?? '',
          );
    state = next;
    _syncTitle();
    _revalidate();
  }

  void setStreet(String value) {
    state = state.copyWith(street: value, addressEdited: true);
    _syncTitle();
    _revalidate();
  }

  void setCity(String value) {
    state = state.copyWith(city: value, addressEdited: true);
    _revalidate();
  }

  void setStateCode(String value) {
    state = state.copyWith(state: value.toUpperCase(), addressEdited: true);
    _revalidate();
  }

  void setZip(String value) {
    state = state.copyWith(zip: value, addressEdited: true);
    _revalidate();
  }

  void setTitle(String value) {
    state = state.copyWith(title: value, titleEdited: true);
    _revalidate();
  }

  /// Returns the new project id when the save succeeded.
  Future<String?> submit() async {
    final errors = _fieldErrors();
    if (errors.hasAny) {
      state = state.copyWith(
        submitted: true,
        isSubmitting: false,
        clientError: errors.client,
        streetError: errors.street,
        cityError: errors.city,
        stateError: errors.state,
        zipError: errors.zip,
        titleError: errors.title,
      );
      return null;
    }

    state = state.copyWith(
      submitted: true,
      isSubmitting: true,
      errorMessage: null,
    );
    try {
      final id = await ref
          .read(projectsRepositoryProvider)
          .create(_toCommand());
      ref.invalidate(projectRowsPageProvider);
      ref.invalidate(projectRowsProvider);
      ref.read(projectsTableControllerProvider.notifier).showActive();
      return id;
    } on AppException catch (error) {
      state = state.copyWith(
        isSubmitting: false,
        errorMessage: error.token == 'client_not_found'
            ? 'That client was removed. Choose another client.'
            : error.message,
      );
      return null;
    } catch (_) {
      state = state.copyWith(
        isSubmitting: false,
        errorMessage: 'Something went wrong.',
      );
      return null;
    }
  }

  void _syncTitle() {
    if (state.titleEdited) return;
    state = state.copyWith(
      title: suggestedTitle(state.client?.fullName ?? '', state.street),
    );
  }

  void _revalidate() {
    if (!state.submitted) return;
    final errors = _fieldErrors();
    state = state.copyWith(
      clientError: errors.client,
      streetError: errors.street,
      cityError: errors.city,
      stateError: errors.state,
      zipError: errors.zip,
      titleError: errors.title,
    );
  }

  _FieldErrors _fieldErrors() {
    return _FieldErrors(
      client: ProjectValidators.client(state.client),
      street: ProjectValidators.street(state.street),
      city: ProjectValidators.city(state.city),
      state: ProjectValidators.state(state.state),
      zip: ProjectValidators.zip(state.zip),
      title: ProjectValidators.title(state.title),
    );
  }

  CreateProjectCommand _toCommand() {
    return CreateProjectCommand(
      clientId: state.client!.id,
      title: state.title,
      siteStreet: state.street,
      siteCity: state.city,
      siteState: state.state,
      siteZip: state.zip,
    );
  }
}

class _FieldErrors {
  const _FieldErrors({
    this.client,
    this.street,
    this.city,
    this.state,
    this.zip,
    this.title,
  });

  final String? client;
  final String? street;
  final String? city;
  final String? state;
  final String? zip;
  final String? title;

  bool get hasAny =>
      client != null ||
      street != null ||
      city != null ||
      state != null ||
      zip != null ||
      title != null;
}
