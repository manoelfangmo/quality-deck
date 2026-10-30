import 'dart:typed_data';

/// Reads width and height from a JPEG SOF marker.
({int width, int height})? jpegDimensions(Uint8List bytes) {
  if (bytes.length < 4 || bytes[0] != 0xFF || bytes[1] != 0xD8) return null;
  var offset = 2;
  while (offset + 8 < bytes.length) {
    if (bytes[offset] != 0xFF) {
      offset++;
      continue;
    }
    final marker = bytes[offset + 1];
    if (marker == 0xD8 ||
        marker == 0x01 ||
        (marker >= 0xD0 && marker <= 0xD9)) {
      offset += 2;
      continue;
    }
    final length = (bytes[offset + 2] << 8) | bytes[offset + 3];
    final isSof =
        marker == 0xC0 ||
        marker == 0xC1 ||
        marker == 0xC2 ||
        marker == 0xC3 ||
        marker == 0xC5 ||
        marker == 0xC6 ||
        marker == 0xC7 ||
        marker == 0xC9 ||
        marker == 0xCA ||
        marker == 0xCB ||
        marker == 0xCD ||
        marker == 0xCE ||
        marker == 0xCF;
    if (isSof && offset + 7 < bytes.length) {
      final height = (bytes[offset + 5] << 8) | bytes[offset + 6];
      final width = (bytes[offset + 7] << 8) | bytes[offset + 8];
      if (width > 0 && height > 0) return (width: width, height: height);
    }
    if (length < 2) return null;
    offset += 2 + length;
  }
  return null;
}
