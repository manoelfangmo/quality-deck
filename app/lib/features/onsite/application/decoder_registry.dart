import 'dart:typed_data';

import 'package:app/core/domain/app_exception.dart';
import 'package:app/features/onsite/application/image_decoder.dart';
import 'package:app/features/onsite/domain/image_format.dart';

class DecoderRegistry {
  DecoderRegistry(this._decoders);

  final List<ImageDecoder> _decoders;

  Future<ImageDecoder> forFormat(ImageFormat format, [Uint8List? bytes]) async {
    for (final decoder in _decoders) {
      if (await decoder.canDecode(format, bytes)) return decoder;
    }
    throw const AppException.invalidPhotoType();
  }
}
