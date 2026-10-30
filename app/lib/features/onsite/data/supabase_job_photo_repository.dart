import 'package:supabase_flutter/supabase_flutter.dart';

import 'package:app/core/database/job_photos_table.dart';
import 'package:app/core/domain/app_exception.dart';
import 'package:app/features/onsite/application/job_photo_repository.dart';
import 'package:app/features/onsite/domain/job_photo.dart';
import 'package:app/features/onsite/domain/photo_kind.dart';

class SupabaseJobPhotoRepository implements JobPhotoRepository {
  SupabaseJobPhotoRepository(this._supabase);

  final SupabaseClient _supabase;

  @override
  Future<JobPhoto> insert(JobPhotoInsert insert) async {
    try {
      final row = await _supabase
          .from(JobPhotosTable.name)
          .insert({
            JobPhotosTable.id: insert.id,
            JobPhotosTable.jobId: insert.jobId,
            JobPhotosTable.kind: insert.kind.toDb(),
            JobPhotosTable.storagePath: insert.storagePath,
            JobPhotosTable.width: insert.width,
            JobPhotosTable.height: insert.height,
          })
          .select()
          .single();
      return JobPhoto.fromJson(row);
    } catch (error, stackTrace) {
      AppException.throwFrom(error, stackTrace);
    }
  }

  @override
  Future<void> delete(String id) async {
    try {
      final rows = await _supabase
          .from(JobPhotosTable.name)
          .delete()
          .eq(JobPhotosTable.id, id)
          .select();
      if (rows.isEmpty) {
        throw const AppException.photoNotFound();
      }
    } catch (error, stackTrace) {
      AppException.throwFrom(error, stackTrace);
    }
  }

  @override
  Future<List<JobPhoto>> listByJob(String jobId) async {
    final rows = await _supabase
        .from(JobPhotosTable.name)
        .select()
        .eq(JobPhotosTable.jobId, jobId)
        .order(JobPhotosTable.createdAt, ascending: true)
        .order(JobPhotosTable.id, ascending: true);
    return [for (final row in rows) JobPhoto.fromJson(row)];
  }

  @override
  Future<int> count(String jobId, PhotoKind kind) async {
    final rows = await _supabase
        .from(JobPhotosTable.name)
        .select(JobPhotosTable.id)
        .eq(JobPhotosTable.jobId, jobId)
        .eq(JobPhotosTable.kind, kind.toDb());
    return rows.length;
  }
}
