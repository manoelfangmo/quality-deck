// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'project_actions.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(ProjectActionsController)
final projectActionsControllerProvider = ProjectActionsControllerFamily._();

final class ProjectActionsControllerProvider
    extends $NotifierProvider<ProjectActionsController, ProjectActionState> {
  ProjectActionsControllerProvider._({
    required ProjectActionsControllerFamily super.from,
    required String super.argument,
  }) : super(
         retry: null,
         name: r'projectActionsControllerProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$projectActionsControllerHash();

  @override
  String toString() {
    return r'projectActionsControllerProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  ProjectActionsController create() => ProjectActionsController();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(ProjectActionState value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<ProjectActionState>(value),
    );
  }

  @override
  bool operator ==(Object other) {
    return other is ProjectActionsControllerProvider &&
        other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$projectActionsControllerHash() =>
    r'2b9f88f4268a9417b0668bf4160f3b4fa7dd13ba';

final class ProjectActionsControllerFamily extends $Family
    with
        $ClassFamilyOverride<
          ProjectActionsController,
          ProjectActionState,
          ProjectActionState,
          ProjectActionState,
          String
        > {
  ProjectActionsControllerFamily._()
    : super(
        retry: null,
        name: r'projectActionsControllerProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  ProjectActionsControllerProvider call(String projectId) =>
      ProjectActionsControllerProvider._(argument: projectId, from: this);

  @override
  String toString() => r'projectActionsControllerProvider';
}

abstract class _$ProjectActionsController
    extends $Notifier<ProjectActionState> {
  late final _$args = ref.$arg as String;
  String get projectId => _$args;

  ProjectActionState build(String projectId);
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref = this.ref as $Ref<ProjectActionState, ProjectActionState>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<ProjectActionState, ProjectActionState>,
              ProjectActionState,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, () => build(_$args));
  }
}
