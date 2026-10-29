// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'job_photos.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(PhotoUploadsInProgress)
final photoUploadsInProgressProvider = PhotoUploadsInProgressProvider._();

final class PhotoUploadsInProgressProvider
    extends $NotifierProvider<PhotoUploadsInProgress, int> {
  PhotoUploadsInProgressProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'photoUploadsInProgressProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$photoUploadsInProgressHash();

  @$internal
  @override
  PhotoUploadsInProgress create() => PhotoUploadsInProgress();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(int value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<int>(value),
    );
  }
}

String _$photoUploadsInProgressHash() =>
    r'32fc3096e302570e90f56bb2a3084c715a9b9263';

abstract class _$PhotoUploadsInProgress extends $Notifier<int> {
  int build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref = this.ref as $Ref<int, int>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<int, int>,
              int,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, build);
  }
}

@ProviderFor(JobPhotosController)
final jobPhotosControllerProvider = JobPhotosControllerFamily._();

final class JobPhotosControllerProvider
    extends $NotifierProvider<JobPhotosController, JobPhotosView> {
  JobPhotosControllerProvider._({
    required JobPhotosControllerFamily super.from,
    required String super.argument,
  }) : super(
         retry: null,
         name: r'jobPhotosControllerProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$jobPhotosControllerHash();

  @override
  String toString() {
    return r'jobPhotosControllerProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  JobPhotosController create() => JobPhotosController();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(JobPhotosView value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<JobPhotosView>(value),
    );
  }

  @override
  bool operator ==(Object other) {
    return other is JobPhotosControllerProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$jobPhotosControllerHash() =>
    r'4e729a7c139baffc7bc90179f22d53bfa1de47dc';

final class JobPhotosControllerFamily extends $Family
    with
        $ClassFamilyOverride<
          JobPhotosController,
          JobPhotosView,
          JobPhotosView,
          JobPhotosView,
          String
        > {
  JobPhotosControllerFamily._()
    : super(
        retry: null,
        name: r'jobPhotosControllerProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  JobPhotosControllerProvider call(String jobId) =>
      JobPhotosControllerProvider._(argument: jobId, from: this);

  @override
  String toString() => r'jobPhotosControllerProvider';
}

abstract class _$JobPhotosController extends $Notifier<JobPhotosView> {
  late final _$args = ref.$arg as String;
  String get jobId => _$args;

  JobPhotosView build(String jobId);
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref = this.ref as $Ref<JobPhotosView, JobPhotosView>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<JobPhotosView, JobPhotosView>,
              JobPhotosView,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, () => build(_$args));
  }
}
