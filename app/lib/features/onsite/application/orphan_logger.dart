abstract interface class OrphanLogger {
  Future<void> record(String storagePath);
}
