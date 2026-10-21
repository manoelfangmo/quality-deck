abstract class DecodedImage {
  int get width;
  int get height;

  /// Releases the platform bitmap or drops large buffers.
  void close();
}
