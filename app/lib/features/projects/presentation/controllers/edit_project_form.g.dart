// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'edit_project_form.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(EditProjectFormController)
final editProjectFormControllerProvider = EditProjectFormControllerFamily._();

final class EditProjectFormControllerProvider
    extends $NotifierProvider<EditProjectFormController, EditProjectFormState> {
  EditProjectFormControllerProvider._({
    required EditProjectFormControllerFamily super.from,
    required ProjectRow super.argument,
  }) : super(
         retry: null,
         name: r'editProjectFormControllerProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$editProjectFormControllerHash();

  @override
  String toString() {
    return r'editProjectFormControllerProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  EditProjectFormController create() => EditProjectFormController();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(EditProjectFormState value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<EditProjectFormState>(value),
    );
  }

  @override
  bool operator ==(Object other) {
    return other is EditProjectFormControllerProvider &&
        other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$editProjectFormControllerHash() =>
    r'd76906367438e5a4944268a19e139c33f19dbb49';

final class EditProjectFormControllerFamily extends $Family
    with
        $ClassFamilyOverride<
          EditProjectFormController,
          EditProjectFormState,
          EditProjectFormState,
          EditProjectFormState,
          ProjectRow
        > {
  EditProjectFormControllerFamily._()
    : super(
        retry: null,
        name: r'editProjectFormControllerProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  EditProjectFormControllerProvider call(ProjectRow row) =>
      EditProjectFormControllerProvider._(argument: row, from: this);

  @override
  String toString() => r'editProjectFormControllerProvider';
}

abstract class _$EditProjectFormController
    extends $Notifier<EditProjectFormState> {
  late final _$args = ref.$arg as ProjectRow;
  ProjectRow get row => _$args;

  EditProjectFormState build(ProjectRow row);
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref = this.ref as $Ref<EditProjectFormState, EditProjectFormState>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<EditProjectFormState, EditProjectFormState>,
              EditProjectFormState,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, () => build(_$args));
  }
}
