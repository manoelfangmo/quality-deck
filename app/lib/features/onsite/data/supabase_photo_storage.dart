import 'dart:typed_data';

import 'package:supabase_flutter/supabase_flutter.dart';

import 'package:app/core/database/buckets.dart';
import 'package:app/core/domain/app_exception.dart';
import 'package:app/features/onsite/application/photo_storage.dart';

class SupabasePhotoStorage implements PhotoStorage {
  SupabasePhotoStorage(this._supabase);

  final SupabaseClient _supabase;

  StorageFileApi get _bucket => _supabase.storage.from(Buckets.jobPhotos);

  @override
  Future<void> upload(String path, Uint8List bytes) async {
    try {
      await _bucket.uploadBinary(
        path,
        bytes,
        fileOptions: const FileOptions(
          contentType: 'image/jpeg',
          upsert: false,
        ),
      );
    } catch (error, stackTrace) {
      Error.throwWithStackTrace(const AppException.uploadFailed(), stackTrace);
    }
  }

  @override
  Future<void> remove(String path) async {
    try {
      await _bucket.remove([path]);
    } catch (error, stackTrace) {
      Error.throwWithStackTrace(error, stackTrace);
    }
  }

  @override
  Future<String> signedUrl(String path, Duration ttl) async {
    return _bucket.createSignedUrl(path, ttl.inSeconds);
  }
}
