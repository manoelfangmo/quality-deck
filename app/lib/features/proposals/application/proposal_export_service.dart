import 'dart:typed_data';

import 'package:app/features/proposals/domain/proposal_export.dart';
import 'package:app/features/proposals/domain/proposal_export_failure.dart';

abstract interface class ProposalExportService {
  Future<ExportOutcome> export(String projectId);
}

abstract interface class ProposalExportsRepository {
  Future<List<ProposalExportRecord>> listByProject(String projectId);

  Future<String> signedUrl(String storagePath);

  Future<Uint8List> download(String storagePath);
}
