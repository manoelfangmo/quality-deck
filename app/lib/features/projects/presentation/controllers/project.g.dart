// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'project.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(project)
final projectProvider = ProjectFamily._();

final class ProjectProvider
    extends
        $FunctionalProvider<
          AsyncValue<ProjectRow?>,
          ProjectRow?,
          FutureOr<ProjectRow?>
        >
    with $FutureModifier<ProjectRow?>, $FutureProvider<ProjectRow?> {
  ProjectProvider._({
    required ProjectFamily super.from,
    required String super.argument,
  }) : super(
         retry: null,
         name: r'projectProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$projectHash();

  @override
  String toString() {
    return r'projectProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $FutureProviderElement<ProjectRow?> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<ProjectRow?> create(Ref ref) {
    final argument = this.argument as String;
    return project(ref, argument);
  }

  @override
  bool operator ==(Object other) {
    return other is ProjectProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$projectHash() => r'79ef8c767cab7d2f6febacb1673f9ee1b93c0e70';

final class ProjectFamily extends $Family
    with $FunctionalFamilyOverride<FutureOr<ProjectRow?>, String> {
  ProjectFamily._()
    : super(
        retry: null,
        name: r'projectProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  ProjectProvider call(String projectId) =>
      ProjectProvider._(argument: projectId, from: this);

  @override
  String toString() => r'projectProvider';
}
