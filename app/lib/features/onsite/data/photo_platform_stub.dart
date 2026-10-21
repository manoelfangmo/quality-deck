import 'package:app/features/onsite/application/camera_permission.dart';
import 'package:app/features/onsite/application/image_compressor.dart';
import 'package:app/features/onsite/application/image_decoder.dart';
import 'package:app/features/onsite/application/leave_guard.dart';
import 'package:app/features/onsite/application/photo_picker.dart';
import 'package:app/features/onsite/application/temp_file_cleaner.dart';
import 'package:app/features/onsite/data/photo_platform.dart';
import 'package:app/features/onsite/domain/compressed_photo.dart';
import 'package:app/features/onsite/domain/decoded_image.dart';
import 'package:app/features/onsite/domain/image_format.dart';
import 'package:app/features/onsite/domain/picked_photo.dart';

PhotoPlatform createPlatformPhotoAdapters() {
  return PhotoPlatform(
    picker: _StubPicker(),
    decoders: const [],
    compressor: _StubCompressor(),
    tempFiles: _StubTempFiles(),
    camera: _StubCamera(),
    leaveGuard: _StubLeaveGuard(),
  );
}

class _StubPicker implements PhotoPicker {
  @override
  Future<List<PickedPhoto>> pick(PhotoPickSource source, {int? limit}) async {
    return const [];
  }
}

class _StubCompressor implements ImageCompressor {
  @override
  Future<CompressedPhoto> compress(DecodedImage image) {
    throw UnsupportedError('ImageCompressor is not available on this platform');
  }
}

class _StubTempFiles implements TempFileCleaner {
  @override
  Future<void> delete(String? path) async {}
}

class _StubCamera implements CameraPermission {
  @override
  Future<CameraAccess> check() async => CameraAccess.granted;

  @override
  Future<void> openSettings() async {}
}

class _StubLeaveGuard implements LeaveGuard {
  @override
  set onBackgrounded(void Function()? callback) {}

  @override
  void setUploadsInProgress(bool inProgress) {}

  @override
  void dispose() {}
}

class StubImageDecoder implements ImageDecoder {
  @override
  Future<bool> canDecode(ImageFormat format, [bytes]) async => false;

  @override
  Future<DecodedImage> decode(bytes, ImageFormat format) {
    throw UnsupportedError('ImageDecoder is not available on this platform');
  }
}
