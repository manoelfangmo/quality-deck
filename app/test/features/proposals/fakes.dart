import 'dart:typed_data';

import 'package:app/core/domain/money.dart';
import 'package:app/features/proposals/application/pdf_file_handler.dart';
import 'package:app/features/proposals/application/proposal_export_service.dart';
import 'package:app/features/proposals/domain/proposal_export.dart';
import 'package:app/features/proposals/domain/proposal_export_failure.dart';

final samplePdf = Uint8List.fromList('%PDF-1.4'.codeUnits);

final sampleRecord = ProposalExportRecord(
  id: 'export-1',
  version: 3,
  proposalNumber: 'QD-2026-0001',
  storagePath: 'biz/proj-1/v3-export-1.pdf',
  total: const Money(1245000),
  pageCount: 4,
  createdByName: 'Moises',
  createdAt: DateTime.utc(2026, 10, 21, 21),
);

final sampleExport = ProposalExport(
  id: 'export-1',
  version: 3,
  fileName: 'Quality-Deck-Proposal-Melgar-Deck-v3.pdf',
  storagePath: 'biz/proj-1/v3-export-1.pdf',
  url: 'https://signed.test/proposal.pdf',
  urlExpiresAt: DateTime.utc(2026, 10, 21, 21),
  pageCount: 4,
);

class FakeProposalExportService implements ProposalExportService {
  ExportOutcome outcome = ExportSuccess(sampleExport);
  String? lastProjectId;
  var calls = 0;

  @override
  Future<ExportOutcome> export(String projectId) async {
    calls += 1;
    lastProjectId = projectId;
    return outcome;
  }
}

class FakeProposalExportsRepository implements ProposalExportsRepository {
  final records = <ProposalExportRecord>[];
  final urls = <String, String>{};
  final downloaded = <String>[];
  Uint8List bytes = samplePdf;
  var failSign = false;
  var failDownload = false;

  @override
  Future<List<ProposalExportRecord>> listByProject(String projectId) async {
    return records;
  }

  @override
  Future<String> signedUrl(String storagePath) async {
    if (failSign) throw StateError('sign failed');
    return urls[storagePath] ?? 'https://signed.test/$storagePath';
  }

  @override
  Future<Uint8List> download(String storagePath) async {
    downloaded.add(storagePath);
    if (failDownload) throw StateError('download failed');
    return bytes;
  }
}

class FakePdfFileHandler implements PdfFileHandler {
  final fetched = <String>[];
  final shared = <String>[];
  final downloaded = <String>[];
  Uint8List bytes = samplePdf;
  var failFetch = false;
  @override
  var usesShareSheet = false;

  @override
  Future<Uint8List> fetchBytes(String url) async {
    fetched.add(url);
    if (failFetch) throw StateError('download failed');
    return bytes;
  }

  @override
  Future<void> share(Uint8List bytes, String fileName) async {
    shared.add(fileName);
  }

  @override
  Future<void> download(Uint8List bytes, String fileName) async {
    downloaded.add(fileName);
  }
}
