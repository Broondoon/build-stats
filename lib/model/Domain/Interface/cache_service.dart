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
  Future<void> store(String key, T value);
  Future<void> delete(String key);
  Future<T?> loadById(String key);
  Future<HashMap<String, String>> getCacheCheckStates();
  Future<void> setCacheSyncFlags(HashMap<String, String> serverCheckSums);
}

class CacheService<T extends Cacheable> implements CacheInterface<T> {
  final DataConnectionService<T> _dataConnectionService;
  final FileIOService _fileIOService;
  final CacheableFactory<T> _parser;
  final String _apiPath;
  final String _filePath;
  final HashMap<String, String> _cacheCheckSums = HashMap<String, String>();
  @visibleForTesting
  HashMap<String, String> get cacheCheckSums => _cacheCheckSums;
  final HashMap<String, bool> _cacheSyncFlags = HashMap<String, bool>();
  @visibleForTesting
  HashMap<String, bool> get cacheSyncFlags => _cacheSyncFlags;
  final m = ReadWriteMutex();
  final LocalStorage cacheLocalStorage;

  CacheService(this._dataConnectionService, this._fileIOService, this._parser,
      this._apiPath, this._filePath, this.cacheLocalStorage);

  @override
  Future<T?> getById(String key) async {
    String? entityJson = await m.protectRead(() async {
      return (_cacheSyncFlags[key] ?? false)
          ? cacheLocalStorage.getItem(key)
          : null;
    });
    return (entityJson != null)
        ? _parser.fromJson(jsonDecode(entityJson))
        : await this.loadById(key);
  }

  @override
  Future<T?> loadById(String key) async {
    return await m.protectWrite(() async {
      String? entitiesJson;
      T? entity;
      try {
        entitiesJson = (!(key.startsWith(ID_TempIDPrefix)))
            ? (await _dataConnectionService.get(_apiPath, [key]))
            : await _fileIOService.readDataFile(_filePath);
      } on HttpException catch (e) {
        switch (e.statusCode) {
          case 410:
            await _delete(key);
            return null;
          default:
            entitiesJson = await _fileIOService.readDataFile(_filePath);
        }
      }
      if (entitiesJson.isNotEmpty) {
        entity = jsonDecode(entitiesJson)
            .map((json) => _parser.fromJson(json))
            .toList()
            .where((entity) => entity.id == key);
        if (entity != null) {
          await _store(key, entity);
        }
      }
      return entity;
    });
  }

  @override
  Future<void> store(String key, T value) async {
    await m.protectWrite(() async {
      await _store(key, value);
    });
  }

  //should never be called outside a mutex.
  Future<void> _store(String key, T value) async {
    if (m.isWriteLocked) {
      if (key != value.id) {
        await _delete(key);
        key = value.id;
      }
      if (!(key.startsWith(ID_TempIDPrefix))) {
        _cacheCheckSums[key] = value.getChecksum();
      }
      _cacheSyncFlags[key] = true;
      cacheLocalStorage.setItem(key, jsonEncode(value.toJson()));
    } else {
      throw Exception("Store must be called within a write lock");
    }
  }

  @override
  Future<void> delete(String key) async {
    await m.protectWrite(() async {
      await _delete(key);
    });
  }

  //should never be called outside a mutex.
  Future<void> _delete(String key) async {
    if (m.isWriteLocked) {
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
    return await m.protectWrite(() async {
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
    return await m.protectRead(() async {
      return _cacheCheckSums;
    });
  }
}
