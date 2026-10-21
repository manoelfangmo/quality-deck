import 'dart:js_interop';
import 'dart:typed_data';

import 'package:web/web.dart' as web;

web.Blob blobFromBytes(Uint8List bytes, String type) {
  return web.Blob([bytes.toJS].toJS, web.BlobPropertyBag(type: type));
}

Future<Uint8List> bytesFromBlob(web.Blob blob) async {
  final buffer = await blob.arrayBuffer().toDart;
  return buffer.toDart.asUint8List();
}

Future<web.ImageBitmap> bitmapFromBlob(web.Blob blob) {
  return web.window.createImageBitmap(blob).toDart;
}
