import 'package:app/features/onsite/application/camera_permission.dart';
import 'package:app/features/onsite/application/image_compressor.dart';
import 'package:app/features/onsite/application/image_decoder.dart';
import 'package:app/features/onsite/application/leave_guard.dart';
import 'package:app/features/onsite/application/photo_picker.dart';
import 'package:app/features/onsite/application/temp_file_cleaner.dart';

class PhotoPlatform {
  const PhotoPlatform({
    required this.picker,
    required this.decoders,
    required this.compressor,
    required this.tempFiles,
    required this.camera,
    required this.leaveGuard,
  });

  final PhotoPicker picker;
  final List<ImageDecoder> decoders;
  final ImageCompressor compressor;
  final TempFileCleaner tempFiles;
  final CameraPermission camera;
  final LeaveGuard leaveGuard;
}
