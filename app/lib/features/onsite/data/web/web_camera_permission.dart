import 'package:app/features/onsite/application/camera_permission.dart';

class WebCameraPermission implements CameraPermission {
  @override
  Future<CameraAccess> check() async => CameraAccess.granted;

  @override
  Future<void> openSettings() async {}
}
