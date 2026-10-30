import 'dart:convert';

import 'package:supabase_flutter/supabase_flutter.dart';

import 'package:app/core/database/proposal_exports_table.dart';
import 'package:app/features/proposals/application/proposal_export_service.dart';
import 'package:app/features/proposals/domain/proposal_export.dart';
import 'package:app/features/proposals/domain/proposal_export_failure.dart';

class SupabaseProposalExportService implements ProposalExportService {
  SupabaseProposalExportService(this._supabase);

  final SupabaseClient _supabase;

  @override
  Future<ExportOutcome> export(String projectId) async {
    try {
      final response = await _supabase.functions.invoke(
        EdgeFunctions.exportProposal,
        body: {'projectId': projectId},
      );
      final data = response.data;
      if (data is Map<String, dynamic>) {
        return ExportSuccess(ProposalExport.fromJson(data));
      }
      if (data is Map) {
        return ExportSuccess(
          ProposalExport.fromJson(Map<String, dynamic>.from(data)),
        );
      }
      return const ExportFailure(ExportInternalFailure());
    } on FunctionException catch (error) {
      return ExportFailure(_fromFunctionException(error));
    } catch (_) {
      return const ExportFailure(ExportNetworkFailure());
    }
  }
}

ProposalExportFailure mapFunctionError({
  required int status,
  required Object? details,
}) {
  final body = _asMap(details);
  final code = body?['error'] as String?;
  switch (status) {
    case 400:
      return const InvalidExportRequestFailure();
    case 401:
      return const ExportUnauthorizedFailure();
    case 404:
      return const ExportNotFoundFailure();
    case 422:
      final missing = body?['missing'];
      return MissingDataFailure(
        missing is List ? [for (final item in missing) item.toString()] : const [],
      );
    case 502:
      return const PdfServiceFailure();
    default:
      if (code == 'missing_data') {
        final missing = body?['missing'];
        return MissingDataFailure(
          missing is List
              ? [for (final item in missing) item.toString()]
              : const [],
        );
      }
      if (code == 'pdf_service_failed') return const PdfServiceFailure();
      return const ExportInternalFailure();
  }
}

ProposalExportFailure _fromFunctionException(FunctionException error) {
  return mapFunctionError(status: error.status, details: error.details);
}

Map<String, dynamic>? _asMap(Object? details) {
  if (details is Map<String, dynamic>) return details;
  if (details is Map) return Map<String, dynamic>.from(details);
  if (details is String) {
    try {
      final decoded = jsonDecode(details);
      if (decoded is Map<String, dynamic>) return decoded;
      if (decoded is Map) return Map<String, dynamic>.from(decoded);
    } catch (_) {}
  }
  return null;
}
