import 'package:freezed_annotation/freezed_annotation.dart';

import 'package:app/core/database/job_photos_table.dart';
import 'package:app/core/utils/json_converters.dart';
import 'package:app/features/onsite/domain/photo_kind.dart';

part 'job_photo.freezed.dart';

@freezed
abstract class JobPhoto with _$JobPhoto {
  const factory JobPhoto({
    required String id,
    required String jobId,
    required PhotoKind kind,
    required String storagePath,
    required int width,
    required int height,
    required String createdBy,
    required DateTime createdAt,
  }) = _JobPhoto;

  factory JobPhoto.fromJson(Map<String, dynamic> json) {
    return JobPhoto(
      id: json[JobPhotosTable.id] as String,
      jobId: json[JobPhotosTable.jobId] as String,
      kind: PhotoKind.fromDb(json[JobPhotosTable.kind] as String),
      storagePath: json[JobPhotosTable.storagePath] as String,
      width: json[JobPhotosTable.width] as int,
      height: json[JobPhotosTable.height] as int,
      createdBy: json[JobPhotosTable.createdBy] as String,
      createdAt: const UtcToLocalConverter().fromJson(
        json[JobPhotosTable.createdAt] as String,
      ),
    );
  }
}
