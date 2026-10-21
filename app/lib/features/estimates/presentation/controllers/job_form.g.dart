// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'job_form.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(JobFormController)
final jobFormControllerProvider = JobFormControllerFamily._();

final class JobFormControllerProvider
    extends $NotifierProvider<JobFormController, JobFormState> {
  JobFormControllerProvider._({
    required JobFormControllerFamily super.from,
    required ({String projectId, Job? job}) super.argument,
  }) : super(
         retry: null,
         name: r'jobFormControllerProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$jobFormControllerHash();

  @override
  String toString() {
    return r'jobFormControllerProvider'
        ''
        '$argument';
  }

  @$internal
  @override
  JobFormController create() => JobFormController();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(JobFormState value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<JobFormState>(value),
    );
  }

  @override
  bool operator ==(Object other) {
    return other is JobFormControllerProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$jobFormControllerHash() => r'e9b1e156a4b70bd7e8c218302de0047c6226dc9c';

final class JobFormControllerFamily extends $Family
    with
        $ClassFamilyOverride<
          JobFormController,
          JobFormState,
          JobFormState,
          JobFormState,
          ({String projectId, Job? job})
        > {
  JobFormControllerFamily._()
    : super(
        retry: null,
        name: r'jobFormControllerProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  JobFormControllerProvider call({required String projectId, Job? job}) =>
      JobFormControllerProvider._(
        argument: (projectId: projectId, job: job),
        from: this,
      );

  @override
  String toString() => r'jobFormControllerProvider';
}

abstract class _$JobFormController extends $Notifier<JobFormState> {
  late final _$args = ref.$arg as ({String projectId, Job? job});
  String get projectId => _$args.projectId;
  Job? get job => _$args.job;

  JobFormState build({required String projectId, Job? job});
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref = this.ref as $Ref<JobFormState, JobFormState>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<JobFormState, JobFormState>,
              JobFormState,
              Object?,
              Object?
            >;
    return element.handleCreate(
      ref,
      () => build(projectId: _$args.projectId, job: _$args.job),
    );
  }
}
