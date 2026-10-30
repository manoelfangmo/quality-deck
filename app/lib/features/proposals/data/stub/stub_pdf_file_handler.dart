import 'dart:typed_data';

import 'package:app/features/proposals/application/pdf_file_handler.dart';
import 'package:app/features/proposals/data/http_pdf_file_handler.dart';

PdfFileHandler createPlatformPdfFileHandler() => StubPdfFileHandler();

class StubPdfFileHandler extends HttpPdfFileHandler {
  StubPdfFileHandler({super.client});

  @override
  bool get usesShareSheet => false;

  @override
  Future<void> share(Uint8List bytes, String fileName) async {}

  @override
  Future<void> download(Uint8List bytes, String fileName) async {}
}
