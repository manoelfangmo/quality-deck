import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:app/features/proposals/data/proposal_export_providers.dart';
import 'package:app/features/proposals/domain/proposal_export_failure.dart';
import 'package:app/features/proposals/presentation/controllers/export_proposal.dart';

import '../../fakes.dart';

void main() {
  late FakeProposalExportService service;
  late FakePdfFileHandler files;
  late FakeProposalExportsRepository repo;
  late ProviderContainer container;

  setUp(() {
    service = FakeProposalExportService();
    files = FakePdfFileHandler();
    repo = FakeProposalExportsRepository();
    container = ProviderContainer(
      retry: (count, error) => null,
      overrides: [
        proposalExportServiceProvider.overrideWithValue(service),
        pdfFileHandlerProvider.overrideWithValue(files),
        proposalExportsRepositoryProvider.overrideWithValue(repo),
      ],
    );
    addTearDown(container.dispose);
  });

  test('success downloads the real PDF bytes', () async {
    final state = await container
        .read(exportProposalControllerProvider('proj-1').notifier)
        .export();

    expect(service.lastProjectId, 'proj-1');
    expect(repo.downloaded, ['biz/proj-1/v3-export-1.pdf']);
    expect(files.fetched, isEmpty);
    expect(state.export?.version, 3);
    expect(state.bytes, samplePdf);
    expect(state.creating, isFalse);
  });

  test('422 lists every missing item', () async {
    service.outcome = const ExportFailure(
      MissingDataFailure(['client.name', 'jobs[2].lineItems']),
    );

    final state = await container
        .read(exportProposalControllerProvider('proj-1').notifier)
        .export();

    expect(state.missing, ['client.name', 'jobs[2].lineItems']);
    expect(files.fetched, isEmpty);
  });

  test('openRecord downloads by storage path', () async {
    final state = await container
        .read(exportProposalControllerProvider('proj-1').notifier)
        .openRecord(sampleRecord);

    expect(repo.downloaded, ['biz/proj-1/v3-export-1.pdf']);
    expect(state.export?.version, 3);
    expect(state.bytes, samplePdf);
    expect(state.creating, isFalse);
  });

  test('502 is retryable', () async {
    service.outcome = const ExportFailure(PdfServiceFailure());

    final state = await container
        .read(exportProposalControllerProvider('proj-1').notifier)
        .export();

    expect(state.errorMessage, "Couldn't create the PDF. Try again.");
    expect(state.canRetry, isTrue);
  });
}
