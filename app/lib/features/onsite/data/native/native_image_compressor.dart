import 'package:flutter_image_compress/flutter_image_compress.dart';

import 'package:app/core/domain/app_exception.dart';
import 'package:app/features/onsite/application/image_compressor.dart';
import 'package:app/features/onsite/data/bytes_decoded_image.dart';
import 'package:app/features/onsite/data/jpeg_dimensions.dart';
import 'package:app/features/onsite/domain/compressed_photo.dart';
import 'package:app/features/onsite/domain/decoded_image.dart';
import 'package:app/features/onsite/domain/job_photo_limits.dart';

class NativeImageCompressor implements ImageCompressor {
  @override
  Future<CompressedPhoto> compress(DecodedImage image) async {
    if (image is! BytesDecodedImage) {
      throw const AppException.invalidPhotoType();
    }
    try {
      final out = await FlutterImageCompress.compressWithList(
        image.bytes,
        minWidth: JobPhotoLimits.maxLongEdge,
        minHeight: JobPhotoLimits.maxLongEdge,
        quality: JobPhotoLimits.jpegQuality,
        format: CompressFormat.jpeg,
        keepExif: false,
      );
      final dims = jpegDimensions(out);
      if (dims == null) {
        throw const AppException.invalidPhotoType();
      }
      return CompressedPhoto(
        bytes: out,
        width: dims.width,
        height: dims.height,
      );
    } catch (error, stackTrace) {
      if (error is AppException) {
        Error.throwWithStackTrace(error, stackTrace);
      }
      Error.throwWithStackTrace(
        const AppException.invalidPhotoType(),
        stackTrace,
      );
    }
  }
}
