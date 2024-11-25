import 'dart:collection';
import 'dart:convert';

import 'package:build_stats_flutter/model/Domain/Service/data_connection_service.dart';
import 'package:build_stats_flutter/model/entity/unit.dart';
import 'package:build_stats_flutter/model/Domain/Service/cache_service.dart';
import 'package:build_stats_flutter/model/entity/user.dart';
import 'package:build_stats_flutter/model/storage/local_storage/file_access.dart';
import 'package:mutex/mutex.dart';
import 'package:shared/app_strings.dart';
import 'package:shared/cache.dart';

class UnitCache extends CacheService<Unit> {
  UnitFactory parser;
  UnitCache(
      DataConnectionService<Unit> dataConnectionService,
      JsonFileAccess<Unit> fileIOService,
      this.parser,
      LocalStorage localStorage,
      ReadWriteMutex m)
      : super(dataConnectionService, fileIOService, parser, API_UnitPath,
            Dir_UnitFileString, localStorage, m, ID_UnitPrefix);

  bool _haveLoadedCompanyUnits = false;

  Future<List<Unit>?> getCompanyUnits(User user) async {
    if (!_haveLoadedCompanyUnits) {
      _haveLoadedCompanyUnits = true;
      return (await LoadBulk("$API_UnitsAllPath/${user.companyId}",
              (Unit x) => x.companyId == user.companyId))
          ?.map((e) => parser.fromJson(jsonDecode(e)))
          .toList();
      //Skipping checking saved file for deleting worksites on server. Push to Milestone 3
    } else {
      return await getAll((x) async => await LoadBulk(
          "$API_UnitsAllPath/${user.companyId}",
          (Unit x) => x.companyId == user.companyId));
    }
  }

  Future<HashMap<String, String>> getUnitIdPairs() async {
    HashMap<String, String> unitIdPairs = HashMap<String, String>.fromIterable(
        (await getAll((x) async => null))!,
        key: (e) => e.id,
        value: (e) => e.name);
    unitIdPairs.addEntries([
      const MapEntry("", ""),
    ]);
    return unitIdPairs;
  }
}
