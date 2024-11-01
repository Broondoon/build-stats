import 'dart:collection';
import 'dart:convert';
import 'dart:core';
import 'package:meta/meta.dart';
import 'package:mutex/mutex.dart';
import 'package:shared/app_strings.dart';
import 'package:shared/src/base_entities/entity/entity.dart';
import 'package:shared/src/base_services/cache/cache_interface.dart';
import 'package:shared/src/base_services/cache/localStorage.dart';

class Cache<T extends Entity> implements CacheInterface<T> {
  final EntityFactory<T> _parser;
  final HashMap<String, String> cacheCheckSums = HashMap<String, String>();
  final HashMap<String, bool> cacheSyncFlags = HashMap<String, bool>();
  final ReadWriteMutex _m;
  final LocalStorage _cacheLocalStorage;

  Cache(this._parser, this._cacheLocalStorage, this._m);

  @override
  Future<List<T>?> get(
      List<String> keys, Function(List<String>?) onCacheMiss) async {
    List<String> entitiesJson = [];
    List<String> missingKeys = [];
    (entitiesJson, missingKeys) = await _m.protectRead(() async {
      List<String> entitiesCached = [];
      List<String> missingKeysFound = [];
      for (String key in keys) {
        String? entityJson;
        //TODO: Get Sync working in the background. Dirty work around to ignore the cache otherwise.
        if ((key.startsWith(ID_TempIDPrefix)) &&
            (cacheSyncFlags[key] ?? false)) {
          entityJson = await _cacheLocalStorage.getItem(key);
        }
        if (entityJson == null) {
          missingKeysFound.add(key);
        } else {
          entitiesCached.add(entityJson);
        }
      }
      return (entitiesCached, missingKeysFound);
    });

    List<T> entities = entitiesJson
        .map((entityJson) => _parser.fromJson(jsonDecode(entityJson!)))
        .toList()
        .cast<T>();

    if (missingKeys.isNotEmpty) {
      List<T>? missingEntities =
          await storeBulk(await onCacheMiss(missingKeys));
      if (missingEntities != null) {
        entities.addAll(await storeBulk(missingEntities));
      }
    }
    return entities;
  }

  @override
  Future<List<T>?> getAll(Function(List<String>?) onCacheMiss) async {
    return await get(_cacheLocalStorage.keys.toList(), onCacheMiss);
  }

  @override
  Future<List<T>> storeBulk(List<T> entities) async {
    return await _m.protectWrite(() async {
      List<T> storedEntities = [];
      for (T entity in entities) {
        T storedEntity = await storeUnprotected(entity.id, entity);
        storedEntities.add(storedEntity);
      }
      return storedEntities;
    });
  }

  @override
  Future<T> store(String key, T entityValue) async {
    return await _m.protectWrite(() async {
      return await storeUnprotected(key, entityValue);
    });
  }

  //should never be called outside a mutex.
  Future<T> storeUnprotected(String key, T value) async {
    if (_m.isWriteLocked) {
      if (key != value.id) {
        await deleteUnprotected(key);
        key = value.id;
      }
      if (!(key.startsWith(ID_TempIDPrefix))) {
        cacheCheckSums[key] = value.getChecksum();
      }
      cacheSyncFlags[key] = true;
      await _cacheLocalStorage.setItem(key, jsonEncode(value.toJson()));
      return value;
    } else {
      throw Exception("Store must be called within a write lock");
    }
  }

  @override
  Future<void> delete(String key) async {
    await _m.protectWrite(() async {
      await deleteUnprotected(key);
    });
  }

  //should never be called outside a mutex.
  Future<void> deleteUnprotected(String key) async {
    if (_m.isWriteLocked) {
      if (!(key.startsWith(ID_TempIDPrefix))) {
        cacheCheckSums[key] = EntityState.deleted.toString();
      }
      cacheSyncFlags.remove(key);
      await _cacheLocalStorage.removeItem(key);
    } else {
      throw Exception("Store must be called within a write lock");
    }
  }

  @override
  Future<void> setCacheSyncFlags(
      HashMap<String, String> serverCheckSums) async {
    return await _m.protectWrite(() async {
      serverCheckSums.forEach((key, value) async {
        if (cacheCheckSums[key] != value) {
          cacheSyncFlags[key] = false;
        } else if (serverCheckSums[key] == EntityState.deleted.toString()) {
          await deleteUnprotected(key);
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
