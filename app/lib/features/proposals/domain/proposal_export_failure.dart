import 'package:app/features/proposals/domain/proposal_export.dart';

sealed class ProposalExportFailure {
  const ProposalExportFailure();
}

class MissingDataFailure extends ProposalExportFailure {
  const MissingDataFailure(this.missing);
  final List<String> missing;
}

class PdfServiceFailure extends ProposalExportFailure {
  const PdfServiceFailure();
}

class ExportNotFoundFailure extends ProposalExportFailure {
  const ExportNotFoundFailure();
}

class ExportUnauthorizedFailure extends ProposalExportFailure {
  const ExportUnauthorizedFailure();
}

class InvalidExportRequestFailure extends ProposalExportFailure {
  const InvalidExportRequestFailure();
}

class ExportNetworkFailure extends ProposalExportFailure {
  const ExportNetworkFailure();
}

class ExportInternalFailure extends ProposalExportFailure {
  const ExportInternalFailure();
}

sealed class ExportOutcome {
  const ExportOutcome();
}

class ExportSuccess extends ExportOutcome {
  const ExportSuccess(this.export);
  final ProposalExport export;
}

class ExportFailure extends ExportOutcome {
  const ExportFailure(this.failure);
  final ProposalExportFailure failure;
}

String missingItemLabel(String key) {
  switch (key) {
    case 'business.name':
      return 'Business name is missing';
    case 'client.name':
      return 'Client name is missing';
    case 'project.siteAddress':
      return 'Site address is missing';
    case 'jobs':
      return 'Add at least one job';
  }
  final match = RegExp(r'^jobs\[(\d+)\]\.lineItems$').firstMatch(key);
  if (match != null) return 'Job ${match[1]} has no line items';
  return key;
}

String exportFailureMessage(ProposalExportFailure failure) {
  return switch (failure) {
    MissingDataFailure() => 'Some required information is missing.',
    PdfServiceFailure() => "Couldn't create the PDF. Try again.",
    ExportNotFoundFailure() => "This project couldn't be found. Refresh and try again.",
    ExportUnauthorizedFailure() => 'Sign in again to export this proposal.',
    InvalidExportRequestFailure() => "Couldn't create the PDF. Try again.",
    ExportNetworkFailure() => "Couldn't create the PDF. Try again.",
    ExportInternalFailure() => "Couldn't create the PDF. Try again.",
  };
}
