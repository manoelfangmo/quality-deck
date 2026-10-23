import 'dart:typed_data';

abstract interface class PdfFileHandler {
  Future<Uint8List> fetchBytes(String url);

  Future<void> share(Uint8List bytes, String fileName);

  Future<void> download(Uint8List bytes, String fileName);

  bool get usesShareSheet;
}
