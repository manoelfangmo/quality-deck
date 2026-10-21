enum CameraAccess { granted, denied }

abstract interface class CameraPermission {
  Future<CameraAccess> check();

  Future<void> openSettings();
}
