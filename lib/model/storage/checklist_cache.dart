import 'package:build_stats_flutter/model/Domain/Interface/cache_service.dart';
import 'package:build_stats_flutter/model/Domain/Interface/data_connection_service.dart';
import 'package:build_stats_flutter/model/entity/checklist.dart';
import 'package:build_stats_flutter/model/storage/local_storage/file_access.dart';
import 'package:build_stats_flutter/resources/app_strings.dart';
import 'package:localstorage/localstorage.dart';

class ChecklistCache extends CacheService<ChecklistDay> {
  ChecklistCache(DataConnectionService<ChecklistDay> dataConnectionService,
      JsonFileAccess fileIOService)
      : super(dataConnectionService, fileIOService, ChecklistDayFactory(),
            API_WorksitePath, ChecklistFileString, localStorage);
}
