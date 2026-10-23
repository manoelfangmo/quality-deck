import 'dart:js_interop';
import 'dart:typed_data';

import 'package:web/web.dart' as web;

import 'package:app/features/proposals/application/pdf_file_handler.dart';
import 'package:app/features/proposals/data/http_pdf_file_handler.dart';

PdfFileHandler createPlatformPdfFileHandler() => WebPdfFileHandler();

class WebPdfFileHandler extends HttpPdfFileHandler {
  WebPdfFileHandler({super.client});

  @override
  bool get usesShareSheet => false;

  @override
  Future<void> share(Uint8List bytes, String fileName) =>
      download(bytes, fileName);

  @override
  Future<void> download(Uint8List bytes, String fileName) async {
    final blob = web.Blob(
      [bytes.toJS].toJS,
      web.BlobPropertyBag(type: 'application/pdf'),
    );
    final url = web.URL.createObjectURL(blob);
    final anchor = web.document.createElement('a') as web.HTMLAnchorElement;
    anchor.href = url;
    anchor.download = fileName;
    web.document.body?.appendChild(anchor);
    anchor.click();
    anchor.remove();
    web.URL.revokeObjectURL(url);
  }
}
