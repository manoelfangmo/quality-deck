import 'package:permission_handler/permission_handler.dart';

import 'package:app/features/onsite/application/camera_permission.dart';

class NativeCameraPermission implements CameraPermission {
  @override
  Future<CameraAccess> check() async {
    var status = await Permission.camera.status;
    if (status.isGranted || status.isLimited) return CameraAccess.granted;
    if (status.isDenied) {
      status = await Permission.camera.request();
      if (status.isGranted || status.isLimited) return CameraAccess.granted;
    }
    return CameraAccess.denied;
  }

  @override
  Future<void> openSettings() => openAppSettings();
}
