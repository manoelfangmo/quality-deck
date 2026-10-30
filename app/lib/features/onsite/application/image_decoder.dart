import 'dart:typed_data';

import 'package:app/features/onsite/domain/decoded_image.dart';
import 'package:app/features/onsite/domain/image_format.dart';

abstract interface class ImageDecoder {
  /// [bytes] is the file being decoded. Browser HEIC support is detected by
  /// trying `createImageBitmap` on those bytes, never by reading the UA string.
  Future<bool> canDecode(ImageFormat format, [Uint8List? bytes]);

  Future<DecodedImage> decode(Uint8List bytes, ImageFormat format);
}
