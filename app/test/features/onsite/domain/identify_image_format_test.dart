import 'dart:typed_data';

import 'package:flutter_test/flutter_test.dart';

import 'package:app/features/onsite/domain/identify_image_format.dart';
import 'package:app/features/onsite/domain/image_format.dart';

void main() {
  test('JPEG is identified from SOI bytes, not the name', () {
    expect(
      identifyImageFormat(Uint8List.fromList([0xFF, 0xD8, 0xFF, 0xE0])),
      ImageFormat.jpeg,
    );
  });

  test('PNG is identified from the signature', () {
    expect(
      identifyImageFormat(
        Uint8List.fromList([
          0x89,
          0x50,
          0x4E,
          0x47,
          0x0D,
          0x0A,
          0x1A,
          0x0A,
          0x00,
        ]),
      ),
      ImageFormat.png,
    );
  });

  test('HEIC is identified from an ftyp brand even if renamed .jpg', () {
    final heic = Uint8List.fromList([
      0x00, 0x00, 0x00, 0x18,
      0x66, 0x74, 0x79, 0x70, // ftyp
      0x68, 0x65, 0x69, 0x63, // heic
      0x00, 0x00, 0x00, 0x00,
      0x6D, 0x69, 0x66, 0x31, // mif1
      0x68, 0x65, 0x69, 0x63,
    ]);
    expect(identifyImageFormat(heic), ImageFormat.heic);
  });

  test('AVIF is not treated as HEIC', () {
    final avif = Uint8List.fromList([
      0x00, 0x00, 0x00, 0x1C,
      0x66, 0x74, 0x79, 0x70,
      0x61, 0x76, 0x69, 0x66, // avif
      0x00, 0x00, 0x00, 0x00,
      0x6D, 0x69, 0x66, 0x31,
      0x61, 0x76, 0x69, 0x66,
    ]);
    expect(identifyImageFormat(avif), isNull);
  });

  test('PDF and empty buffers are rejected', () {
    expect(identifyImageFormat(Uint8List(0)), isNull);
    expect(
      identifyImageFormat(
        Uint8List.fromList([0x25, 0x50, 0x44, 0x46]), // %PDF
      ),
      isNull,
    );
  });
}
