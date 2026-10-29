import 'dart:typed_data';

import 'package:freezed_annotation/freezed_annotation.dart';

import 'package:app/features/onsite/domain/compressed_photo.dart';
import 'package:app/features/onsite/domain/photo_kind.dart';

part 'pending_photo.freezed.dart';

enum PendingPhotoStatus { processing, uploading, failed }

@freezed
abstract class PendingPhoto with _$PendingPhoto {
  const factory PendingPhoto({
    required String localId,
    required PhotoKind kind,
    required PendingPhotoStatus status,
    Uint8List? preview,
    CompressedPhoto? compressed,
    String? error,
  }) = _PendingPhoto;
}
