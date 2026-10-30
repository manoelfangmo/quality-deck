import 'dart:typed_data';

import 'package:app/core/domain/app_exception.dart';
import 'package:app/features/onsite/application/camera_permission.dart';
import 'package:app/features/onsite/application/id_generator.dart';
import 'package:app/features/onsite/application/image_compressor.dart';
import 'package:app/features/onsite/application/image_decoder.dart';
import 'package:app/features/onsite/application/job_photo_repository.dart';
import 'package:app/features/onsite/application/leave_guard.dart';
import 'package:app/features/onsite/application/orphan_logger.dart';
import 'package:app/features/onsite/application/photo_picker.dart';
import 'package:app/features/onsite/application/photo_storage.dart';
import 'package:app/features/onsite/application/temp_file_cleaner.dart';
import 'package:app/features/onsite/data/bytes_decoded_image.dart';
import 'package:app/features/onsite/domain/compressed_photo.dart';
import 'package:app/features/onsite/domain/decoded_image.dart';
import 'package:app/features/onsite/domain/image_format.dart';
import 'package:app/features/onsite/domain/job_photo.dart';
import 'package:app/features/onsite/domain/job_photo_limits.dart';
import 'package:app/features/onsite/domain/photo_kind.dart';
import 'package:app/features/onsite/domain/picked_photo.dart';

final jpegPreview = Uint8List.fromList([0xFF, 0xD8, 0xFF, 0xD9]);

class FakePhotoStorage implements PhotoStorage {
  final objects = <String, Uint8List>{};
  var failUpload = false;
  var failRemove = false;
  var uploadCount = 0;

  @override
  Future<void> upload(String path, Uint8List bytes) async {
    uploadCount++;
    if (failUpload) throw const AppException.uploadFailed();
    if (objects.containsKey(path)) throw const AppException.uploadFailed();
    objects[path] = bytes;
  }

  @override
  Future<void> remove(String path) async {
    if (failRemove) throw StateError('remove failed');
    objects.remove(path);
  }

  @override
  Future<String> signedUrl(String path, Duration ttl) async {
    if (!objects.containsKey(path)) throw StateError('missing');
    return 'https://signed.test/$path';
  }
}

class FakeJobPhotoRepository implements JobPhotoRepository {
  final photos = <JobPhoto>[];
  var failInsert = false;
  var failDelete = false;
  var nextCreatedAt = DateTime.utc(2026, 10, 21, 12);

  @override
  Future<JobPhoto> insert(JobPhotoInsert insert) async {
    if (failInsert) throw const AppException.uploadFailed();
    final count = photos
        .where((p) => p.jobId == insert.jobId && p.kind == insert.kind)
        .length;
    if (count >= JobPhotoLimits.maxPerGallery) {
      throw const AppException.photoLimitReached();
    }
    final photo = JobPhoto(
      id: insert.id,
      jobId: insert.jobId,
      kind: insert.kind,
      storagePath: insert.storagePath,
      width: insert.width,
      height: insert.height,
      createdBy: 'owner-id',
      createdAt: nextCreatedAt,
    );
    nextCreatedAt = nextCreatedAt.add(const Duration(seconds: 1));
    photos.add(photo);
    return photo;
  }

  @override
  Future<void> delete(String id) async {
    if (failDelete) throw const AppException.photoNotFound();
    final index = photos.indexWhere((p) => p.id == id);
    if (index < 0) throw const AppException.photoNotFound();
    photos.removeAt(index);
  }

  @override
  Future<List<JobPhoto>> listByJob(String jobId) async {
    return [
      for (final photo in photos)
        if (photo.jobId == jobId) photo,
    ];
  }

  @override
  Future<int> count(String jobId, PhotoKind kind) async {
    return photos.where((p) => p.jobId == jobId && p.kind == kind).length;
  }
}

class FakeOrphanLogger implements OrphanLogger {
  final paths = <String>[];

  @override
  Future<void> record(String storagePath) async {
    paths.add(storagePath);
  }
}

class FakeIdGenerator implements IdGenerator {
  FakeIdGenerator([this._next = 'photo-1']);

  final String _next;
  var _n = 1;

  @override
  String next() {
    final id = _n == 1 ? _next : 'photo-$_n';
    _n++;
    return id;
  }
}

class FakeImageDecoder implements ImageDecoder {
  var acceptHeic = true;

  @override
  Future<bool> canDecode(ImageFormat format, [Uint8List? bytes]) async {
    if (format == ImageFormat.heic) return acceptHeic;
    return format == ImageFormat.jpeg || format == ImageFormat.png;
  }

  @override
  Future<DecodedImage> decode(Uint8List bytes, ImageFormat format) async {
    if (!await canDecode(format, bytes)) {
      throw const AppException.invalidPhotoType();
    }
    return BytesDecodedImage(bytes);
  }
}

class FakeImageCompressor implements ImageCompressor {
  FakeImageCompressor([this.output]);

  Uint8List? output;
  var fail = false;

  @override
  Future<CompressedPhoto> compress(DecodedImage image) async {
    if (fail) throw const AppException.invalidPhotoType();
    final source = image is BytesDecodedImage ? image.bytes : jpegPreview;
    return CompressedPhoto(bytes: output ?? source, width: 800, height: 600);
  }
}

class FakeTempFileCleaner implements TempFileCleaner {
  final deleted = <String>[];

  @override
  Future<void> delete(String? path) async {
    if (path != null) deleted.add(path);
  }
}

class FakePhotoPicker implements PhotoPicker {
  List<PickedPhoto> files = const [];

  @override
  Future<List<PickedPhoto>> pick(PhotoPickSource source, {int? limit}) async {
    if (limit == null || files.length <= limit) return files;
    return files.take(limit).toList();
  }
}

class FakeCameraPermission implements CameraPermission {
  CameraAccess access = CameraAccess.granted;
  var openedSettings = false;

  @override
  Future<CameraAccess> check() async => access;

  @override
  Future<void> openSettings() async {
    openedSettings = true;
  }
}

class FakeLeaveGuard implements LeaveGuard {
  var inProgress = false;
  void Function()? _onBackgrounded;

  @override
  set onBackgrounded(void Function()? callback) {
    _onBackgrounded = callback;
  }

  void background() => _onBackgrounded?.call();

  @override
  void setUploadsInProgress(bool value) {
    inProgress = value;
  }

  @override
  void dispose() {}
}
