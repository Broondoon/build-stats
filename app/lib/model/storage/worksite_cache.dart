import 'package:build_stats_flutter/model/Domain/Service/data_connection_service.dart';
import 'package:build_stats_flutter/model/entity/user.dart';
import 'package:build_stats_flutter/model/entity/worksite.dart';
import 'package:build_stats_flutter/model/Domain/Service/cache_service.dart';
import 'package:build_stats_flutter/model/storage/local_storage/file_access.dart';
import 'package:localstorage/localstorage.dart';
import 'package:mutex/mutex.dart';
import 'package:shared/app_strings.dart';

class WorksiteCache extends CacheService<Worksite> {
  WorksiteCache(
      DataConnectionService<Worksite> dataConnectionService,
      JsonFileAccess<Worksite> fileIOService,
      WorksiteFactory parser,
      LocalStorage localStorage,
      ReadWriteMutex m)
      : super(dataConnectionService, fileIOService, parser, API_WorksitePath,
            Dir_WorksiteFileString, localStorage, m);
  bool _haveLoadedUserWorksites = false;

  Future<List<Worksite>?> getUserWorksites(User user) async {
    if (!_haveLoadedUserWorksites) {
      _haveLoadedUserWorksites = true;
      return await LoadBulk(
          "$API_WorksiteUserVisiblePath//${user.companyId}//${user.id}",
          (Worksite x) => x.ownerId == user.id);
      //Skipping checking saved file for deleting worksites on server. Push to Milestone 3
    } else {
      return await getAll((x) async => await LoadBulk(
          "$API_WorksiteUserVisiblePath//${user.companyId}//${user.id}",
          (Worksite x) => x.ownerId == user.id));
    }
  }
}
