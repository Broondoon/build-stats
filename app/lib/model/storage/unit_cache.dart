import 'dart:collection';
import 'dart:convert';

import 'package:build_stats_flutter/model/Domain/Service/data_connection_service.dart';
import 'package:build_stats_flutter/model/entity/unit.dart';
import 'package:build_stats_flutter/model/Domain/Service/cache_service.dart';
import 'package:build_stats_flutter/model/entity/user.dart';
import 'package:build_stats_flutter/model/storage/local_storage/file_access.dart';
import 'package:build_stats_flutter/views/state_controller.dart';
import 'package:injector/injector.dart';
import 'package:mutex/mutex.dart';
import 'package:provider/provider.dart';
import 'package:shared/app_strings.dart';
import 'package:shared/cache.dart';
import 'package:shared/unit.dart';

class UnitCache extends CacheService<Unit> {
  UnitFactory parser;
  ReadWriteMutex _m;
  UnitCache(
      DataConnectionService<Unit> dataConnectionService,
      JsonFileAccess<Unit> fileIOService,
      this.parser,
      LocalStorage localStorage,
      this._m)
      : super(dataConnectionService, fileIOService, parser, API_UnitPath,
            Dir_UnitFileString, localStorage, _m, ID_UnitPrefix);

  bool _haveLoadedCompanyUnits = false;
  String _companyId = "";

  Future<List<Unit>?> getCompanyUnits(User user) async {
    if (!_haveLoadedCompanyUnits) {
      _haveLoadedCompanyUnits = true;
      _companyId = user.companyId;
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

  // data sync might reveal unit cache to be out of date. However, we never grab it in a way that would allow us to update out of date units.
  //so instead we do a cache sync now. However, that might make the units in the app state out of date. so we also need to updeate them there too.
  @override
  Future<bool> setCacheSyncFlags(
      HashMap<String, String> serverCheckSums) async {
    if(await super.setCacheSyncFlags(serverCheckSums)){
      await LoadBulk('$API_UnitsAllPath/$_companyId', (Unit x) =>  !((cacheSyncFlags[x.id] ?? true)));
      List<Unit>? units = (await getAll((x) async => null));
      if (units != null) {
        //This is an absolute guess if it will work.
        Injector.appInstance.get<MyAppState>(dependencyName: AppStateDependancyName).setUnits(units);
      }
      return true;
    }
    return false;
  }
}
