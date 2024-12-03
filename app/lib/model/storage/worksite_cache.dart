import 'dart:convert';
// BRENDAN NOTE: Kyle this isn't available in the current version of flutter?
// It broke the web build so I'm turning it off (it's an unused import anyways?)
// import 'dart:ffi';

import 'package:build_stats_flutter/model/Domain/Service/data_connection_service.dart';
import 'package:build_stats_flutter/model/Domain/change_manager.dart';
import 'package:build_stats_flutter/model/entity/user.dart';
import 'package:build_stats_flutter/model/entity/worksite.dart';
import 'package:build_stats_flutter/model/Domain/Service/cache_service.dart';
import 'package:build_stats_flutter/model/storage/local_storage/file_access.dart';
import 'package:injector/injector.dart';
import 'package:mutex/mutex.dart';
import 'package:shared/app_strings.dart';
import 'package:shared/cache.dart';

class WorksiteCache extends CacheService<Worksite> {
  WorksiteFactory parser;
  WorksiteCache(
      DataConnectionService<Worksite> dataConnectionService,
      JsonFileAccess<Worksite> fileIOService,
      this.parser,
      LocalStorage localStorage,
      ReadWriteMutex m)
      : super(dataConnectionService, fileIOService, parser, API_WorksitePath,
            Dir_WorksiteFileString, localStorage, m, ID_WorksitePrefix);
  bool _haveLoadedUserWorksites = false;
  void overrideHaveLoadedUserWorksites(bool value) {
    _haveLoadedUserWorksites = value;
  }

  Future<List<Worksite>?> getUserWorksites(User user) async {
    if (!_haveLoadedUserWorksites) {
      _haveLoadedUserWorksites = true;
      return (await LoadBulk(
              "$API_WorksiteUserVisiblePath/${user.companyId}/${user.id}",
              (Worksite x) => x.ownerId == user.id))
          ?.map((e) => parser.fromJson(jsonDecode(e)))
          .toList();
      //Skipping checking saved file for deleting worksites on server. Push to Milestone 3
    } else {
      return await getAll((x) async => await LoadBulk(
          "$API_WorksiteUserVisiblePath/${user.companyId}/${user.id}",
          (Worksite x) => x.ownerId == user.id));
    }
  }
}
