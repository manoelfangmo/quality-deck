import 'package:app/core/database/jobs_table.dart';
import 'package:app/core/database/rpc.dart';
import 'package:app/core/domain/pricing_type.dart';
import 'package:app/core/domain/quantity.dart';
import 'package:app/features/estimates/domain/job_type.dart';

String? _blankToNull(String? value) {
  final trimmed = value?.trim();
  if (trimmed == null || trimmed.isEmpty) return null;
  return trimmed;
}

class CreateJobCommand {
  const CreateJobCommand({
    required this.projectId,
    required this.title,
    required this.jobType,
    this.description,
  });

  final String projectId;
  final String title;
  final JobType jobType;
  final String? description;

  Map<String, dynamic> toJson() => {
    JobsTable.projectId: projectId,
    JobsTable.title: title.trim(),
    JobsTable.jobType: jobType.toDb(),
    JobsTable.description: _blankToNull(description),
  };
}

class UpdateJobCommand {
  const UpdateJobCommand({
    required this.id,
    required this.title,
    required this.jobType,
    this.description,
  });

  final String id;
  final String title;
  final JobType jobType;
  final String? description;

  Map<String, dynamic> toJson() => {
    JobsTable.title: title.trim(),
    JobsTable.jobType: jobType.toDb(),
    JobsTable.description: _blankToNull(description),
  };
}

class AddPriceListLineCommand {
  const AddPriceListLineCommand({
    required this.jobId,
    required this.priceItemId,
    required this.quantity,
  });

  final String jobId;
  final String priceItemId;
  final Quantity quantity;

  Map<String, dynamic> toJson() => {
    Rpc.pJobId: jobId,
    Rpc.pPriceItemId: priceItemId,
    Rpc.pQuantity: quantity.toDb(),
  };
}

class AddCustomLineCommand {
  const AddCustomLineCommand({
    required this.jobId,
    required this.name,
    this.description,
    required this.pricingType,
    required this.quantity,
    required this.priceCents,
  });

  final String jobId;
  final String name;
  final String? description;
  final PricingType pricingType;
  final Quantity quantity;
  final int priceCents;

  Map<String, dynamic> toJson() => {
    Rpc.pJobId: jobId,
    Rpc.pName: name.trim(),
    Rpc.pDescription: _blankToNull(description),
    Rpc.pPricingType: pricingType.toDb(),
    Rpc.pQuantity: quantity.toDb(),
    Rpc.pPriceCents: priceCents,
  };
}

class UpdateLineCommand {
  const UpdateLineCommand({
    required this.id,
    required this.quantity,
    this.description,
    this.overridePriceCents,
    this.name,
    this.pricingType,
    this.priceCents,
  });

  final String id;
  final Quantity quantity;
  final String? description;
  final int? overridePriceCents;
  final String? name;
  final PricingType? pricingType;
  final int? priceCents;

  Map<String, dynamic> toJson() => {
    Rpc.pId: id,
    Rpc.pQuantity: quantity.toDb(),
    Rpc.pDescription: _blankToNull(description),
    Rpc.pOverridePriceCents: overridePriceCents,
    Rpc.pName: name?.trim(),
    Rpc.pPricingType: pricingType?.toDb(),
    Rpc.pPriceCents: priceCents,
  };
}
