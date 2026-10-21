abstract final class JobPhotoLimits {
  static const maxPerGallery = 10;
  static const maxBytes = 20 * 1024 * 1024;
  static const maxLongEdge = 2048;
  static const jpegQuality = 80;
  static const jpegQualityFraction = 0.8;
  static const maxConcurrentUploads = 2;
  static const signedUrlTtl = Duration(hours: 1);
}
