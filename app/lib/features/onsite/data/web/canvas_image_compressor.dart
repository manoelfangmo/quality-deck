import 'dart:async';
import 'dart:js_interop';

import 'package:web/web.dart' as web;

import 'package:app/core/domain/app_exception.dart';
import 'package:app/features/onsite/application/image_compressor.dart';
import 'package:app/features/onsite/data/jpeg_dimensions.dart';
import 'package:app/features/onsite/data/web/web_blobs.dart';
import 'package:app/features/onsite/data/web/web_decoded_image.dart';
import 'package:app/features/onsite/domain/compressed_photo.dart';
import 'package:app/features/onsite/domain/decoded_image.dart';
import 'package:app/features/onsite/domain/job_photo_limits.dart';

class CanvasImageCompressor implements ImageCompressor {
  @override
  Future<CompressedPhoto> compress(DecodedImage image) async {
    if (image is! WebDecodedImage) {
      throw const AppException.invalidPhotoType();
    }
    final bitmap = image.bitmap;
    final size = _fit(bitmap.width, bitmap.height);
    final blob = await _encode(bitmap, size.width, size.height);
    final bytes = await bytesFromBlob(blob);
    final dims = jpegDimensions(bytes);
    return CompressedPhoto(
      bytes: bytes,
      width: dims?.width ?? size.width,
      height: dims?.height ?? size.height,
    );
  }

  ({int width, int height}) _fit(int width, int height) {
    final longEdge = width > height ? width : height;
    if (longEdge <= JobPhotoLimits.maxLongEdge) {
      return (width: width, height: height);
    }
    final scale = JobPhotoLimits.maxLongEdge / longEdge;
    return (
      width: (width * scale).round().clamp(1, JobPhotoLimits.maxLongEdge),
      height: (height * scale).round().clamp(1, JobPhotoLimits.maxLongEdge),
    );
  }

  Future<web.Blob> _encode(
    web.ImageBitmap bitmap,
    int width,
    int height,
  ) async {
    try {
      final canvas = web.OffscreenCanvas(width, height);
      final ctx = canvas.getContext('2d');
      if (ctx == null) {
        throw StateError('no 2d context');
      }
      (ctx as web.OffscreenCanvasRenderingContext2D).drawImage(
        bitmap,
        0,
        0,
        width,
        height,
      );
      return await canvas
          .convertToBlob(
            web.ImageEncodeOptions(
              type: 'image/jpeg',
              quality: JobPhotoLimits.jpegQualityFraction,
            ),
          )
          .toDart;
    } catch (_) {
      return _encodeOnDomCanvas(bitmap, width, height);
    }
  }

  Future<web.Blob> _encodeOnDomCanvas(
    web.ImageBitmap bitmap,
    int width,
    int height,
  ) {
    final canvas = web.HTMLCanvasElement()
      ..width = width
      ..height = height;
    canvas.context2D.drawImage(bitmap, 0, 0, width, height);
    final done = Completer<web.Blob>();
    canvas.toBlob(
      (web.Blob? blob) {
        if (blob == null) {
          done.completeError(const AppException.uploadFailed());
        } else {
          done.complete(blob);
        }
      }.toJS,
      'image/jpeg',
      JobPhotoLimits.jpegQualityFraction.toJS,
    );
    return done.future;
  }
}
