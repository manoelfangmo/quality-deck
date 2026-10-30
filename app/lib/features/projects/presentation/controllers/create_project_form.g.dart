// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'create_project_form.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(CreateProjectFormController)
final createProjectFormControllerProvider =
    CreateProjectFormControllerProvider._();

final class CreateProjectFormControllerProvider
    extends
        $NotifierProvider<CreateProjectFormController, CreateProjectFormState> {
  CreateProjectFormControllerProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'createProjectFormControllerProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$createProjectFormControllerHash();

  @$internal
  @override
  CreateProjectFormController create() => CreateProjectFormController();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(CreateProjectFormState value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<CreateProjectFormState>(value),
    );
  }
}

String _$createProjectFormControllerHash() =>
    r'999384b9db3d6f6e5aafc7c795db9ac817b49206';

abstract class _$CreateProjectFormController
    extends $Notifier<CreateProjectFormState> {
  CreateProjectFormState build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref =
        this.ref as $Ref<CreateProjectFormState, CreateProjectFormState>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<CreateProjectFormState, CreateProjectFormState>,
              CreateProjectFormState,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, build);
  }
}
