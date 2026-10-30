import 'package:app/features/onsite/data/native/native_camera_permission.dart';
import 'package:app/features/onsite/data/native/native_image_compressor.dart';
import 'package:app/features/onsite/data/native/native_image_decoder.dart';
import 'package:app/features/onsite/data/native/native_leave_guard.dart';
import 'package:app/features/onsite/data/native/native_photo_picker.dart';
import 'package:app/features/onsite/data/native/native_temp_file_cleaner.dart';
import 'package:app/features/onsite/data/photo_platform.dart';

PhotoPlatform createPlatformPhotoAdapters() {
  return PhotoPlatform(
    picker: NativePhotoPicker(),
    decoders: [NativeImageDecoder()],
    compressor: NativeImageCompressor(),
    tempFiles: NativeTempFileCleaner(),
    camera: NativeCameraPermission(),
    leaveGuard: NativeLeaveGuard(),
  );
}
