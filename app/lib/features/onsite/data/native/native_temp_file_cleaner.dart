import 'dart:io';

import 'package:app/features/onsite/application/temp_file_cleaner.dart';

class NativeTempFileCleaner implements TempFileCleaner {
  @override
  Future<void> delete(String? path) async {
    if (path == null || path.isEmpty) return;
    try {
      final file = File(path);
      if (await file.exists()) {
        await file.delete();
      }
    } catch (_) {}
  }
}
