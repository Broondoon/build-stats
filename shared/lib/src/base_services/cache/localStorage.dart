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
  List<String> get keys => _storage.keys.toList();
  List<String> get values => _storage.values.toList();
  List<MapEntry<String, String>> get entries => _storage.entries.toList();
  LocalStorage(this._m) {
    print("Generated Local Storage");
    _storage = HashMap<String, String>();
  }

  @override
  Future<String?> getItem(String key) async {
    print("Getting item from Local Storage");
    //return await _m.protectRead(() async {
    print(_storage[key]);
    return _storage[key];
    //});
  }

  @override
  Future<void> setItem(String key, String value) async {
    print("setting item in Local Storage");
    //await _m.protectWrite(() async {
    _storage[key] = value;
    //});
  }

  @override
  Future<void> removeItem(String key) async {
    //await _m.protectWrite(() async {
    _storage.remove(key);
    //});
  }
}
