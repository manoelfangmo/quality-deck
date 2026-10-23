import 'dart:typed_data';

import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'package:app/core/domain/app_exception.dart';
import 'package:app/features/proposals/data/proposal_export_providers.dart';
import 'package:app/features/proposals/domain/proposal_export.dart';
import 'package:app/features/proposals/domain/proposal_export_failure.dart';

part 'export_proposal.freezed.dart';
part 'export_proposal.g.dart';

@freezed
abstract class ExportProposalState with _$ExportProposalState {
  const factory ExportProposalState({
    @Default(false) bool creating,
    ProposalExport? export,
    Uint8List? bytes,
    List<String>? missing,
    String? errorMessage,
    @Default(false) bool canRetry,
  }) = _ExportProposalState;
}

@riverpod
class ExportProposalController extends _$ExportProposalController {
  @override
  ExportProposalState build(String projectId) => const ExportProposalState();

  Future<ExportProposalState> export() async {
    final link = ref.keepAlive();
    state = const ExportProposalState(creating: true);
    try {
      final outcome = await ref
          .read(proposalExportServiceProvider)
          .export(projectId);
      if (!ref.mounted) return state;
      switch (outcome) {
        case ExportSuccess(:final export):
          final bytes = await ref
              .read(proposalExportsRepositoryProvider)
              .download(export.storagePath);
          if (!ref.mounted) return state;
          state = ExportProposalState(export: export, bytes: bytes);
          ref.invalidate(proposalExportsProvider(projectId));
          return state;
        case ExportFailure(:final failure):
          state = _fromFailure(failure);
          return state;
      }
    } on AppException catch (error) {
      if (!ref.mounted) return state;
      state = ExportProposalState(
        errorMessage: error.message,
        canRetry: true,
      );
      return state;
    } catch (_) {
      if (!ref.mounted) return state;
      state = const ExportProposalState(
        errorMessage: "Couldn't create the PDF. Try again.",
        canRetry: true,
      );
      return state;
    } finally {
      link.close();
    }
  }

  Future<ExportProposalState> openRecord(ProposalExportRecord record) async {
    final link = ref.keepAlive();
    state = const ExportProposalState(creating: true);
    try {
      final repo = ref.read(proposalExportsRepositoryProvider);
      final bytes = await repo.download(record.storagePath);
      if (!ref.mounted) return state;
      state = ExportProposalState(
        export: ProposalExport(
          id: record.id,
          version: record.version,
          fileName: record.fileName,
          storagePath: record.storagePath,
          url: '',
          urlExpiresAt: DateTime.now().toUtc().add(const Duration(hours: 1)),
          pageCount: record.pageCount,
        ),
        bytes: bytes,
      );
      return state;
    } on AppException catch (error) {
      if (!ref.mounted) return state;
      state = ExportProposalState(
        errorMessage: error.message,
        canRetry: false,
      );
      return state;
    } catch (_) {
      if (!ref.mounted) return state;
      state = const ExportProposalState(
        errorMessage: "Couldn't open the PDF.",
        canRetry: false,
      );
      return state;
    } finally {
      link.close();
    }
  }

  void clearResult() {
    if (state.creating) return;
    state = const ExportProposalState();
  }

  ExportProposalState _fromFailure(ProposalExportFailure failure) {
    if (failure is MissingDataFailure) {
      return ExportProposalState(missing: failure.missing);
    }
    return ExportProposalState(
      errorMessage: exportFailureMessage(failure),
      canRetry: failure is PdfServiceFailure ||
          failure is ExportNetworkFailure ||
          failure is ExportInternalFailure,
    );
  }
}
