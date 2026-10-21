import 'dart:typed_data';

import 'package:flutter_test/flutter_test.dart';

import 'package:app/features/onsite/data/jpeg_dimensions.dart';

void main() {
  test('reads width and height from a SOF0 marker', () {
    final bytes = Uint8List.fromList([
      0xFF, 0xD8,
      0xFF, 0xC0, 0x00, 0x0B, 0x08,
      0x02, 0x58, // height 600
      0x03, 0x20, // width 800
      0x03, 0x01, 0x22, 0x00,
      0xFF, 0xD9,
    ]);
    expect(jpegDimensions(bytes), (width: 800, height: 600));
  });

  test('returns null for non-JPEG bytes', () {
    expect(jpegDimensions(Uint8List.fromList([0x89, 0x50])), isNull);
  });
}
