import 'dart:typed_data';

import 'package:http/http.dart' as http;

import 'package:app/core/domain/app_exception.dart';
import 'package:app/features/proposals/application/pdf_file_handler.dart';

abstract class HttpPdfFileHandler implements PdfFileHandler {
  HttpPdfFileHandler({http.Client? client}) : _client = client ?? http.Client();

  final http.Client _client;

  @override
  Future<Uint8List> fetchBytes(String url) async {
    try {
      final response = await _client.get(Uri.parse(url));
      if (response.statusCode != 200 || response.bodyBytes.isEmpty) {
        throw const AppException("Couldn't open the PDF.", token: 'pdf_download_failed');
      }
      return response.bodyBytes;
    } on AppException {
      rethrow;
    } catch (error, stackTrace) {
      Error.throwWithStackTrace(
        const AppException("Couldn't open the PDF.", token: 'pdf_download_failed'),
        stackTrace,
      );
    }
  }
}
