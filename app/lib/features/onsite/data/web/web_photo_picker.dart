import 'dart:async';
import 'dart:js_interop';

import 'package:web/web.dart' as web;

import 'package:app/features/onsite/application/photo_picker.dart';
import 'package:app/features/onsite/data/web/web_blobs.dart';
import 'package:app/features/onsite/domain/picked_photo.dart';

class WebPhotoPicker implements PhotoPicker {
  @override
  Future<List<PickedPhoto>> pick(PhotoPickSource source, {int? limit}) async {
    final input = web.HTMLInputElement()
      ..type = 'file'
      ..multiple = source == PhotoPickSource.library;
    if (source == PhotoPickSource.camera) {
      input.accept = 'image/*';
      input.setAttribute('capture', 'environment');
    } else {
      input.accept = 'image/*,.heic,.heif';
    }

    final done = Completer<List<PickedPhoto>>();

    void finish(List<PickedPhoto> photos) {
      if (!done.isCompleted) done.complete(photos);
    }

    input.addEventListener(
      'change',
      (web.Event _) {
        final files = input.files;
        if (files == null || files.length == 0) {
          finish(const []);
          return;
        }
        final take = limit == null
            ? files.length
            : (files.length < limit ? files.length : limit);
        () async {
          final photos = <PickedPhoto>[];
          for (var i = 0; i < take; i++) {
            final file = files.item(i);
            if (file == null) continue;
            photos.add(
              PickedPhoto(bytes: await bytesFromBlob(file), name: file.name),
            );
          }
          finish(photos);
        }();
      }.toJS,
    );
    input.addEventListener(
      'cancel',
      (web.Event _) {
        finish(const []);
      }.toJS,
    );

    input.click();
    return done.future;
  }
}
