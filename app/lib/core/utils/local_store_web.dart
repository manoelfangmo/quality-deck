import 'package:web/web.dart' as web;

import 'package:app/core/utils/local_store.dart';

class WebLocalStore implements LocalStore {
  @override
  String? getItem(String key) => web.window.localStorage.getItem(key);

  @override
  void setItem(String key, String value) {
    web.window.localStorage.setItem(key, value);
  }

  @override
  void removeItem(String key) {
    web.window.localStorage.removeItem(key);
  }
}

LocalStore createPlatformLocalStore() => WebLocalStore();
