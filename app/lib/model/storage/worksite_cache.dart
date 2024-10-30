import 'package:build_stats_flutter/model/Domain/Service/data_connection_service.dart';
import 'package:build_stats_flutter/model/entity/worksite.dart';
import 'package:build_stats_flutter/model/Domain/Service/cache_service.dart';
import 'package:build_stats_flutter/model/storage/local_storage/file_access.dart';
import 'package:localstorage/localstorage.dart';
import 'package:mutex/mutex.dart';
import 'package:shared/app_strings.dart';

class WorksiteCache extends CacheService<Worksite> {
  WorksiteCache(DataConnectionService<Worksite> dataConnectionService,
      JsonFileAccess<Worksite> fileIOService)
      : super(
            dataConnectionService,
            fileIOService,
            WorksiteFactory(),
            API_WorksitePath,
            Dir_WorksiteFileString,
            localStorage,
            ReadWriteMutex());
}
