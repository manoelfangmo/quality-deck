import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:printing/printing.dart';

Widget createPdfDocumentView({
  required Uint8List bytes,
  required String fileName,
}) {
  return PdfPreview(
    build: (_) async => bytes,
    canChangeOrientation: false,
    canChangePageFormat: false,
    canDebug: false,
    allowPrinting: false,
    allowSharing: false,
    useActions: false,
    pdfFileName: fileName,
    onError: (context, error) => const Center(
      child: Text("Couldn't open the PDF."),
    ),
  );
}
