import 'package:freezed_annotation/freezed_annotation.dart';

import 'package:app/core/database/jobs_table.dart';
import 'package:app/core/domain/money.dart';
import 'package:app/core/domain/quantity.dart';
import 'package:app/core/utils/json_converters.dart';
import 'package:app/features/estimates/domain/job_type.dart';
import 'package:app/features/estimates/domain/labor.dart';

part 'job.freezed.dart';

@freezed
abstract class Job with _$Job {
  const Job._();

  const factory Job({
    required String id,
    required String projectId,
    required String title,
    required JobType jobType,
    String? description,
    Labor? labor,
    String? alternateOfJobId,
    required DateTime createdAt,
    @Default(0) int number,
  }) = _Job;

  factory Job.fromJson(Map<String, dynamic> json) {
    return Job(
      id: json[JobsTable.id] as String,
      projectId: json[JobsTable.projectId] as String,
      title: json[JobsTable.title] as String,
      jobType: JobType.fromDb(json[JobsTable.jobType] as String),
      description: json[JobsTable.description] as String?,
      labor: _labor(json),
      alternateOfJobId: json[JobsTable.alternateOfJobId] as String?,
      createdAt: const UtcToLocalConverter().fromJson(
        json[JobsTable.createdAt] as String,
      ),
    );
  }

  String get numberedTitle => '$number. $title';

  bool get isAlternate => alternateOfJobId != null;
}

Labor? _labor(Map<String, dynamic> json) {
  final hours = json[JobsTable.laborHours];
  final rate = json[JobsTable.laborRateCents];
  if (hours == null || rate == null) return null;
  return Labor(
    hours: Quantity.fromDb(hours as Object),
    rate: Money(rate as int),
  );
}
