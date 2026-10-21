@Tags(<String>['contract'])
library;

import 'package:flutter_test/flutter_test.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'package:app/core/database/buckets.dart';
import 'package:app/core/domain/app_exception.dart';
import 'package:app/features/clients/data/clients_repository.dart';
import 'package:app/features/estimates/data/jobs_repository.dart';
import 'package:app/features/estimates/data/models.dart';
import 'package:app/features/estimates/domain/job_type.dart';
import 'package:app/features/onsite/application/job_photo_repository.dart';
import 'package:app/features/onsite/data/supabase_job_photo_repository.dart';
import 'package:app/features/onsite/data/supabase_photo_storage.dart';
import 'package:app/features/onsite/domain/job_photo.dart';
import 'package:app/features/onsite/domain/job_photo_limits.dart';
import 'package:app/features/onsite/domain/photo_kind.dart';
import 'package:app/features/projects/data/projects_repository.dart';

import 'clean_up.dart';
import 'helpers.dart';

void main() {
  SupabaseClient? supabase;
  late JobsRepository jobs;
  late ProjectsRepository projects;
  late ClientsRepository clients;
  late SupabaseJobPhotoRepository photos;
  late SupabasePhotoStorage storage;
  late ContractCleanup cleanup;

  setUpAll(() async {
    supabase = await signInAsSeededOwner();
    jobs = JobsRepository(supabase!);
    projects = ProjectsRepository(supabase!);
    clients = ClientsRepository(supabase!);
    photos = SupabaseJobPhotoRepository(supabase!);
    storage = SupabasePhotoStorage(supabase!);
    cleanup = ContractCleanup();
  });

  tearDown(() async {
    await cleanup.teardown();
  });

  tearDownAll(() async {
    await cleanup.dispose();
    await supabase?.auth.signOut();
    await supabase?.dispose();
  });

  Future<({String jobId, String projectId})> arrangeJob() async {
    final created = await createUniqueProject(
      projects: projects,
      clients: clients,
    );
    cleanup.trackClient(created.clientId);
    cleanup.trackProject(created.projectId);
    final job = await jobs.create(
      CreateJobCommand(
        projectId: created.projectId,
        title: 'CT Photos ${uniqueStamp()}',
        jobType: JobType.deck,
      ),
    );
    return (jobId: job.id, projectId: created.projectId);
  }

  Future<JobPhoto> addPhoto(String jobId, PhotoKind kind) async {
    final id = uniqueUuid();
    final path = '${SeedUsers.qualityDeckId}/$jobId/$id.jpg';
    await storage.upload(path, jpeg1x1);
    cleanup.trackStorageObject(bucket: Buckets.jobPhotos, path: path);
    return photos.insert(
      JobPhotoInsert(
        id: id,
        jobId: jobId,
        kind: kind,
        storagePath: path,
        width: 1,
        height: 1,
      ),
    );
  }

  group('JobPhotoRepository.insert', () {
    test('stores a photo that the next list returns', () async {
      final job = await arrangeJob();
      final id = uniqueUuid();
      final path = '${SeedUsers.qualityDeckId}/${job.jobId}/$id.jpg';

      await storage.upload(path, jpeg1x1);
      cleanup.trackStorageObject(bucket: Buckets.jobPhotos, path: path);
      final photo = await photos.insert(
        JobPhotoInsert(
          id: id,
          jobId: job.jobId,
          kind: PhotoKind.before,
          storagePath: path,
          width: 1,
          height: 1,
        ),
      );

      expect(photo.id, id);
      expect(photo.jobId, job.jobId);
      expect(photo.kind, PhotoKind.before);
      expect(photo.storagePath, path);
      expect(photo.width, 1);
      expect(photo.height, 1);
      expect(photo.createdBy, SeedUsers.ownerId);

      final listed = await photos.listByJob(job.jobId);
      expect(listed.map((row) => row.id), contains(id));

      final url = await storage.signedUrl(path, JobPhotoLimits.signedUrlTtl);
      expect(url, startsWith('http'));
    });

    test('the 11th photo of a kind raises photo_limit_reached', () async {
      final job = await arrangeJob();
      for (var i = 0; i < JobPhotoLimits.maxPerGallery; i++) {
        await addPhoto(job.jobId, PhotoKind.after);
      }

      final extraId = uniqueUuid();
      final extraPath = '${SeedUsers.qualityDeckId}/${job.jobId}/$extraId.jpg';
      await storage.upload(extraPath, jpeg1x1);
      cleanup.trackStorageObject(bucket: Buckets.jobPhotos, path: extraPath);

      try {
        await photos.insert(
          JobPhotoInsert(
            id: extraId,
            jobId: job.jobId,
            kind: PhotoKind.after,
            storagePath: extraPath,
            width: 1,
            height: 1,
          ),
        );
        fail('expected AppException');
      } on AppException catch (error) {
        expect(error.token, 'photo_limit_reached');
      }
    });

    test('a crew member can insert a photo the owner lists', () async {
      final job = await arrangeJob();
      final crew = await signInAsSeededCrew();
      cleanup.trackSession(crew);
      final crewPhotos = SupabaseJobPhotoRepository(crew);
      final crewStorage = SupabasePhotoStorage(crew);

      final id = uniqueUuid();
      final path = '${SeedUsers.qualityDeckId}/${job.jobId}/$id.jpg';
      await crewStorage.upload(path, jpeg1x1);
      cleanup.trackStorageObject(bucket: Buckets.jobPhotos, path: path);
      final photo = await crewPhotos.insert(
        JobPhotoInsert(
          id: id,
          jobId: job.jobId,
          kind: PhotoKind.concept,
          storagePath: path,
          width: 1,
          height: 1,
        ),
      );

      expect(photo.createdBy, SeedUsers.crewId);
      expect(
        (await photos.listByJob(job.jobId)).map((row) => row.id),
        contains(id),
      );
    });

    test('rejects insert when the project is archived', () async {
      final job = await arrangeJob();
      await projects.archive(job.projectId);

      try {
        await photos.insert(
          JobPhotoInsert(
            id: uniqueUuid(),
            jobId: job.jobId,
            kind: PhotoKind.before,
            storagePath:
                '${SeedUsers.qualityDeckId}/${job.jobId}/${uniqueUuid()}.jpg',
            width: 1,
            height: 1,
          ),
        );
        fail('expected insert to fail');
      } catch (error) {
        expect(error, isNot(isA<TestFailure>()));
      }
    });

    test('another business cannot insert on this job', () async {
      final job = await arrangeJob();
      final other = await signInAs(
        SeedUsers.otherOwnerEmail,
        SeedUsers.password,
      );
      cleanup.trackSession(other);
      final otherPhotos = SupabaseJobPhotoRepository(other);

      try {
        await otherPhotos.insert(
          JobPhotoInsert(
            id: uniqueUuid(),
            jobId: job.jobId,
            kind: PhotoKind.before,
            storagePath: '${SeedUsers.otherCoId}/${uniqueUuid()}.jpg',
            width: 1,
            height: 1,
          ),
        );
        fail('expected insert to fail');
      } catch (error) {
        expect(error, isNot(isA<TestFailure>()));
      }
    });
  });

  group('JobPhotoRepository.listByJob', () {
    test('returns an empty list when the job has no photos', () async {
      final job = await arrangeJob();

      expect(await photos.listByJob(job.jobId), isEmpty);
    });

    test('returns oldest first', () async {
      final job = await arrangeJob();
      final first = await addPhoto(job.jobId, PhotoKind.before);
      final second = await addPhoto(job.jobId, PhotoKind.concept);

      expect(
        (await photos.listByJob(job.jobId)).map((row) => row.id).toList(),
        [first.id, second.id],
      );
    });

    test('another business cannot list photos', () async {
      final job = await arrangeJob();
      await addPhoto(job.jobId, PhotoKind.before);

      final other = await signInAs(
        SeedUsers.otherOwnerEmail,
        SeedUsers.password,
      );
      cleanup.trackSession(other);
      final otherPhotos = SupabaseJobPhotoRepository(other);
      expect(await otherPhotos.listByJob(job.jobId), isEmpty);
    });
  });

  group('JobPhotoRepository.count', () {
    test('returns 0 then the number inserted for that kind', () async {
      final job = await arrangeJob();

      expect(await photos.count(job.jobId, PhotoKind.after), 0);

      await addPhoto(job.jobId, PhotoKind.after);
      await addPhoto(job.jobId, PhotoKind.before);

      expect(await photos.count(job.jobId, PhotoKind.after), 1);
      expect(await photos.count(job.jobId, PhotoKind.before), 1);
      expect(await photos.count(job.jobId, PhotoKind.concept), 0);
    });
  });

  group('JobPhotoRepository.delete', () {
    test('removes the row and the storage object', () async {
      final job = await arrangeJob();
      final photo = await addPhoto(job.jobId, PhotoKind.concept);

      await photos.delete(photo.id);

      expect(await photos.listByJob(job.jobId), isEmpty);
      await expectLater(
        storage.signedUrl(photo.storagePath, const Duration(minutes: 1)),
        throwsA(anything),
      );
    });

    test('raises photo_not_found for a missing id', () async {
      try {
        await photos.delete(uniqueUuid());
        fail('expected AppException');
      } on AppException catch (error) {
        expect(error.token, 'photo_not_found');
      }
    });
  });

  group('PhotoStorage.upload', () {
    test('rejects a second upload to the same path', () async {
      final job = await arrangeJob();
      final path =
          '${SeedUsers.qualityDeckId}/${job.jobId}/${uniqueUuid()}.jpg';

      await storage.upload(path, jpeg1x1);
      cleanup.trackStorageObject(bucket: Buckets.jobPhotos, path: path);

      try {
        await storage.upload(path, jpeg1x1);
        fail('expected AppException');
      } on AppException catch (error) {
        expect(error.token, 'upload_failed');
      }
    });

    test(
      'another business cannot upload into this business\'s folder',
      () async {
        final job = await arrangeJob();
        final path =
            '${SeedUsers.qualityDeckId}/${job.jobId}/${uniqueUuid()}.jpg';
        final other = await signInAs(
          SeedUsers.otherOwnerEmail,
          SeedUsers.password,
        );
        cleanup.trackSession(other);
        final otherStorage = SupabasePhotoStorage(other);

        try {
          await otherStorage.upload(path, jpeg1x1);
          cleanup.trackStorageObject(bucket: Buckets.jobPhotos, path: path);
          fail('expected AppException');
        } on AppException catch (error) {
          expect(error.token, 'upload_failed');
        }
      },
    );
  });

  group('PhotoStorage.signedUrl', () {
    test('another business cannot sign this business\'s path', () async {
      final job = await arrangeJob();
      final photo = await addPhoto(job.jobId, PhotoKind.before);
      final other = await signInAs(
        SeedUsers.otherOwnerEmail,
        SeedUsers.password,
      );
      cleanup.trackSession(other);
      final otherStorage = SupabasePhotoStorage(other);

      await expectLater(
        otherStorage.signedUrl(photo.storagePath, const Duration(minutes: 1)),
        throwsA(anything),
      );
    });
  });
}
