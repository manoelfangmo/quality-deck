import 'package:app/features/proposals/application/pdf_file_handler.dart';
import 'package:app/features/proposals/data/stub/stub_pdf_file_handler.dart'
    if (dart.library.js_interop) 'package:app/features/proposals/data/web/web_pdf_file_handler.dart'
    if (dart.library.io) 'package:app/features/proposals/data/io/io_pdf_file_handler.dart';

PdfFileHandler createPdfFileHandler() => createPlatformPdfFileHandler();
