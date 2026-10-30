import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'package:app/core/utils/providers.dart';
import 'package:app/features/onsite/application/add_job_photos.dart';
import 'package:app/features/onsite/application/camera_permission.dart';
import 'package:app/features/onsite/application/decoder_registry.dart';
import 'package:app/features/onsite/application/delete_job_photo.dart';
import 'package:app/features/onsite/application/id_generator.dart';
import 'package:app/features/onsite/application/image_compressor.dart';
import 'package:app/features/onsite/application/job_photo_repository.dart';
import 'package:app/features/onsite/application/leave_guard.dart';
import 'package:app/features/onsite/application/orphan_logger.dart';
import 'package:app/features/onsite/application/photo_picker.dart';
import 'package:app/features/onsite/application/photo_storage.dart';
import 'package:app/features/onsite/application/temp_file_cleaner.dart';
import 'package:app/features/onsite/data/photo_platform.dart';
import 'package:app/features/onsite/data/photo_platform_factory.dart';
import 'package:app/features/onsite/data/supabase_job_photo_repository.dart';
import 'package:app/features/onsite/data/supabase_orphan_logger.dart';
import 'package:app/features/onsite/data/supabase_photo_storage.dart';
import 'package:app/features/onsite/data/uuid_id_generator.dart';

part 'job_photo_providers.g.dart';

@Riverpod(keepAlive: true)
PhotoPlatform photoPlatform(Ref ref) {
  final platform = createPhotoPlatform();
  ref.onDispose(platform.leaveGuard.dispose);
  return platform;
}

@riverpod
PhotoPicker photoPicker(Ref ref) => ref.watch(photoPlatformProvider).picker;

@riverpod
DecoderRegistry decoderRegistry(Ref ref) {
  return DecoderRegistry(ref.watch(photoPlatformProvider).decoders);
}

@riverpod
ImageCompressor imageCompressor(Ref ref) {
  return ref.watch(photoPlatformProvider).compressor;
}

@riverpod
TempFileCleaner tempFileCleaner(Ref ref) {
  return ref.watch(photoPlatformProvider).tempFiles;
}

@riverpod
CameraPermission cameraPermission(Ref ref) {
  return ref.watch(photoPlatformProvider).camera;
}

@riverpod
LeaveGuard leaveGuard(Ref ref) => ref.watch(photoPlatformProvider).leaveGuard;

@riverpod
PhotoStorage photoStorage(Ref ref) {
  return SupabasePhotoStorage(ref.watch(supabaseProvider));
}

@riverpod
JobPhotoRepository jobPhotoRepository(Ref ref) {
  return SupabaseJobPhotoRepository(ref.watch(supabaseProvider));
}

@riverpod
OrphanLogger orphanLogger(Ref ref) {
  return SupabaseOrphanLogger(ref.watch(supabaseProvider));
}

@riverpod
IdGenerator idGenerator(Ref ref) => const UuidIdGenerator();

@riverpod
AddJobPhotos addJobPhotos(Ref ref) {
  return AddJobPhotos(
    decoders: ref.watch(decoderRegistryProvider),
    compressor: ref.watch(imageCompressorProvider),
    storage: ref.watch(photoStorageProvider),
    repo: ref.watch(jobPhotoRepositoryProvider),
    ids: ref.watch(idGeneratorProvider),
    tempFiles: ref.watch(tempFileCleanerProvider),
  );
}

@riverpod
DeleteJobPhoto deleteJobPhoto(Ref ref) {
  return DeleteJobPhoto(
    repo: ref.watch(jobPhotoRepositoryProvider),
    storage: ref.watch(photoStorageProvider),
    orphans: ref.watch(orphanLoggerProvider),
  );
}
