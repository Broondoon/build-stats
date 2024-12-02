import 'dart:collection';
import 'dart:convert';
import 'dart:core';
import 'package:meta/meta.dart';
import 'package:mutex/mutex.dart';
import 'package:shared/app_strings.dart';
import 'package:shared/cache.dart';
import 'package:shared/entity.dart';

class CacheService<T extends Entity> extends Cache<T> {
  final EntityFactoryInterface<T> _parser;
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

  //testing only
  CacheService(this._parser, this._cacheLocalStorage, this._m, this._idPrefix)
      : super(
          _parser,
          _cacheLocalStorage,
          _m,
          _idPrefix,
        );

  Future<T?> getById(String key) async {
    // if (_cacheLocalStorage.keys.isEmpty) {
    //   testDeepCache.forEach((key, value) async {
    //     print(value);
    //     await _cacheLocalStorage.setItem(key, value);
    //   });
    // }
    // var test = await super.get([key], (x) async => await loadById(x?.first));
    return (await super
            .get([key], (x) async => null)) //await loadById(x?.first)))
        ?.firstOrNull;
  }

  // @override
  // Future<List<T>?> getAll(String idPrefix,
  //         Future<List<String>?> Function(List<String>?) onCacheMiss) async =>
  //     await get(_cacheLocalStorage.keys.toList(), onCacheMiss);

//Long term storage disabled for MVP.
  // Future<List<String>?> loadById(String? key) async {
  //   if (key == null) {
  //     return null;
  //   }
  //   return await _m.protectWrite(() async {
  //     T? entity;
  //     try {
  //       // Ensure we have the most recently edited version of the entity.
  //       // This is a temp fix for noow, as we should let the user determine if they want to overwrite the local version.
  //        T? entityServer = null;
  //        //(!(key.startsWith(ID_TempIDPrefix)))
  //       //     ? _parser.fromJson(
  //       //         jsonDecode(await _dataConnectionService.get("$_apiPath//$key"))
  //       //             .first)
  //       //    : null;
  //       T? entityLocal = await _fileIOService.readDataFileByKey(_filePath, key);

  //       if (entityLocal != null && entityServer != null) {
  //         entity = (entityLocal.dateUpdated.isAfter(entityServer.dateUpdated))
  //             ? entityLocal
  //             : entityServer;
  //       } else {
  //         entity = entityLocal ?? entityServer;
  //       }

  //       //Need to put test data in here for now.
  //       print(testDeepCache[key]);
  //       print(jsonDecode(testDeepCache[key]!) as Map<String, dynamic>);

  //       entity = _parser
  //           .fromJson(jsonDecode(testDeepCache[key]!) as Map<String, dynamic>);
  //     } catch (e) {
  //       rethrow;
  //     }
  //     if (entity != null) {
  //       entity = await storeUnprotected(key, entity);
  //     }
  //     return entity;
  //   });
  // }

  // Future<List<T>?> LoadBulk(Function(T) comparer) async {
  //   List<T>? entities = <T>[];
  //   try {
  //     // String? entitiesJsonRemote = await _dataConnectionService.get(apiPath);
  //     // List<T> localEntities = (await _fileIOService.readDataFile(_filePath))
  //     //         ?.where((e) => comparer(e))
  //     //         .toList() ??
  //     //     <T>[];
  //     // List<T> remoteEntities = jsonDecode(entitiesJsonRemote)
  //     //     .map<T>((e) => _parser.fromJson(e))
  //     //     .toList();
  //     // //TEMP IMPELMENTATION: If we have conflciting versions of the same entities, we will need to medaite that. For now, we'll just overwrite with the version most recently updated.
  //     // List<String> ids = localEntities.map((e) => e.id).toList();
  //     // ids.insertAll(0, remoteEntities.map((e) => e.id));
  //     // ids.toSet().toList().forEach((id) async {
  //     //   int localIndex = localEntities.indexWhere((e) => e.id == id);
  //     //   if (localIndex == -1) {
  //     //     entities.add(remoteEntities.firstWhere((e) => e.id == id));
  //     //   } else {
  //     //     int remoteIndex = remoteEntities.indexWhere((e) => e.id == id);
  //     //     if (remoteIndex == -1) {
  //     //       entities.add(localEntities[localIndex]);
  //     //     } else {
  //     //       if (localEntities[localIndex]
  //     //           .dateUpdated
  //     //           .isAfter(remoteEntities[remoteIndex].dateUpdated)) {
  //     //         entities.add(localEntities[localIndex]);
  //     //       } else {
  //     //         entities.add(remoteEntities[remoteIndex]);
  //     //       }
  //     //     }
  //     //   }
  //     // });

  //     //Test implementaion
  //     entities = testDeepCache.values
  //         .map((entityJson) => _parser.fromJson(jsonDecode(entityJson)))
  //         .toList()
  //         .where((e) => comparer(e))
  //         .cast<T>()
  //         .toList();
  //   } catch (e) {
  //     rethrow;
  //   }
  //   return await storeBulk(entities);
  // }
}
