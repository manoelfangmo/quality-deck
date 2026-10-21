import 'package:app/features/onsite/domain/picked_photo.dart';

enum PhotoPickSource { camera, library }

abstract interface class PhotoPicker {
  /// Camera: one photo. Library: multi-select.
  Future<List<PickedPhoto>> pick(PhotoPickSource source, {int? limit});
}
