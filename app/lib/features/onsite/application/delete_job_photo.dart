import 'package:app/core/domain/app_exception.dart';
import 'package:app/features/onsite/application/job_photo_repository.dart';
import 'package:app/features/onsite/application/orphan_logger.dart';
import 'package:app/features/onsite/application/photo_storage.dart';
import 'package:app/features/onsite/domain/job_photo.dart';

class DeleteJobPhoto {
  DeleteJobPhoto({
    required this._repo,
    required this._storage,
    required this._orphans,
  });

  final JobPhotoRepository _repo;
  final PhotoStorage _storage;
  final OrphanLogger _orphans;

  /// Deletes the row first. If that fails, the file is left alone so the
  /// caller can restore the tile. If the file delete then fails, the photo is
  /// already gone from the app and the path is logged for cleanup.
  Future<void> call(JobPhoto photo) async {
    try {
      await _repo.delete(photo.id);
    } on AppException {
      rethrow;
    } catch (error, stackTrace) {
      Error.throwWithStackTrace(error, stackTrace);
    }

    try {
      await _storage.remove(photo.storagePath);
    } catch (_) {
      await _orphans.record(photo.storagePath);
    }
  }
}
