import 'dart:collection';
import 'dart:convert';
import 'dart:core';
import 'package:build_stats_flutter/resources/app_enums.dart';
import 'package:injector/injector.dart';
import 'package:meta/meta.dart';
import 'package:build_stats_flutter/model/Domain/Exception/http_exception.dart';
import 'package:build_stats_flutter/model/Domain/Service/data_connection_service.dart';
import 'package:build_stats_flutter/model/Domain/Service/file_IO_service.dart';
import 'package:mutex/mutex.dart';
import 'package:shared/app_strings.dart';
import 'package:shared/cache.dart';
import 'package:shared/entity.dart';


class CacheService<T extends Entity> extends Cache<T> {
  final DataConnectionService<T> _dataConnectionService;
  final FileIOService<T> _fileIOService;
  final EntityFactoryInterface<T> _parser;
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
  final String _idPrefix;

  // static CacheService<T> create<T extends Entity>(
  //     DataConnectionService<T> dataConnectionService,
  //     FileIOService<T> fileIOService,
  //     EntityFactoryInterface<T> parser,
  //     LocalStorage cacheLocalStorage,
  //     ReadWriteMutex m,
  //     String idPrefix) {
  //   return CacheService<T>(
  //       dataConnectionService,
  //       fileIOService,
  //       parser,
  //       apiPath,
  //       filePath,
  //       cacheLocalStorage,
  //       m,
  //       idPrefix);
  // }

  CacheService(
      this._dataConnectionService,
      this._fileIOService,
      this._parser,
      this._apiPath,
      this._filePath,
      this._cacheLocalStorage,
      this._m,
      this._idPrefix)
      : super(_parser, _cacheLocalStorage, _m, _idPrefix);

  Future<void> LoadFromFileOnStartup() async {
    //because this is borking in store bulk, and we need this working now.
    await _fileIOService.deleteDataFile(_filePath);
    //await storeBulk(await _fileIOService.readDataFile(_filePath) ?? <T>[]);
  }



  Future<T?> getById(String key) async {
    return (await super.get([key], (x) async => await loadById(x?.firstOrNull)))
        ?.firstOrNull;
  }

  Future<List<String>?> loadById(String? key) async {
    if (key == null) {
      return null;
    }
    return await _m.protectWrite(() async {
      T? entity;
      try {
        //Ensure we have the most recently edited version of the entity.
        T? entityServer = (!(key.startsWith(ID_TempIDPrefix)))
            ? _parser.fromJson(
                jsonDecode(await _dataConnectionService.get("$_apiPath/$key"))
                    as Map<String, dynamic>)
            : null;
        String? cacheLocal = await _cacheLocalStorage.getItem(key);
        T? entityLocal = cacheLocal != null ? _parser.fromJson(jsonDecode(cacheLocal)) : await _fileIOService.readDataFileByKey(_filePath, key);

        if (entityLocal != null && entityServer != null) {
          if(entityLocal.dateUpdated.isAfter(entityServer.dateUpdated)){
            entity = _parser.fromJson(jsonDecode(
              await _dataConnectionService.post(_apiPath, entityLocal)));
              cacheSyncFlags[key] = true;
          } else {
            entity = entityServer;
          }

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
      } catch (e) {
        rethrow;
      }
      if (entity != null) {
        entity = await storeUnprotected(key, entity);
        return [jsonEncode(entity.toJson())];
      } else {
        return null;
      }
    });
  }

  Future<List<String>?> LoadBulk(String apiPath, Function(T) comparer) async {
    List<T> entities = <T>[];
    try {
      List<T> localEntities = (await _fileIOService.readDataFile(_filePath))
              ?.where((e) => comparer(e))
              .toList() ??
          <T>[];

      if(apiPath.contains(ID_TempIDPrefix)){
        entities = localEntities;
        return (await storeBulk(entities))
            .map((e) => jsonEncode(e.toJson()))
            .toList();
      }
      
      String? entitiesJsonRemote =  await _dataConnectionService.get(apiPath);
      List<T> remoteEntities = (entitiesJsonRemote?.isEmpty ?? true)
          ? []
          : (jsonDecode(entitiesJsonRemote) as List<dynamic>)
              .map<T>((dynamic e) =>
                  _parser.fromJson(e as Map<String, dynamic>) as T)
              .toList()
              .cast<T>();
      
      //TEMP IMPELMENTATION: If we have conflciting versions of the same entities, we will need to medaite that. For now, we'll just overwrite with the version most recently updated.
      List<String> ids = localEntities.map((e) => e.id).toList();
      ids.insertAll(0, remoteEntities.map((e) => e.id));
      ids.toSet().toList().forEach((id) async {
        int localIndex = localEntities.indexWhere((e) => e.id == id);
        if (localIndex == -1) {
          entities.add(remoteEntities.firstWhere((e) => e.id == id ));
        } else {
          int remoteIndex = remoteEntities.indexWhere((e) => e.id == id);
          if (remoteIndex == -1) {
            if(id.startsWith(ID_TempIDPrefix)){
              //Potential for multiple temp entries to require pushing to the server. However... we can't distinguish if they should be updated yet, or not, and then calling the full update logic through the change mangaer. 
              //issue we have here is simple. We need to update it on the server. But we need to do it through the change manager.
              //My idea is this. Add a new method to the cache interface that app side only. Use this to update the server by calling the specific methods from the change manager here.
              //Honestly, I'm not actually gonna fix this. This will be updated any time we need to get the entity in question as part of the upper load. 
              //If we go any further with this app, then NOTE: This is a problem that needs to be fixed.      
              entities.add(localEntities[localIndex]);
            } else {
              await delete(id);
            }
          } else {
            if (localEntities[localIndex]
                .dateUpdated
                .isAfter(remoteEntities[remoteIndex].dateUpdated)) {
              entities.add(_parser.fromJson(jsonDecode(
              await _dataConnectionService.post(_apiPath, localEntities[localIndex]))));
              cacheSyncFlags[id] = true;
            } else {
              entities.add(remoteEntities[remoteIndex]);
            }
          }
        }
      });
    } on HttpException catch (e) {
      switch (e.response) {
        case HttpResponse.NotFound:
          entities = (await _fileIOService.readDataFile(_filePath))
                  ?.where((e) => comparer(e))
                  .toList() ??
              <T>[];
          break;
        case HttpResponse.ServiceUnavailable:
          entities = (await _fileIOService.readDataFile(_filePath))
                  ?.where((e) => comparer(e))
                  .toList() ??
              <T>[];
        default:
          rethrow;
      }
    }
    return (await storeBulk(entities))
        .map((e) => jsonEncode(e.toJson()))
        .toList();
  }

  @override
  Future<T> storeUnprotected(String key, T value) async {
    T storedVal = await super.storeUnprotected(key, value);
    //Need to save it, or data sync will detect a difference in cache, and then try to get the latest version from the file.
    await _fileIOService.saveDataFile(_filePath, [storedVal]);
    return storedVal;
  }

  Future<bool> setCacheSyncFlags(
      HashMap<String, String> serverCheckSums, ) async {
    return await _m.protectWrite(() async {
      bool anyUnsynced = false;
      serverCheckSums.forEach((key, value) async {
        if (value == EntityState.deleted.toString()) {
          await deleteUnprotected(key);
          cacheCheckSums.remove(key);
        } else if (cacheCheckSums[key] != value) {
          cacheSyncFlags[key] = false;
          anyUnsynced = true;
        }
      });
      return anyUnsynced;
    });
  }
}
