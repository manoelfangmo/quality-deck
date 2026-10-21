import 'dart:typed_data';

import 'package:flutter_test/flutter_test.dart';

import 'package:app/features/onsite/application/decoder_registry.dart';
import 'package:app/features/onsite/data/web/browser_image_decoder.dart';
import 'package:app/features/onsite/data/web/wasm_heic_decoder.dart';
import 'package:app/features/onsite/domain/image_format.dart';

/// Run with: `flutter test chrome_test --platform chrome`
///
/// Kept outside `test/` so the VM suite does not compile web-only adapters.
void main() {
  final jpeg = Uint8List.fromList([
    0xFF,
    0xD8,
    0xFF,
    0xE0,
    0x00,
    0x10,
    0x4A,
    0x46,
    0x49,
    0x46,
    0x00,
    0x01,
    0x01,
    0x00,
    0x00,
    0x01,
    0x00,
    0x01,
    0x00,
    0x00,
    0xFF,
    0xC0,
    0x00,
    0x0B,
    0x08,
    0x00,
    0x01,
    0x00,
    0x01,
    0x01,
    0x01,
    0x11,
    0x00,
    0xFF,
    0xDA,
    0x00,
    0x08,
    0x01,
    0x01,
    0x00,
    0x00,
    0x3F,
    0x00,
    0x7F,
    0x3F,
    0xFF,
    0xD9,
  ]);

  final heicHeader = Uint8List.fromList([
    0x00,
    0x00,
    0x00,
    0x18,
    0x66,
    0x74,
    0x79,
    0x70,
    0x68,
    0x65,
    0x69,
    0x63,
    0x00,
    0x00,
    0x00,
    0x00,
    0x6D,
    0x69,
    0x66,
    0x31,
    0x68,
    0x65,
    0x69,
    0x63,
  ]);

  test('BrowserImageDecoder accepts JPEG', () async {
    final decoder = BrowserImageDecoder();
    expect(await decoder.canDecode(ImageFormat.jpeg, jpeg), isTrue);
  });

  test(
    'DecoderRegistry uses WASM for HEIC when the browser cannot decode it',
    () async {
      final browser = BrowserImageDecoder();
      final wasm = WasmHeicDecoder();
      final registry = DecoderRegistry([browser, wasm]);
      final chosen = await registry.forFormat(ImageFormat.heic, heicHeader);
      expect(identical(chosen, wasm) || identical(chosen, browser), isTrue);
      expect(await wasm.canDecode(ImageFormat.heic, heicHeader), isTrue);
    },
  );
}
