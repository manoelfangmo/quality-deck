import 'dart:typed_data';

class PickedPhoto {
  const PickedPhoto({required this.bytes, required this.name, this.tempPath});

  final Uint8List bytes;
  final String name;
  final String? tempPath;
}
