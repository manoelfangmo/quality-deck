import 'package:freezed_annotation/freezed_annotation.dart';

import 'package:app/features/onsite/domain/job_photo.dart';
import 'package:app/features/onsite/domain/job_photo_limits.dart';
import 'package:app/features/onsite/domain/photo_kind.dart';
import 'package:app/features/onsite/presentation/models/pending_photo.dart';

part 'job_photos_view.freezed.dart';

@freezed
abstract class JobPhotosView with _$JobPhotosView {
  const JobPhotosView._();

  const factory JobPhotosView({
    @Default([]) List<JobPhoto> saved,
    @Default(<String, String>{}) Map<String, String> urls,
    @Default([]) List<PendingPhoto> pending,
    String? notice,
    @Default(false) bool cameraDenied,
    String? deleteError,
    @Default(true) bool loading,
    @Default(0) int batchSize,
    @Default(0) int batchFinished,
  }) = _JobPhotosView;

  int savedCount(PhotoKind kind) =>
      saved.where((photo) => photo.kind == kind).length;

  int pendingCount(PhotoKind kind) => pending
      .where(
        (photo) =>
            photo.kind == kind && photo.status != PendingPhotoStatus.failed,
      )
      .length;

  int remaining(PhotoKind kind) =>
      JobPhotoLimits.maxPerGallery - savedCount(kind) - pendingCount(kind);

  bool get hasActiveUploads => pending.any(
    (photo) =>
        photo.status == PendingPhotoStatus.processing ||
        photo.status == PendingPhotoStatus.uploading,
  );

  int get activeUploadCount => pending
      .where(
        (photo) =>
            photo.status == PendingPhotoStatus.processing ||
            photo.status == PendingPhotoStatus.uploading,
      )
      .length;

  List<JobPhoto> savedOf(PhotoKind kind) =>
      saved.where((photo) => photo.kind == kind).toList();

  List<PendingPhoto> pendingOf(PhotoKind kind) =>
      pending.where((photo) => photo.kind == kind).toList();

  String? get uploadStatus {
    if (!hasActiveUploads || batchSize <= 0) return null;
    final current = (batchFinished + 1).clamp(1, batchSize);
    return 'Uploading $current of $batchSize — keep this screen open.';
  }
}
