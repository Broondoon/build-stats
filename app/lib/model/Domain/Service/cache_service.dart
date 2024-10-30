import 'dart:collection';
import 'dart:convert';
import 'dart:core';
import 'package:build_stats_flutter/resources/app_enums.dart';
import 'package:meta/meta.dart';
import 'package:build_stats_flutter/model/Domain/Exception/http_exception.dart';
import 'package:build_stats_flutter/model/Domain/Service/data_connection_service.dart';
import 'package:build_stats_flutter/model/Domain/Service/file_IO_service.dart';
import 'package:localstorage/localstorage.dart';
import 'package:mutex/mutex.dart';
import 'package:shared/app_strings.dart';
import 'package:shared/cache.dart';
import 'package:shared/entity.dart';

class CacheService<T extends Entity> extends Cache<T> {
  final DataConnectionService<T> _dataConnectionService;
  final FileIOService<T> _fileIOService;
  final EntityFactory<T> _parser;
  final String _apiPath;
  final String _filePath;
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

  CacheService(this._dataConnectionService, this._fileIOService, this._parser,
      this._apiPath, this._filePath, this._cacheLocalStorage, this._m)
      : super(_parser, _cacheLocalStorage, _m);

  Future<T?> getById(String key) async {
    return (await super.get([key], loadById))?.first;
  }

  @override
  Future<List<T>?> loadById(List<String>? keys) async {
    String? key = keys?.first;
    if (key == null) {
      return null;
    }
    return await _m.protectWrite(() async {
      T? entity;
      try {
        //Ensure we have the most recently edited version of the entity.
        //This is a temp fix for noow, as we should let the user determine if they want to overwrite the local version.
        T? entityServer = (!(key.startsWith(ID_TempIDPrefix)))
            ? _parser.fromJson(
                jsonDecode(await _dataConnectionService.get("$_apiPath//$key"))
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
            await deleteUnprotected(key);
            return null;
          default:
            entity = await _fileIOService.readDataFileByKey(_filePath, key);
        }
      }
      if (entity != null) {
        entity = await storeUnprotected(key, entity);
      }
      List<T>? entities = entity != null ? [entity] : [];
      return entities;
    });
  }
}
