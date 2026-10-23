import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:app/features/proposals/data/proposal_export_providers.dart';
import 'package:app/features/proposals/domain/proposal_export.dart';
import 'package:app/features/proposals/presentation/widgets/pdf_document_view.dart';

class PdfPreviewPage extends ConsumerWidget {
  const PdfPreviewPage({
    required this.export,
    required this.bytes,
    super.key,
  });

  final ProposalExport export;
  final Uint8List bytes;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final handler = ref.watch(pdfFileHandlerProvider);
    final actionLabel = handler.usesShareSheet ? 'Share' : 'Download';

    return Scaffold(
      appBar: AppBar(
        title: Text('Proposal v${export.version}'),
        actions: [
          TextButton(
            onPressed: () {
              if (handler.usesShareSheet) {
                handler.share(bytes, export.fileName);
              } else {
                handler.download(bytes, export.fileName);
              }
            },
            child: Text(actionLabel),
          ),
        ],
      ),
      body: buildPdfDocumentView(bytes: bytes, fileName: export.fileName),
    );
  }
}

Future<void> openPdfPreview(
  BuildContext context, {
  required ProposalExport export,
  required Uint8List bytes,
}) {
  return Navigator.of(context).push(
    MaterialPageRoute<void>(
      builder: (context) => PdfPreviewPage(export: export, bytes: bytes),
    ),
  );
}
