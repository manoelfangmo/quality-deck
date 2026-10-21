import 'package:app/core/domain/app_exception.dart';
import 'package:app/features/onsite/application/decoder_registry.dart';
import 'package:app/features/onsite/application/id_generator.dart';
import 'package:app/features/onsite/application/image_compressor.dart';
import 'package:app/features/onsite/application/job_photo_repository.dart';
import 'package:app/features/onsite/application/photo_storage.dart';
import 'package:app/features/onsite/application/temp_file_cleaner.dart';
import 'package:app/features/onsite/domain/compressed_photo.dart';
import 'package:app/features/onsite/domain/identify_image_format.dart';
import 'package:app/features/onsite/domain/job_photo.dart';
import 'package:app/features/onsite/domain/job_photo_limits.dart';
import 'package:app/features/onsite/domain/photo_kind.dart';
import 'package:app/features/onsite/domain/picked_photo.dart';

class SavedJobPhoto {
  const SavedJobPhoto({required this.photo, required this.previewJpeg});

  final JobPhoto photo;
  final CompressedPhoto previewJpeg;
}

class AddJobPhotos {
  AddJobPhotos({
    required this._decoders,
    required this._compressor,
    required this._storage,
    required this._repo,
    required this._ids,
    required this._tempFiles,
  });

  final DecoderRegistry _decoders;
  final ImageCompressor _compressor;
  final PhotoStorage _storage;
  final JobPhotoRepository _repo;
  final IdGenerator _ids;
  final TempFileCleaner _tempFiles;

  /// Identifies, decodes and compresses one photo. Drops full-size bytes and
  /// the platform bitmap as soon as the JPEG is ready, then deletes the picker
  /// temp file.
  Future<CompressedPhoto> process(PickedPhoto picked) async {
    if (picked.bytes.length > JobPhotoLimits.maxBytes) {
      await _tempFiles.delete(picked.tempPath);
      throw const AppException.photoTooLarge();
    }

    final format = identifyImageFormat(picked.bytes);
    if (format == null) {
      await _tempFiles.delete(picked.tempPath);
      throw const AppException.invalidPhotoType();
    }

    final decoder = await _decoders.forFormat(format, picked.bytes);
    final decoded = await decoder.decode(picked.bytes, format);
    try {
      final compressed = await _compressor.compress(decoded);
      return compressed;
    } finally {
      decoded.close();
      await _tempFiles.delete(picked.tempPath);
    }
  }

  /// Uploads the compressed JPEG and inserts the row. If the insert fails
  /// (including the 10-photo limit), the object is deleted so nothing is saved.
  Future<SavedJobPhoto> save({
    required String jobId,
    required String businessId,
    required PhotoKind kind,
    required CompressedPhoto compressed,
    bool Function()? isCancelled,
  }) async {
    if (isCancelled?.call() ?? false) {
      throw const CancelledUpload();
    }

    final id = _ids.next();
    final path = '$businessId/$jobId/$id.jpg';

    try {
      await _storage.upload(path, compressed.bytes);
    } on AppException {
      rethrow;
    } catch (error, stackTrace) {
      Error.throwWithStackTrace(const AppException.uploadFailed(), stackTrace);
    }

    if (isCancelled?.call() ?? false) {
      await _removeQuietly(path);
      throw const CancelledUpload();
    }

    try {
      final photo = await _repo.insert(
        JobPhotoInsert(
          id: id,
          jobId: jobId,
          kind: kind,
          storagePath: path,
          width: compressed.width,
          height: compressed.height,
        ),
      );
      return SavedJobPhoto(photo: photo, previewJpeg: compressed);
    } catch (error, stackTrace) {
      await _removeQuietly(path);
      if (error is AppException) {
        Error.throwWithStackTrace(error, stackTrace);
      }
      Error.throwWithStackTrace(const AppException.uploadFailed(), stackTrace);
    }
  }

  Future<void> _removeQuietly(String path) async {
    try {
      await _storage.remove(path);
    } catch (_) {}
  }
}

/// Thrown when the user cancels an in-flight upload. Not an [AppException].
class CancelledUpload implements Exception {
  const CancelledUpload();
}
