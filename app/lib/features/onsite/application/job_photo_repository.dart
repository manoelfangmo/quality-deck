import 'package:app/features/onsite/domain/job_photo.dart';
import 'package:app/features/onsite/domain/photo_kind.dart';

abstract interface class JobPhotoRepository {
  Future<JobPhoto> insert(JobPhotoInsert insert);

  Future<void> delete(String id);

  Future<List<JobPhoto>> listByJob(String jobId);

  Future<int> count(String jobId, PhotoKind kind);
}

class JobPhotoInsert {
  const JobPhotoInsert({
    required this.id,
    required this.jobId,
    required this.kind,
    required this.storagePath,
    required this.width,
    required this.height,
  });

  final String id;
  final String jobId;
  final PhotoKind kind;
  final String storagePath;
  final int width;
  final int height;
}
