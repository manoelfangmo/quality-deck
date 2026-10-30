import 'package:image_picker/image_picker.dart';

import 'package:app/features/onsite/application/photo_picker.dart';
import 'package:app/features/onsite/domain/picked_photo.dart';

class NativePhotoPicker implements PhotoPicker {
  NativePhotoPicker({ImagePicker? picker}) : _picker = picker ?? ImagePicker();

  final ImagePicker _picker;

  @override
  Future<List<PickedPhoto>> pick(PhotoPickSource source, {int? limit}) async {
    if (source == PhotoPickSource.camera) {
      final file = await _picker.pickImage(
        source: ImageSource.camera,
        requestFullMetadata: false,
      );
      if (file == null) return const [];
      return [
        PickedPhoto(
          bytes: await file.readAsBytes(),
          name: file.name,
          tempPath: file.path,
        ),
      ];
    }

    final files = await _picker.pickMultiImage(
      requestFullMetadata: false,
      limit: limit,
    );
    final take = limit == null ? files : files.take(limit);
    final photos = <PickedPhoto>[];
    for (final file in take) {
      photos.add(
        PickedPhoto(
          bytes: await file.readAsBytes(),
          name: file.name,
          tempPath: file.path,
        ),
      );
    }
    return photos;
  }
}
