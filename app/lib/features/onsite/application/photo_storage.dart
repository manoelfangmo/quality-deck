import 'dart:typed_data';

abstract interface class PhotoStorage {
  /// Uploads bytes to a new path. Never overwrites an existing file.
  Future<void> upload(String path, Uint8List bytes);

  Future<void> remove(String path);

  Future<String> signedUrl(String path, Duration ttl);
}
