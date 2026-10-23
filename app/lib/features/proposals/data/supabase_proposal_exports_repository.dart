import 'dart:typed_data';

import 'package:supabase_flutter/supabase_flutter.dart';

import 'package:app/core/database/buckets.dart';
import 'package:app/core/database/proposal_exports_table.dart';
import 'package:app/core/database/users_table.dart';
import 'package:app/core/domain/app_exception.dart';
import 'package:app/features/proposals/application/proposal_export_service.dart';
import 'package:app/features/proposals/domain/proposal_export.dart';

class SupabaseProposalExportsRepository implements ProposalExportsRepository {
  SupabaseProposalExportsRepository(this._supabase);

  final SupabaseClient _supabase;

  @override
  Future<List<ProposalExportRecord>> listByProject(String projectId) async {
    final rows = await _supabase
        .from(ProposalExportsTable.name)
        .select(
          '*, ${UsersTable.name}!${ProposalExportsTable.createdBy} (${UsersTable.fullName})',
        )
        .eq(ProposalExportsTable.projectId, projectId)
        .order(ProposalExportsTable.createdAt, ascending: false)
        .order(ProposalExportsTable.version, ascending: false);
    return [
      for (final row in rows)
        ProposalExportRecord.fromJson(Map<String, dynamic>.from(row as Map)),
    ];
  }

  @override
  Future<String> signedUrl(String storagePath) async {
    try {
      return await _supabase.storage
          .from(Buckets.proposalPdfs)
          .createSignedUrl(storagePath, const Duration(hours: 1).inSeconds);
    } catch (error, stackTrace) {
      Error.throwWithStackTrace(
        const AppException("Couldn't open that PDF.", token: 'not_found'),
        stackTrace,
      );
    }
  }

  @override
  Future<Uint8List> download(String storagePath) async {
    try {
      return await _supabase.storage
          .from(Buckets.proposalPdfs)
          .download(storagePath);
    } catch (error, stackTrace) {
      Error.throwWithStackTrace(
        const AppException("Couldn't open the PDF.", token: 'pdf_download_failed'),
        stackTrace,
      );
    }
  }
}
