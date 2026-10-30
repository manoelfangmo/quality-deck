import 'dart:js_interop';

import 'package:web/web.dart' as web;

import 'package:app/features/onsite/application/leave_guard.dart';

class WebLeaveGuard implements LeaveGuard {
  web.EventListener? _beforeUnload;
  web.EventListener? _visibility;
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
      _beforeUnload ??= ((web.Event event) {
        event.preventDefault();
        (event as web.BeforeUnloadEvent).returnValue = '';
      }).toJS;
      web.window.addEventListener('beforeunload', _beforeUnload!);

      _visibility ??= ((web.Event _) {
        if (_inProgress && web.document.visibilityState == 'hidden') {
          _onBackgrounded?.call();
        }
      }).toJS;
      web.document.addEventListener('visibilitychange', _visibility!);
    } else {
      _removeListeners();
    }
  }

  void _removeListeners() {
    final before = _beforeUnload;
    if (before != null) {
      web.window.removeEventListener('beforeunload', before);
      _beforeUnload = null;
    }
    final visibility = _visibility;
    if (visibility != null) {
      web.document.removeEventListener('visibilitychange', visibility);
      _visibility = null;
    }
  }

  @override
  void dispose() {
    _inProgress = false;
    _removeListeners();
  }
}
