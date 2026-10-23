import 'package:app/core/database/proposal_exports_table.dart';
import 'package:app/core/domain/money.dart';
import 'package:app/core/utils/json_converters.dart';

class ProposalExport {
  const ProposalExport({
    required this.id,
    required this.version,
    required this.fileName,
    required this.storagePath,
    required this.url,
    required this.urlExpiresAt,
    this.pageCount,
  });

  final String id;
  final int version;
  final String fileName;
  final String storagePath;
  final String url;
  final DateTime urlExpiresAt;
  final int? pageCount;

  factory ProposalExport.fromJson(Map<String, dynamic> json) {
    return ProposalExport(
      id: json['exportId'] as String,
      version: (json['version'] as num).toInt(),
      fileName: json['fileName'] as String,
      storagePath: json['storagePath'] as String,
      url: json['url'] as String,
      urlExpiresAt: DateTime.parse(json['urlExpiresAt'] as String).toUtc(),
      pageCount: (json['pageCount'] as num?)?.toInt(),
    );
  }
}

class ProposalExportRecord {
  const ProposalExportRecord({
    required this.id,
    required this.version,
    required this.proposalNumber,
    required this.storagePath,
    required this.total,
    this.pageCount,
    required this.createdByName,
    required this.createdAt,
  });

  final String id;
  final int version;
  final String proposalNumber;
  final String storagePath;
  final Money total;
  final int? pageCount;
  final String createdByName;
  final DateTime createdAt;

  String get fileName => 'Proposal-$proposalNumber-v$version.pdf';

  factory ProposalExportRecord.fromJson(Map<String, dynamic> json) {
    final user = json['users'];
    final name = user is Map<String, dynamic>
        ? user['full_name'] as String? ?? 'Member'
        : 'Member';
    return ProposalExportRecord(
      id: json[ProposalExportsTable.id] as String,
      version: json[ProposalExportsTable.version] as int,
      proposalNumber: json[ProposalExportsTable.proposalNumber] as String,
      storagePath: json[ProposalExportsTable.storagePath] as String,
      total: Money(json[ProposalExportsTable.totalCents] as int),
      pageCount: json[ProposalExportsTable.pageCount] as int?,
      createdByName: name,
      createdAt: const UtcToLocalConverter().fromJson(
        json[ProposalExportsTable.createdAt] as String,
      ),
    );
  }
}
