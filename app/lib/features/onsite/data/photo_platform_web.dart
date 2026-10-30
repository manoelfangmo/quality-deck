import 'package:app/features/onsite/data/photo_platform.dart';
import 'package:app/features/onsite/data/web/browser_image_decoder.dart';
import 'package:app/features/onsite/data/web/canvas_image_compressor.dart';
import 'package:app/features/onsite/data/web/wasm_heic_decoder.dart';
import 'package:app/features/onsite/data/web/web_camera_permission.dart';
import 'package:app/features/onsite/data/web/web_leave_guard.dart';
import 'package:app/features/onsite/data/web/web_photo_picker.dart';
import 'package:app/features/onsite/data/web/web_temp_file_cleaner.dart';

PhotoPlatform createPlatformPhotoAdapters() {
  return PhotoPlatform(
    picker: WebPhotoPicker(),
    decoders: [BrowserImageDecoder(), WasmHeicDecoder()],
    compressor: CanvasImageCompressor(),
    tempFiles: WebTempFileCleaner(),
    camera: WebCameraPermission(),
    leaveGuard: WebLeaveGuard(),
  );
}
