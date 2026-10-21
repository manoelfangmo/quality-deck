import 'package:flutter_test/flutter_test.dart';

import 'package:app/core/domain/app_exception.dart';
import 'package:app/features/onsite/application/delete_job_photo.dart';
import 'package:app/features/onsite/domain/job_photo.dart';
import 'package:app/features/onsite/domain/photo_kind.dart';

import '../fakes.dart';

void main() {
  late FakeJobPhotoRepository repo;
  late FakePhotoStorage storage;
  late FakeOrphanLogger orphans;
  late DeleteJobPhoto useCase;

  final photo = JobPhoto(
    id: 'p1',
    jobId: 'job-1',
    kind: PhotoKind.before,
    storagePath: 'biz/job-1/p1.jpg',
    width: 8,
    height: 6,
    createdBy: 'owner-id',
    createdAt: DateTime.utc(2026, 10, 21),
  );

  setUp(() {
    repo = FakeJobPhotoRepository();
    storage = FakePhotoStorage();
    orphans = FakeOrphanLogger();
    useCase = DeleteJobPhoto(repo: repo, storage: storage, orphans: orphans);
  });

  test('delete failure leaves the file and does not log an orphan', () async {
    repo.photos.add(photo);
    storage.objects[photo.storagePath] = jpegPreview;
    repo.failDelete = true;

    await expectLater(
      useCase.call(photo),
      throwsA(
        isA<AppException>().having((e) => e.token, 'token', 'photo_not_found'),
      ),
    );
    expect(storage.objects.containsKey(photo.storagePath), isTrue);
    expect(orphans.paths, isEmpty);
    expect(repo.photos, [photo]);
  });

  test(
    'storage failure after a successful row delete is logged as an orphan',
    () async {
      repo.photos.add(photo);
      storage.objects[photo.storagePath] = jpegPreview;
      storage.failRemove = true;

      await useCase.call(photo);

      expect(repo.photos, isEmpty);
      expect(orphans.paths, [photo.storagePath]);
    },
  );

  test('successful delete removes the row and the file', () async {
    repo.photos.add(photo);
    storage.objects[photo.storagePath] = jpegPreview;

    await useCase.call(photo);

    expect(repo.photos, isEmpty);
    expect(storage.objects, isEmpty);
    expect(orphans.paths, isEmpty);
  });
}
