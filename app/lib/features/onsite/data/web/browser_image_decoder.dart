import 'dart:typed_data';

import 'package:web/web.dart' as web;

import 'package:app/core/domain/app_exception.dart';
import 'package:app/features/onsite/application/image_decoder.dart';
import 'package:app/features/onsite/data/web/web_blobs.dart';
import 'package:app/features/onsite/data/web/web_decoded_image.dart';
import 'package:app/features/onsite/domain/decoded_image.dart';
import 'package:app/features/onsite/domain/image_format.dart';

class BrowserImageDecoder implements ImageDecoder {
  bool? _heicNative;
  web.ImageBitmap? _probeBitmap;

  @override
  Future<bool> canDecode(ImageFormat format, [Uint8List? bytes]) async {
    if (format == ImageFormat.jpeg || format == ImageFormat.png) return true;
    if (format != ImageFormat.heic) return false;
    if (_heicNative == true) return true;
    if (bytes == null) return false;
    try {
      _probeBitmap?.close();
      _probeBitmap = await bitmapFromBlob(blobFromBytes(bytes, 'image/heic'));
      _heicNative = true;
      return true;
    } catch (_) {
      return false;
    }
  }

  @override
  Future<DecodedImage> decode(Uint8List bytes, ImageFormat format) async {
    final probe = _probeBitmap;
    _probeBitmap = null;
    if (probe != null) return WebDecodedImage(probe);

    final mime = switch (format) {
      ImageFormat.jpeg => 'image/jpeg',
      ImageFormat.png => 'image/png',
      ImageFormat.heic => 'image/heic',
    };
    try {
      final bitmap = await bitmapFromBlob(blobFromBytes(bytes, mime));
      return WebDecodedImage(bitmap);
    } catch (_) {
      throw const AppException.invalidPhotoType();
    }
  }
}
