import 'dart:typed_data';

import 'package:app/features/onsite/domain/decoded_image.dart';

class BytesDecodedImage implements DecodedImage {
  BytesDecodedImage(this.bytes);

  final Uint8List bytes;

  @override
  int get width => 0;

  @override
  int get height => 0;

  @override
  void close() {}
}
