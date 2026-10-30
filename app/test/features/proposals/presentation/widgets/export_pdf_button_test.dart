import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:app/features/proposals/data/proposal_export_providers.dart';
import 'package:app/features/proposals/presentation/widgets/export_pdf_button.dart';
import 'package:app/features/proposals/presentation/widgets/pdf_preview_page.dart';

import '../../fakes.dart';

void main() {
  testWidgets('opens the preview after a successful export', (tester) async {
    tester.view.physicalSize = const Size(800, 1200);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(
      ProviderScope(
        retry: (count, error) => null,
        overrides: [
          proposalExportServiceProvider.overrideWithValue(
            FakeProposalExportService(),
          ),
          proposalExportsRepositoryProvider.overrideWithValue(
            FakeProposalExportsRepository(),
          ),
          pdfFileHandlerProvider.overrideWithValue(FakePdfFileHandler()),
        ],
        child: const MaterialApp(
          home: Scaffold(body: ExportPdfButton(projectId: 'proj-1')),
        ),
      ),
    );

    await tester.tap(find.text('Export PDF'));
    await tester.pump();
    await tester.pump();

    expect(find.byType(PdfPreviewPage), findsOneWidget);
    expect(find.text('Proposal v3'), findsOneWidget);
  });
}
