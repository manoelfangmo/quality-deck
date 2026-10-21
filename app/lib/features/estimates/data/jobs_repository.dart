import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'package:app/core/database/jobs_table.dart';
import 'package:app/core/database/line_items_table.dart';
import 'package:app/core/domain/app_exception.dart';
import 'package:app/core/utils/providers.dart';
import 'package:app/features/estimates/data/models.dart';
import 'package:app/features/estimates/domain/job.dart';
import 'package:app/features/estimates/domain/job_with_lines.dart';
import 'package:app/features/estimates/domain/labor.dart';
import 'package:app/features/estimates/domain/line_item.dart';

part 'jobs_repository.g.dart';

@riverpod
JobsRepository jobsRepository(Ref ref) {
  return JobsRepository(ref.watch(supabaseProvider));
}

class JobsRepository {
  JobsRepository(this._supabase);

  final SupabaseClient _supabase;

  Future<List<JobWithLines>> fetchForProject(String projectId) async {
    final rows = await _supabase
        .from(JobsTable.name)
        .select('*, ${LineItemsTable.name}(*)')
        .eq(JobsTable.projectId, projectId)
        .order(JobsTable.createdAt, ascending: true)
        .order(JobsTable.id, ascending: true)
        .order(
          LineItemsTable.position,
          referencedTable: LineItemsTable.name,
          ascending: true,
        );

    return [
      for (var i = 0; i < rows.length; i++)
        _fromRow(Map<String, dynamic>.from(rows[i] as Map), number: i + 1),
    ];
  }

  Future<Job> create(CreateJobCommand command) async {
    try {
      final row = await _supabase
          .from(JobsTable.name)
          .insert(command.toJson())
          .select()
          .single();
      return Job.fromJson(row);
    } catch (error, stackTrace) {
      AppException.throwFrom(error, stackTrace);
    }
  }

  Future<Job> update(UpdateJobCommand command) async {
    try {
      final row = await _supabase
          .from(JobsTable.name)
          .update(command.toJson())
          .eq(JobsTable.id, command.id)
          .select()
          .maybeSingle();
      if (row == null) {
        throw const AppException.jobNotFound();
      }
      return Job.fromJson(row);
    } catch (error, stackTrace) {
      AppException.throwFrom(error, stackTrace);
    }
  }

  Future<void> delete(String jobId) async {
    try {
      final row = await _supabase
          .from(JobsTable.name)
          .delete()
          .eq(JobsTable.id, jobId)
          .select()
          .maybeSingle();
      if (row == null) {
        throw const AppException.jobNotFound();
      }
    } catch (error, stackTrace) {
      AppException.throwFrom(error, stackTrace);
    }
  }

  Future<void> setLabor(String jobId, Labor? labor) async {
    try {
      final row = await _supabase
          .from(JobsTable.name)
          .update({
            JobsTable.laborHours: labor?.hours.toDb(),
            JobsTable.laborRateCents: labor?.rate.cents,
          })
          .eq(JobsTable.id, jobId)
          .select()
          .maybeSingle();
      if (row == null) {
        throw const AppException.jobNotFound();
      }
    } catch (error, stackTrace) {
      AppException.throwFrom(error, stackTrace);
    }
  }

  JobWithLines _fromRow(Map<String, dynamic> json, {required int number}) {
    final rawLines = json[LineItemsTable.name];
    final lines = rawLines is List
        ? [
            for (final line in rawLines)
              LineItem.fromJson(Map<String, dynamic>.from(line as Map)),
          ]
        : <LineItem>[];
    return JobWithLines(
      job: Job.fromJson(json).copyWith(number: number),
      lines: lines,
    );
  }
}
