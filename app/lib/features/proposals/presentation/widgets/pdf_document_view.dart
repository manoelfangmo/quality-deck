import 'dart:typed_data';

import 'package:flutter/widgets.dart';

import 'package:app/features/proposals/presentation/widgets/pdf_document_view_fallback.dart'
    if (dart.library.js_interop) 'package:app/features/proposals/presentation/widgets/pdf_document_view_web.dart';

Widget buildPdfDocumentView({
  required Uint8List bytes,
  required String fileName,
}) =>
    createPdfDocumentView(bytes: bytes, fileName: fileName);
