import 'package:supabase_flutter/supabase_flutter.dart';

import 'package:app/core/database/buckets.dart';
import 'package:app/core/database/storage_orphans_table.dart';
import 'package:app/features/onsite/application/orphan_logger.dart';

class SupabaseOrphanLogger implements OrphanLogger {
  SupabaseOrphanLogger(this._supabase);

  final SupabaseClient _supabase;

  @override
  Future<void> record(String storagePath) async {
    try {
      await _supabase.from(StorageOrphansTable.name).insert({
        StorageOrphansTable.bucket: Buckets.jobPhotos,
        StorageOrphansTable.storagePath: storagePath,
      });
    } catch (_) {
      // Logging must not fail the user-facing delete.
    }
  }
}
