import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:app/features/auth/presentation/controllers/current_user.dart';
import 'package:app/features/onsite/data/job_photo_providers.dart';
import 'package:app/features/onsite/data/photo_platform.dart';
import 'package:app/features/onsite/domain/photo_kind.dart';
import 'package:app/features/onsite/domain/picked_photo.dart';
import 'package:app/features/onsite/presentation/controllers/job_photos.dart';

import '../../../../helpers/fixtures.dart';
import '../../fakes.dart';

void main() {
  test('finished upload has a signed URL without a reload', () async {
    final picker = FakePhotoPicker()
      ..files = [PickedPhoto(bytes: jpegPreview, name: 'site.jpg')];
    final storage = FakePhotoStorage();
    final leaveGuard = FakeLeaveGuard();
    final container = ProviderContainer(
      retry: (count, error) => null,
      overrides: [
        jobPhotoRepositoryProvider.overrideWithValue(FakeJobPhotoRepository()),
        photoStorageProvider.overrideWithValue(storage),
        photoPlatformProvider.overrideWithValue(
          PhotoPlatform(
            picker: picker,
            decoders: [FakeImageDecoder()],
            compressor: FakeImageCompressor(),
            tempFiles: FakeTempFileCleaner(),
            camera: FakeCameraPermission(),
            leaveGuard: leaveGuard,
          ),
        ),
        leaveGuardProvider.overrideWithValue(leaveGuard),
        idGeneratorProvider.overrideWithValue(FakeIdGenerator()),
        currentUserProvider.overrideWith(() => FakeCurrentUser(ownerUser)),
      ],
    );
    addTearDown(container.dispose);
    container.listen(jobPhotosControllerProvider('job-1'), (_, _) {});
    await container.read(currentUserProvider.future);
    await Future<void>.delayed(Duration.zero);

    await container
        .read(jobPhotosControllerProvider('job-1').notifier)
        .choosePhotos(PhotoKind.before);

    final view = await _waitForUpload(container, 'job-1');
    expect(view.pending, isEmpty);
    expect(view.saved, hasLength(1));
    expect(
      view.urls[view.saved.single.id],
      'https://signed.test/${view.saved.single.storagePath}',
    );
  });
}

Future<JobPhotosView> _waitForUpload(
  ProviderContainer container,
  String jobId,
) async {
  late JobPhotosView view;
  for (var i = 0; i < 40; i++) {
    await Future<void>.delayed(Duration.zero);
    view = container.read(jobPhotosControllerProvider(jobId));
    if (view.pending.isEmpty &&
        view.saved.isNotEmpty &&
        view.urls.containsKey(view.saved.first.id)) {
      return view;
    }
  }
  return view;
}
