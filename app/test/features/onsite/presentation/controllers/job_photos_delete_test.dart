import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:app/features/onsite/data/job_photo_providers.dart';
import 'package:app/features/onsite/domain/job_photo.dart';
import 'package:app/features/onsite/domain/photo_kind.dart';
import 'package:app/features/onsite/presentation/controllers/job_photos.dart';

import '../../fakes.dart';

void main() {
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

  test('failed delete restores the photo and sets an error', () async {
    final repo = FakeJobPhotoRepository()..photos.add(photo);
    repo.failDelete = true;
    final storage = FakePhotoStorage()
      ..objects[photo.storagePath] = jpegPreview;

    final container = ProviderContainer(
      retry: (count, error) => null,
      overrides: [
        jobPhotoRepositoryProvider.overrideWithValue(repo),
        photoStorageProvider.overrideWithValue(storage),
        leaveGuardProvider.overrideWithValue(FakeLeaveGuard()),
      ],
    );
    addTearDown(container.dispose);
    container.listen(jobPhotosControllerProvider('job-1'), (_, _) {});
    await Future<void>.delayed(Duration.zero);

    await container
        .read(jobPhotosControllerProvider('job-1').notifier)
        .deleteSaved(photo);

    final view = container.read(jobPhotosControllerProvider('job-1'));
    expect(view.saved.map((p) => p.id), contains('p1'));
    expect(view.deleteError, isNotNull);
    expect(storage.objects.containsKey(photo.storagePath), isTrue);
  });
}
