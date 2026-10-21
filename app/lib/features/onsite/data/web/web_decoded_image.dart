import 'package:web/web.dart' as web;

import 'package:app/features/onsite/domain/decoded_image.dart';

class WebDecodedImage implements DecodedImage {
  WebDecodedImage(this.bitmap);

  final web.ImageBitmap bitmap;

  @override
  int get width => bitmap.width;

  @override
  int get height => bitmap.height;

  @override
  void close() => bitmap.close();
}
