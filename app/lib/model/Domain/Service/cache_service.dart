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
    return (await super.get([key], (x) async => await loadById(x?.first)))
        ?.first;
  }

  Future<T?> loadById(String? key) async {
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
      return entity;
    });
  }

  Future<List<T>?> LoadBulk(String apiPath, Function(T) comparer) async {
    List<T> entities = <T>[];
    try {
      String? entitiesJsonRemote = await _dataConnectionService.get(apiPath);
      List<T> localEntities = (await _fileIOService.readDataFile(_filePath))
              ?.where((e) => comparer(e))
              .toList() ??
          <T>[];
      List<T> remoteEntities = jsonDecode(entitiesJsonRemote)
          .map<T>((e) => _parser.fromJson(e))
          .toList();
      //TEMP IMPELMENTATION: If we have conflciting versions of the same entities, we will need to medaite that. For now, we'll just overwrite with the version most recently updated.
      List<String> ids = localEntities.map((e) => e.id).toList();
      ids.insertAll(0, remoteEntities.map((e) => e.id));
      ids.toSet().toList().forEach((id) async {
        int localIndex = localEntities.indexWhere((e) => e.id == id);
        if (localIndex == -1) {
          entities.add(remoteEntities.firstWhere((e) => e.id == id));
        } else {
          int remoteIndex = remoteEntities.indexWhere((e) => e.id == id);
          if (remoteIndex == -1) {
            entities.add(localEntities[localIndex]);
          } else {
            if (localEntities[localIndex]
                .dateUpdated
                .isAfter(remoteEntities[remoteIndex].dateUpdated)) {
              entities.add(localEntities[localIndex]);
            } else {
              entities.add(remoteEntities[remoteIndex]);
            }
          }
        }
      });
    } on HttpException catch (e) {
      switch (e.response) {
        case HttpResponse.ServiceUnavailable:
          entities = (await _fileIOService.readDataFile(_filePath))
                  ?.where((e) => comparer(e))
                  .toList() ??
              <T>[];
        default:
          rethrow;
      }
    }
    return await storeBulk(entities);
  }
}