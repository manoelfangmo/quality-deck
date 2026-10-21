import 'dart:typed_data';

class CompressedPhoto {
  const CompressedPhoto({
    required this.bytes,
    required this.width,
    required this.height,
  });

  final Uint8List bytes;
  final int width;
  final int height;
}
