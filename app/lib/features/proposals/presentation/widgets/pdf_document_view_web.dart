import 'dart:js_interop';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:web/web.dart' as web;

Widget createPdfDocumentView({
  required Uint8List bytes,
  required String fileName,
}) {
  return _WebPdfFrame(bytes: bytes, fileName: fileName);
}

class _WebPdfFrame extends StatefulWidget {
  const _WebPdfFrame({required this.bytes, required this.fileName});

  final Uint8List bytes;
  final String fileName;

  @override
  State<_WebPdfFrame> createState() => _WebPdfFrameState();
}

class _WebPdfFrameState extends State<_WebPdfFrame> {
  late final String _url;

  @override
  void initState() {
    super.initState();
    final blob = web.Blob(
      [widget.bytes.toJS].toJS,
      web.BlobPropertyBag(type: 'application/pdf'),
    );
    _url = web.URL.createObjectURL(blob);
  }

  @override
  void dispose() {
    web.URL.revokeObjectURL(_url);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return HtmlElementView.fromTagName(
      tagName: 'iframe',
      onElementCreated: (element) {
        final iframe = element as web.HTMLIFrameElement;
        iframe
          ..src = _url
          ..title = widget.fileName
          ..style.border = 'none'
          ..style.width = '100%'
          ..style.height = '100%';
      },
    );
  }
}
