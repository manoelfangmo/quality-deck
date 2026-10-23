import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'package:app/core/utils/providers.dart';
import 'package:app/features/proposals/application/pdf_file_handler.dart';
import 'package:app/features/proposals/application/proposal_export_service.dart';
import 'package:app/features/proposals/data/pdf_file_handler_factory.dart';
import 'package:app/features/proposals/data/supabase_proposal_export_service.dart';
import 'package:app/features/proposals/data/supabase_proposal_exports_repository.dart';
import 'package:app/features/proposals/domain/proposal_export.dart';

part 'proposal_export_providers.g.dart';

@riverpod
ProposalExportService proposalExportService(Ref ref) {
  return SupabaseProposalExportService(ref.watch(supabaseProvider));
}

@riverpod
ProposalExportsRepository proposalExportsRepository(Ref ref) {
  return SupabaseProposalExportsRepository(ref.watch(supabaseProvider));
}

@riverpod
PdfFileHandler pdfFileHandler(Ref ref) => createPdfFileHandler();

@riverpod
Future<List<ProposalExportRecord>> proposalExports(Ref ref, String projectId) {
  return ref.watch(proposalExportsRepositoryProvider).listByProject(projectId);
}
