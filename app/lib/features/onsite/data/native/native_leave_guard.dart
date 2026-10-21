import 'package:flutter/widgets.dart';

import 'package:app/features/onsite/application/leave_guard.dart';

class NativeLeaveGuard implements LeaveGuard {
  AppLifecycleListener? _listener;
  bool _inProgress = false;
  void Function()? _onBackgrounded;

  @override
  set onBackgrounded(void Function()? callback) {
    _onBackgrounded = callback;
  }

  @override
  void setUploadsInProgress(bool inProgress) {
    _inProgress = inProgress;
    if (inProgress) {
      _listener ??= AppLifecycleListener(
        onHide: () {
          if (_inProgress) _onBackgrounded?.call();
        },
        onPause: () {
          if (_inProgress) _onBackgrounded?.call();
        },
      );
    } else {
      _listener?.dispose();
      _listener = null;
    }
  }

  @override
  void dispose() {
    _inProgress = false;
    _listener?.dispose();
    _listener = null;
  }
}
