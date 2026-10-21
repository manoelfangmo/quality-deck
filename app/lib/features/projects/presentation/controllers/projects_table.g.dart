// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'projects_table.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(ProjectsTableController)
final projectsTableControllerProvider = ProjectsTableControllerProvider._();

final class ProjectsTableControllerProvider
    extends $NotifierProvider<ProjectsTableController, ProjectsTableState> {
  ProjectsTableControllerProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'projectsTableControllerProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$projectsTableControllerHash();

  @$internal
  @override
  ProjectsTableController create() => ProjectsTableController();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(ProjectsTableState value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<ProjectsTableState>(value),
    );
  }
}

String _$projectsTableControllerHash() =>
    r'c745f565528357170361441426887f67c39d6ebb';

abstract class _$ProjectsTableController extends $Notifier<ProjectsTableState> {
  ProjectsTableState build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref = this.ref as $Ref<ProjectsTableState, ProjectsTableState>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<ProjectsTableState, ProjectsTableState>,
              ProjectsTableState,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, build);
  }
}

@ProviderFor(projectRowsPage)
final projectRowsPageProvider = ProjectRowsPageFamily._();

final class ProjectRowsPageProvider
    extends
        $FunctionalProvider<
          AsyncValue<ProjectPage>,
          ProjectPage,
          FutureOr<ProjectPage>
        >
    with $FutureModifier<ProjectPage>, $FutureProvider<ProjectPage> {
  ProjectRowsPageProvider._({
    required ProjectRowsPageFamily super.from,
    required ProjectRowsPageArgs super.argument,
  }) : super(
         retry: null,
         name: r'projectRowsPageProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$projectRowsPageHash();

  @override
  String toString() {
    return r'projectRowsPageProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $FutureProviderElement<ProjectPage> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<ProjectPage> create(Ref ref) {
    final argument = this.argument as ProjectRowsPageArgs;
    return projectRowsPage(ref, argument);
  }

  @override
  bool operator ==(Object other) {
    return other is ProjectRowsPageProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$projectRowsPageHash() => r'e93f028f804f87ef3973b5a6e51a4e923216df6b';

final class ProjectRowsPageFamily extends $Family
    with $FunctionalFamilyOverride<FutureOr<ProjectPage>, ProjectRowsPageArgs> {
  ProjectRowsPageFamily._()
    : super(
        retry: null,
        name: r'projectRowsPageProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  ProjectRowsPageProvider call(ProjectRowsPageArgs args) =>
      ProjectRowsPageProvider._(argument: args, from: this);

  @override
  String toString() => r'projectRowsPageProvider';
}

@ProviderFor(projectRows)
final projectRowsProvider = ProjectRowsFamily._();

final class ProjectRowsProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<ProjectRow>>,
          List<ProjectRow>,
          FutureOr<List<ProjectRow>>
        >
    with $FutureModifier<List<ProjectRow>>, $FutureProvider<List<ProjectRow>> {
  ProjectRowsProvider._({
    required ProjectRowsFamily super.from,
    required ProjectView super.argument,
  }) : super(
         retry: null,
         name: r'projectRowsProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$projectRowsHash();

  @override
  String toString() {
    return r'projectRowsProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $FutureProviderElement<List<ProjectRow>> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<List<ProjectRow>> create(Ref ref) {
    final argument = this.argument as ProjectView;
    return projectRows(ref, argument);
  }

  @override
  bool operator ==(Object other) {
    return other is ProjectRowsProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$projectRowsHash() => r'4235a8559a67c569a3230c3f0f7e08bb62b98e53';

final class ProjectRowsFamily extends $Family
    with $FunctionalFamilyOverride<FutureOr<List<ProjectRow>>, ProjectView> {
  ProjectRowsFamily._()
    : super(
        retry: null,
        name: r'projectRowsProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  ProjectRowsProvider call(ProjectView view) =>
      ProjectRowsProvider._(argument: view, from: this);

  @override
  String toString() => r'projectRowsProvider';
}
