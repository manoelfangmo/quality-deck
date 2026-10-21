import 'dart:js_interop';
import 'dart:typed_data';

import 'package:web/web.dart' as web;

import 'package:app/core/domain/app_exception.dart';
import 'package:app/features/onsite/application/image_decoder.dart';
import 'package:app/features/onsite/data/web/web_blobs.dart';
import 'package:app/features/onsite/data/web/web_decoded_image.dart';
import 'package:app/features/onsite/domain/decoded_image.dart';
import 'package:app/features/onsite/domain/image_format.dart';

@JS('__fieldNotesDecodeHeic')
external JSPromise<web.Blob> _decodeHeic(JSUint8Array bytes);

class WasmHeicDecoder implements ImageDecoder {
  @override
  Future<bool> canDecode(ImageFormat format, [Uint8List? bytes]) async {
    return format == ImageFormat.heic;
  }

  @override
  Future<DecodedImage> decode(Uint8List bytes, ImageFormat format) async {
    try {
      final png = await _decodeHeic(bytes.toJS).toDart;
      final bitmap = await bitmapFromBlob(png);
      return WebDecodedImage(bitmap);
    } catch (_) {
      throw const AppException.invalidPhotoType();
    }
  }
}
