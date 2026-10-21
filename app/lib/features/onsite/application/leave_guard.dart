abstract interface class LeaveGuard {
  /// Enables the "leave" warning while uploads are running.
  void setUploadsInProgress(bool inProgress);

  /// Called when the app or tab is backgrounded mid-upload.
  set onBackgrounded(void Function()? callback);

  void dispose();
}
