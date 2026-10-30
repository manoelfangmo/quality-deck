import 'dart:typed_data';

import 'package:printing/printing.dart';

import 'package:app/features/proposals/application/pdf_file_handler.dart';
import 'package:app/features/proposals/data/http_pdf_file_handler.dart';

PdfFileHandler createPlatformPdfFileHandler() => IoPdfFileHandler();

class IoPdfFileHandler extends HttpPdfFileHandler {
  IoPdfFileHandler({super.client});

  @override
  bool get usesShareSheet => true;

  @override
  Future<void> share(Uint8List bytes, String fileName) {
    return Printing.sharePdf(bytes: bytes, filename: fileName);
  }

  @override
  Future<void> download(Uint8List bytes, String fileName) =>
      share(bytes, fileName);
}
