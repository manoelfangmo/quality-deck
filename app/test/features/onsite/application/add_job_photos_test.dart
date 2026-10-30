import 'dart:typed_data';

import 'package:flutter_test/flutter_test.dart';

import 'package:app/core/domain/app_exception.dart';
import 'package:app/features/onsite/application/add_job_photos.dart';
import 'package:app/features/onsite/application/decoder_registry.dart';
import 'package:app/features/onsite/domain/compressed_photo.dart';
import 'package:app/features/onsite/domain/job_photo_limits.dart';
import 'package:app/features/onsite/domain/photo_kind.dart';
import 'package:app/features/onsite/domain/picked_photo.dart';

import '../fakes.dart';

void main() {
  late FakeImageDecoder decoder;
  late FakeImageCompressor compressor;
  late FakePhotoStorage storage;
  late FakeJobPhotoRepository repo;
  late FakeIdGenerator ids;
  late FakeTempFileCleaner temps;
  late AddJobPhotos useCase;

  final jpeg = Uint8List.fromList([0xFF, 0xD8, 0xFF, 0xD9, 1, 2, 3]);

  setUp(() {
    decoder = FakeImageDecoder();
    compressor = FakeImageCompressor(jpegPreview);
    storage = FakePhotoStorage();
    repo = FakeJobPhotoRepository();
    ids = FakeIdGenerator();
    temps = FakeTempFileCleaner();
    useCase = AddJobPhotos(
      decoders: DecoderRegistry([decoder]),
      compressor: compressor,
      storage: storage,
      repo: repo,
      ids: ids,
      tempFiles: temps,
    );
  });

  PickedPhoto picked({Uint8List? bytes, String? tempPath}) {
    return PickedPhoto(
      bytes: bytes ?? jpeg,
      name: 'site.jpg',
      tempPath: tempPath,
    );
  }

  test('process rejects a non-image and deletes the temp file', () async {
    await expectLater(
      useCase.process(
        picked(
          bytes: Uint8List.fromList([0x25, 0x50, 0x44, 0x46]),
          tempPath: '/tmp/a.pdf',
        ),
      ),
      throwsA(
        isA<AppException>().having(
          (e) => e.token,
          'token',
          'invalid_photo_type',
        ),
      ),
    );
    expect(temps.deleted, ['/tmp/a.pdf']);
  });

  test('process rejects a file over 20 MB', () async {
    final big = Uint8List(JobPhotoLimits.maxBytes + 1);
    big[0] = 0xFF;
    big[1] = 0xD8;
    await expectLater(
      useCase.process(picked(bytes: big, tempPath: '/tmp/big.jpg')),
      throwsA(
        isA<AppException>().having((e) => e.token, 'token', 'photo_too_large'),
      ),
    );
  });

  test('save uploads then inserts; upload failure writes nothing', () async {
    storage.failUpload = true;
    final compressed = CompressedPhoto(bytes: jpegPreview, width: 8, height: 6);

    await expectLater(
      useCase.save(
        jobId: 'job-1',
        businessId: 'biz-1',
        kind: PhotoKind.before,
        compressed: compressed,
      ),
      throwsA(
        isA<AppException>().having((e) => e.token, 'token', 'upload_failed'),
      ),
    );
    expect(storage.objects, isEmpty);
    expect(repo.photos, isEmpty);
  });

  test('insert failure deletes the uploaded object', () async {
    repo.failInsert = true;
    final compressed = CompressedPhoto(bytes: jpegPreview, width: 8, height: 6);

    await expectLater(
      useCase.save(
        jobId: 'job-1',
        businessId: 'biz-1',
        kind: PhotoKind.before,
        compressed: compressed,
      ),
      throwsA(isA<AppException>()),
    );
    expect(storage.objects, isEmpty);
    expect(repo.photos, isEmpty);
  });

  test('the 11th photo for a kind is rejected and no file is left', () async {
    final compressed = CompressedPhoto(bytes: jpegPreview, width: 8, height: 6);
    for (var i = 0; i < 10; i++) {
      await useCase.save(
        jobId: 'job-1',
        businessId: 'biz-1',
        kind: PhotoKind.before,
        compressed: compressed,
      );
    }

    await expectLater(
      useCase.save(
        jobId: 'job-1',
        businessId: 'biz-1',
        kind: PhotoKind.before,
        compressed: compressed,
      ),
      throwsA(
        isA<AppException>().having(
          (e) => e.token,
          'token',
          'photo_limit_reached',
        ),
      ),
    );
    expect(repo.photos, hasLength(10));
    expect(storage.objects, hasLength(10));
  });

  test('process then save stores a JPEG under the business path', () async {
    final compressed = await useCase.process(picked(tempPath: '/tmp/in.jpg'));
    final saved = await useCase.save(
      jobId: 'job-1',
      businessId: 'biz-1',
      kind: PhotoKind.concept,
      compressed: compressed,
    );

    expect(saved.photo.storagePath, 'biz-1/job-1/photo-1.jpg');
    expect(storage.objects[saved.photo.storagePath], jpegPreview);
    expect(temps.deleted, ['/tmp/in.jpg']);
  });

  test(
    'cancelled save removes the object if it was already uploaded',
    () async {
      var cancelled = false;
      storage = FakePhotoStorage();
      useCase = AddJobPhotos(
        decoders: DecoderRegistry([decoder]),
        compressor: compressor,
        storage: storage,
        repo: repo,
        ids: ids,
        tempFiles: temps,
      );

      await expectLater(
        useCase.save(
          jobId: 'job-1',
          businessId: 'biz-1',
          kind: PhotoKind.after,
          compressed: CompressedPhoto(bytes: jpegPreview, width: 8, height: 6),
          isCancelled: () {
            if (storage.objects.isNotEmpty) cancelled = true;
            return cancelled;
          },
        ),
        throwsA(isA<CancelledUpload>()),
      );
      expect(storage.objects, isEmpty);
      expect(repo.photos, isEmpty);
    },
  );
}
