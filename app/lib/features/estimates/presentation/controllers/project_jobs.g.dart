// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'project_jobs.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(projectJobs)
final projectJobsProvider = ProjectJobsFamily._();

final class ProjectJobsProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<JobWithLines>>,
          List<JobWithLines>,
          FutureOr<List<JobWithLines>>
        >
    with
        $FutureModifier<List<JobWithLines>>,
        $FutureProvider<List<JobWithLines>> {
  ProjectJobsProvider._({
    required ProjectJobsFamily super.from,
    required String super.argument,
  }) : super(
         retry: null,
         name: r'projectJobsProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$projectJobsHash();

  @override
  String toString() {
    return r'projectJobsProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $FutureProviderElement<List<JobWithLines>> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<List<JobWithLines>> create(Ref ref) {
    final argument = this.argument as String;
    return projectJobs(ref, argument);
  }

  @override
  bool operator ==(Object other) {
    return other is ProjectJobsProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$projectJobsHash() => r'c1395d5b191c02e3505fe4ab81506746a87a5036';

final class ProjectJobsFamily extends $Family
    with $FunctionalFamilyOverride<FutureOr<List<JobWithLines>>, String> {
  ProjectJobsFamily._()
    : super(
        retry: null,
        name: r'projectJobsProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  ProjectJobsProvider call(String projectId) =>
      ProjectJobsProvider._(argument: projectId, from: this);

  @override
  String toString() => r'projectJobsProvider';
}
