import 'dart:collection';
import 'dart:convert';
import 'dart:core';
import 'package:meta/meta.dart';
import 'package:localstorage/localstorage.dart';
import 'package:mutex/mutex.dart';
import 'package:shared/app_strings.dart';
import 'package:shared/cache.dart';
import 'package:shared/entity.dart';

class CacheService<T extends Entity> extends Cache<T> {
  final EntityFactory<T> _parser;
  final HashMap<String, String> _cacheCheckSums = HashMap<String, String>();
  @visibleForTesting
  @override
  HashMap<String, String> get cacheCheckSums => _cacheCheckSums;
  final HashMap<String, bool> _cacheSyncFlags = HashMap<String, bool>();
  @visibleForTesting
  @override
  HashMap<String, bool> get cacheSyncFlags => _cacheSyncFlags;
  final ReadWriteMutex _m; // = ReadWriteMutex();
  final LocalStorage _cacheLocalStorage;

  CacheService(this._parser, this._cacheLocalStorage, this._m)
      : super(_parser, _cacheLocalStorage, _m);

  @override
  Future<T?> loadById(String key) async => await _m.protectWrite(() async {
        T? entity;
        return entity;
      });

  //should never be called outside a mutex.
  Future<T> _store(String key, T value) async {
    if (_m.isWriteLocked) {
      if (key != value.id) {
        await _delete(key);
        key = value.id;
      }
      if (!(key.startsWith(ID_TempIDPrefix))) {
        _cacheCheckSums[key] = value.getChecksum();
      }
      _cacheSyncFlags[key] = true;
      _cacheLocalStorage.setItem(key, jsonEncode(value.toJson()));
      return value;
    } else {
      throw Exception("Store must be called within a write lock");
    }
  }

  //should never be called outside a mutex.
  Future<void> _delete(String key) async {
    if (_m.isWriteLocked) {
      if (!(key.startsWith(ID_TempIDPrefix))) {
        _cacheCheckSums[key] = EntityState.deleted.toString();
      }
      _cacheSyncFlags.remove(key);
      _cacheLocalStorage.removeItem(key);
    } else {
      throw Exception("Store must be called within a write lock");
    }
  }
}
