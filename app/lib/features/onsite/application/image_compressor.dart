import 'package:app/features/onsite/domain/compressed_photo.dart';
import 'package:app/features/onsite/domain/decoded_image.dart';

abstract interface class ImageCompressor {
  Future<CompressedPhoto> compress(DecodedImage image);
}
