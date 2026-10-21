abstract interface class TempFileCleaner {
  Future<void> delete(String? path);
}
