import 'package:build_stats_flutter/model/Domain/Interface/data_connection_service.dart';
import 'package:build_stats_flutter/model/entity/worksite.dart';
import 'package:build_stats_flutter/model/Domain/Interface/cache_service.dart';
import 'package:build_stats_flutter/model/storage/local_storage/file_access.dart';
import 'package:build_stats_flutter/resources/app_strings.dart';
import 'package:localstorage/localstorage.dart';

class WorksiteCache extends CacheService<Worksite> {
  WorksiteCache(DataConnectionService<Worksite> dataConnectionService,
      JsonFileAccess<Worksite> fileIOService)
      : super(dataConnectionService, fileIOService, WorksiteFactory(),
            API_WorksitePath, Dir_WorksiteFileString, localStorage);
}
