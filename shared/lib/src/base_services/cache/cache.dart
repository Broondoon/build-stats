import 'dart:collection';
import 'dart:convert';
import 'dart:core';
import 'package:meta/meta.dart';
import 'package:localstorage/localstorage.dart';
import 'package:mutex/mutex.dart';
import 'package:shared/src/base_entities/entity/entity.dart';
import 'package:shared/src/base_services/cache/cache_interface.dart';

class Cache<T extends Entity> implements CacheInterface<T> {
  final EntityFactory<T> _parser;
  final HashMap<String, String> cacheCheckSums = HashMap<String, String>();
  final HashMap<String, bool> cacheSyncFlags = HashMap<String, bool>();
  final ReadWriteMutex _m;
  final LocalStorage _cacheLocalStorage;

  Cache(this._parser, this._cacheLocalStorage, this._m);

  @override
  Future<T?> getById(String key) async {
    String? entityJson = await _m.protectRead(() async {
      return (cacheSyncFlags[key] ?? false)
          ? _cacheLocalStorage.getItem(key)
          : null;
    });
    return (entityJson != null)
        ? _parser.fromJson(jsonDecode(entityJson))
        : await this.loadById(key);
  }

  @override
  Future<List<T>?> getAll() async {
    List<T> entities = [];
    List<String> keys = cacheSyncFlags.keys.toList();
    for (String key in keys) {
      T? entity = await getById(key);
      if (entity != null) {
        entities.add(entity);
      }
    }
    return entities;
  }

  @override
  Future<T?> loadById(String key) => throw UnimplementedError();

  @override
  Future<List<T>> storeBulk(List<T> entities) async {
    return await _m.protectWrite(() async {
      List<T> storedEntities = [];
      for (T entity in entities) {
        T storedEntity = await _store(entity.id, entity);
        storedEntities.add(storedEntity);
      }
      return storedEntities;
    });
  }

  @override
  Future<T> store(String key, T entityValue) async {
    return await _m.protectWrite(() async {
      return await _store(key, entityValue);
    });
  }

  //should never be called outside a mutex.
  Future<T> _store(String key, T value) => throw UnimplementedError();

  @override
  Future<void> delete(String key) async {
    await _m.protectWrite(() async {
      await _delete(key);
    });
  }

  //should never be called outside a mutex.
  Future<void> _delete(String key) => throw UnimplementedError();

  @override
  Future<void> setCacheSyncFlags(
      HashMap<String, String> serverCheckSums) async {
    return await _m.protectWrite(() async {
      serverCheckSums.forEach((key, value) async {
        if (cacheCheckSums[key] != value) {
          cacheSyncFlags[key] = false;
        } else if (serverCheckSums[key] == EntityState.deleted.toString()) {
          await _delete(key);
          cacheCheckSums.remove(key);
        }
      });
    });
  }

  @override
  Future<HashMap<String, String>> getCacheCheckStates() async {
    return cacheCheckSums;
  }
}
