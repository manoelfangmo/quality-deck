// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'job_photo_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(photoPlatform)
final photoPlatformProvider = PhotoPlatformProvider._();

final class PhotoPlatformProvider
    extends $FunctionalProvider<PhotoPlatform, PhotoPlatform, PhotoPlatform>
    with $Provider<PhotoPlatform> {
  PhotoPlatformProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'photoPlatformProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$photoPlatformHash();

  @$internal
  @override
  $ProviderElement<PhotoPlatform> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  PhotoPlatform create(Ref ref) {
    return photoPlatform(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(PhotoPlatform value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<PhotoPlatform>(value),
    );
  }
}

String _$photoPlatformHash() => r'1a312af116911263a41ffc040c5425a2a31f4708';

@ProviderFor(photoPicker)
final photoPickerProvider = PhotoPickerProvider._();

final class PhotoPickerProvider
    extends $FunctionalProvider<PhotoPicker, PhotoPicker, PhotoPicker>
    with $Provider<PhotoPicker> {
  PhotoPickerProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'photoPickerProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$photoPickerHash();

  @$internal
  @override
  $ProviderElement<PhotoPicker> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  PhotoPicker create(Ref ref) {
    return photoPicker(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(PhotoPicker value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<PhotoPicker>(value),
    );
  }
}

String _$photoPickerHash() => r'ed757eb368c56f23a85cef0bbd9a9d3e03e52b0f';

@ProviderFor(decoderRegistry)
final decoderRegistryProvider = DecoderRegistryProvider._();

final class DecoderRegistryProvider
    extends
        $FunctionalProvider<DecoderRegistry, DecoderRegistry, DecoderRegistry>
    with $Provider<DecoderRegistry> {
  DecoderRegistryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'decoderRegistryProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$decoderRegistryHash();

  @$internal
  @override
  $ProviderElement<DecoderRegistry> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  DecoderRegistry create(Ref ref) {
    return decoderRegistry(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(DecoderRegistry value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<DecoderRegistry>(value),
    );
  }
}

String _$decoderRegistryHash() => r'0c99d9276c0e16a42f681c916601628e7ecd0347';

@ProviderFor(imageCompressor)
final imageCompressorProvider = ImageCompressorProvider._();

final class ImageCompressorProvider
    extends
        $FunctionalProvider<ImageCompressor, ImageCompressor, ImageCompressor>
    with $Provider<ImageCompressor> {
  ImageCompressorProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'imageCompressorProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$imageCompressorHash();

  @$internal
  @override
  $ProviderElement<ImageCompressor> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  ImageCompressor create(Ref ref) {
    return imageCompressor(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(ImageCompressor value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<ImageCompressor>(value),
    );
  }
}

String _$imageCompressorHash() => r'e0686db5814227db084add5a09ee32acf92a65eb';

@ProviderFor(tempFileCleaner)
final tempFileCleanerProvider = TempFileCleanerProvider._();

final class TempFileCleanerProvider
    extends
        $FunctionalProvider<TempFileCleaner, TempFileCleaner, TempFileCleaner>
    with $Provider<TempFileCleaner> {
  TempFileCleanerProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'tempFileCleanerProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$tempFileCleanerHash();

  @$internal
  @override
  $ProviderElement<TempFileCleaner> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  TempFileCleaner create(Ref ref) {
    return tempFileCleaner(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(TempFileCleaner value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<TempFileCleaner>(value),
    );
  }
}

String _$tempFileCleanerHash() => r'e5895cc6d4d4f6a8389b6b8a9083810854bc984c';

@ProviderFor(cameraPermission)
final cameraPermissionProvider = CameraPermissionProvider._();

final class CameraPermissionProvider
    extends
        $FunctionalProvider<
          CameraPermission,
          CameraPermission,
          CameraPermission
        >
    with $Provider<CameraPermission> {
  CameraPermissionProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'cameraPermissionProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$cameraPermissionHash();

  @$internal
  @override
  $ProviderElement<CameraPermission> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  CameraPermission create(Ref ref) {
    return cameraPermission(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(CameraPermission value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<CameraPermission>(value),
    );
  }
}

String _$cameraPermissionHash() => r'1a8c3fe422f4ea04c8f3d0a1ca58f5a060bdc5a4';

@ProviderFor(leaveGuard)
final leaveGuardProvider = LeaveGuardProvider._();

final class LeaveGuardProvider
    extends $FunctionalProvider<LeaveGuard, LeaveGuard, LeaveGuard>
    with $Provider<LeaveGuard> {
  LeaveGuardProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'leaveGuardProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$leaveGuardHash();

  @$internal
  @override
  $ProviderElement<LeaveGuard> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  LeaveGuard create(Ref ref) {
    return leaveGuard(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(LeaveGuard value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<LeaveGuard>(value),
    );
  }
}

String _$leaveGuardHash() => r'061adcfa39558b544f3b6d6776f45acac38b51fa';

@ProviderFor(photoStorage)
final photoStorageProvider = PhotoStorageProvider._();

final class PhotoStorageProvider
    extends $FunctionalProvider<PhotoStorage, PhotoStorage, PhotoStorage>
    with $Provider<PhotoStorage> {
  PhotoStorageProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'photoStorageProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$photoStorageHash();

  @$internal
  @override
  $ProviderElement<PhotoStorage> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  PhotoStorage create(Ref ref) {
    return photoStorage(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(PhotoStorage value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<PhotoStorage>(value),
    );
  }
}

String _$photoStorageHash() => r'c718f3b1a2a994657f66781c84983f9f7cbb93e5';

@ProviderFor(jobPhotoRepository)
final jobPhotoRepositoryProvider = JobPhotoRepositoryProvider._();

final class JobPhotoRepositoryProvider
    extends
        $FunctionalProvider<
          JobPhotoRepository,
          JobPhotoRepository,
          JobPhotoRepository
        >
    with $Provider<JobPhotoRepository> {
  JobPhotoRepositoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'jobPhotoRepositoryProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$jobPhotoRepositoryHash();

  @$internal
  @override
  $ProviderElement<JobPhotoRepository> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  JobPhotoRepository create(Ref ref) {
    return jobPhotoRepository(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(JobPhotoRepository value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<JobPhotoRepository>(value),
    );
  }
}

String _$jobPhotoRepositoryHash() =>
    r'ab0636c3d13bb5c62d2d039c00496f82b3d12ead';

@ProviderFor(orphanLogger)
final orphanLoggerProvider = OrphanLoggerProvider._();

final class OrphanLoggerProvider
    extends $FunctionalProvider<OrphanLogger, OrphanLogger, OrphanLogger>
    with $Provider<OrphanLogger> {
  OrphanLoggerProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'orphanLoggerProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$orphanLoggerHash();

  @$internal
  @override
  $ProviderElement<OrphanLogger> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  OrphanLogger create(Ref ref) {
    return orphanLogger(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(OrphanLogger value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<OrphanLogger>(value),
    );
  }
}

String _$orphanLoggerHash() => r'459af1078a496ae0e0027f769686fc42ea103338';

@ProviderFor(idGenerator)
final idGeneratorProvider = IdGeneratorProvider._();

final class IdGeneratorProvider
    extends $FunctionalProvider<IdGenerator, IdGenerator, IdGenerator>
    with $Provider<IdGenerator> {
  IdGeneratorProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'idGeneratorProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$idGeneratorHash();

  @$internal
  @override
  $ProviderElement<IdGenerator> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  IdGenerator create(Ref ref) {
    return idGenerator(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(IdGenerator value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<IdGenerator>(value),
    );
  }
}

String _$idGeneratorHash() => r'532e07a51b2cbe324ea25c5114a268733186ddbb';

@ProviderFor(addJobPhotos)
final addJobPhotosProvider = AddJobPhotosProvider._();

final class AddJobPhotosProvider
    extends $FunctionalProvider<AddJobPhotos, AddJobPhotos, AddJobPhotos>
    with $Provider<AddJobPhotos> {
  AddJobPhotosProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'addJobPhotosProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$addJobPhotosHash();

  @$internal
  @override
  $ProviderElement<AddJobPhotos> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  AddJobPhotos create(Ref ref) {
    return addJobPhotos(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(AddJobPhotos value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<AddJobPhotos>(value),
    );
  }
}

String _$addJobPhotosHash() => r'7522459382eb9441f567cbed11421378d4b90a72';

@ProviderFor(deleteJobPhoto)
final deleteJobPhotoProvider = DeleteJobPhotoProvider._();

final class DeleteJobPhotoProvider
    extends $FunctionalProvider<DeleteJobPhoto, DeleteJobPhoto, DeleteJobPhoto>
    with $Provider<DeleteJobPhoto> {
  DeleteJobPhotoProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'deleteJobPhotoProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$deleteJobPhotoHash();

  @$internal
  @override
  $ProviderElement<DeleteJobPhoto> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  DeleteJobPhoto create(Ref ref) {
    return deleteJobPhoto(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(DeleteJobPhoto value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<DeleteJobPhoto>(value),
    );
  }
}

String _$deleteJobPhotoHash() => r'c51cfd8ed062bbcc69aec0a03e89376e2a960413';
