import 'dart:io';
import 'dart:typed_data';

import 'package:app/core/domain/app_exception.dart';
import 'package:app/features/onsite/application/image_decoder.dart';
import 'package:app/features/onsite/data/bytes_decoded_image.dart';
import 'package:app/features/onsite/domain/decoded_image.dart';
import 'package:app/features/onsite/domain/image_format.dart';

class NativeImageDecoder implements ImageDecoder {
  @override
  Future<bool> canDecode(ImageFormat format, [Uint8List? bytes]) async {
    if (format == ImageFormat.jpeg || format == ImageFormat.png) return true;
    if (format != ImageFormat.heic) return false;
    if (Platform.isIOS) return true;
    if (Platform.isAndroid) {
      final match = RegExp(r'\d+').firstMatch(Platform.operatingSystemVersion);
      final major = match == null ? 0 : int.parse(match.group(0)!);
      return major >= 9;
    }
    return false;
  }

  @override
  Future<DecodedImage> decode(Uint8List bytes, ImageFormat format) async {
    if (!await canDecode(format, bytes)) {
      throw const AppException.invalidPhotoType();
    }
    return BytesDecodedImage(bytes);
  }
}
