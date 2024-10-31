import 'dart:collection';

import 'package:mutex/mutex.dart';

abstract class LocalStorageInterface {
  Future<String?> getItem(String key);
  Future<void> setItem(String key, String value);
  Future<void> removeItem(String key);
}

class LocalStorage implements LocalStorageInterface {
  late final HashMap<String, String> _storage;
  late final ReadWriteMutex _m;
  LocalStorage(this._m) {
    _storage = HashMap<String, String>();
  }

  @override
  Future<String?> getItem(String key) async {
    return await _m.protectRead(() async {
      return _storage[key];
    });
  }

  @override
  Future<void> setItem(String key, String value) async {
    await _m.protectWrite(() async {
      _storage[key] = value;
    });
  }

  @override
  Future<void> removeItem(String key) async {
    await _m.protectWrite(() async {
      _storage.remove(key);
    });
  }
}
