import 'dart:collection';
import 'dart:convert';
import 'dart:core';
import 'package:build_stats_flutter/resources/app_enums.dart';
import 'package:meta/meta.dart';
import 'package:build_stats_flutter/model/Domain/Exception/http_exception.dart';
import 'package:build_stats_flutter/model/entity/cachable.dart';
import 'package:build_stats_flutter/model/Domain/Service/data_connection_service.dart';
import 'package:build_stats_flutter/model/Domain/Service/file_IO_service.dart';
import 'package:localstorage/localstorage.dart';
import 'package:mutex/mutex.dart';
import 'package:shared/app_strings.dart';
import 'package:shared/cache.dart';
import 'package:shared/entity.dart';

class CacheService<T extends Cacheable> extends Cache<T> {
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
  final ReadWriteMutex _m; // = ReadWriteMutex();
  final LocalStorage _cacheLocalStorage;

  CacheService(this._dataConnectionService, this._fileIOService, this._parser,
      this._apiPath, this._filePath, this._cacheLocalStorage, this._m)
      : super(_parser, _cacheLocalStorage, _m);

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
