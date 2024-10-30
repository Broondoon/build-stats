import 'dart:collection';
import 'dart:convert';
import 'dart:core';
import 'package:meta/meta.dart';
import 'package:build_stats_flutter/model/Domain/Exception/http_exception.dart';
import 'package:build_stats_flutter/model/Domain/Interface/cachable.dart';
import 'package:build_stats_flutter/model/Domain/Interface/data_connection_service.dart';
import 'package:build_stats_flutter/model/Domain/Interface/file_IO_service.dart';
import 'package:build_stats_flutter/resources/app_enums.dart';
import 'package:build_stats_flutter/resources/app_strings.dart';
import 'package:localstorage/localstorage.dart';
import 'package:mutex/mutex.dart';

abstract class CacheInterface<T extends Cacheable> {
  Future<T?> getById(String key);
  Future<List<T>?> getAll();
  Future<List<T>> storeBulk(List<T> entities);
  Future<T> store(String key, T value);
  Future<void> delete(String key);
  Future<T?> loadById(String key);
  Future<HashMap<String, String>> getCacheCheckStates();
  Future<void> setCacheSyncFlags(HashMap<String, String> serverCheckSums);
}

class CacheService<T extends Cacheable> implements CacheInterface<T> {
  final DataConnectionService<T> _dataConnectionService;
  final FileIOService<T> _fileIOService;
  final CacheableFactory<T> _parser;
  final String _apiPath;
  final String _filePath;
  final HashMap<String, String> _cacheCheckSums = HashMap<String, String>();
  @visibleForTesting
  HashMap<String, String> get cacheCheckSums => _cacheCheckSums;
  final HashMap<String, bool> _cacheSyncFlags = HashMap<String, bool>();
  @visibleForTesting
  HashMap<String, bool> get cacheSyncFlags => _cacheSyncFlags;
  final _m = ReadWriteMutex();
  final LocalStorage cacheLocalStorage;

  CacheService(this._dataConnectionService, this._fileIOService, this._parser,
      this._apiPath, this._filePath, this.cacheLocalStorage);

  @override
  Future<T?> getById(String key) async {
    String? entityJson = await _m.protectRead(() async {
      return (_cacheSyncFlags[key] ?? false)
          ? cacheLocalStorage.getItem(key)
          : null;
    });
    return (entityJson != null)
        ? _parser.fromJson(jsonDecode(entityJson))
        : await this.loadById(key);
  }

  @override
  Future<List<T>?> getAll() async {
    List<T> entities = [];
    List<String> keys = _cacheSyncFlags.keys.toList();
    for (String key in keys) {
      T? entity = await getById(key);
      if (entity != null) {
        entities.add(entity);
      }
    }
    return entities;
  }

  @override
  Future<T?> loadById(String key) async {
    return await _m.protectWrite(() async {
      T? entity;
      try {
        //Ensure we have the most recently edited version of the entity.
        //This is a temp fix for noow, as we should let the user determine if they want to overwrite the local version.
        T? entityServer = (!(key.startsWith(ID_TempIDPrefix)))
            ? _parser.fromJson(
                jsonDecode(await _dataConnectionService.get(_apiPath, [key]))
                    .first)
            : null;
        T? entityLocal = await _fileIOService.readDataFileByKey(_filePath, key);

        if (entityLocal != null && entityServer != null) {
          entity = (entityLocal.dateUpdated.isAfter(entityServer.dateUpdated))
              ? entityLocal
              : entityServer;
        } else {
          entity = entityLocal ?? entityServer;
        }
      } on HttpException catch (e) {
        switch (e.response) {
          case HttpResponse.NotFound:
            await _delete(key);
            return null;
          default:
            entity = await _fileIOService.readDataFileByKey(_filePath, key);
        }
      }
      if (entity != null) {
        await _store(key, entity);
      }
      return entity;
    });
  }

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
      cacheLocalStorage.setItem(key, jsonEncode(value.toJson()));
      return value;
    } else {
      throw Exception("Store must be called within a write lock");
    }
  }

  @override
  Future<void> delete(String key) async {
    await _m.protectWrite(() async {
      await _delete(key);
    });
  }

  //should never be called outside a mutex.
  Future<void> _delete(String key) async {
    if (_m.isWriteLocked) {
      if (!(key.startsWith(ID_TempIDPrefix))) {
        _cacheCheckSums[key] = EntityState.deleted.toString();
      }
      _cacheSyncFlags.remove(key);
      cacheLocalStorage.removeItem(key);
    } else {
      throw Exception("Store must be called within a write lock");
    }
  }

  @override
  Future<void> setCacheSyncFlags(
      HashMap<String, String> serverCheckSums) async {
    return await _m.protectWrite(() async {
      serverCheckSums.forEach((key, value) async {
        if (_cacheCheckSums[key] != value) {
          _cacheSyncFlags[key] = false;
        } else if (serverCheckSums[key] == EntityState.deleted.toString()) {
          await _delete(key);
          _cacheCheckSums.remove(key);
        }
      });
    });
  }

  @override
  Future<HashMap<String, String>> getCacheCheckStates() async {
    return _cacheCheckSums;
  }
}
