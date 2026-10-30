abstract class LocalStore {
  String? getItem(String key);
  void setItem(String key, String value);
  void removeItem(String key);
}

class MemoryLocalStore implements LocalStore {
  MemoryLocalStore([Map<String, String>? initial]) : _values = initial ?? {};

  final Map<String, String> _values;

  @override
  String? getItem(String key) => _values[key];

  @override
  void setItem(String key, String value) => _values[key] = value;

  @override
  void removeItem(String key) => _values.remove(key);
}

class LocalSettings {
  LocalSettings(this._store);

  static const signedInAtKey = 'qd_signed_in_at';

  final LocalStore _store;

  String? get(String key) => _store.getItem(key);

  void set(String key, String value) => _store.setItem(key, value);

  void remove(String key) => _store.removeItem(key);
}
