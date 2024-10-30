import 'package:build_stats_flutter/model/Domain/Service/cache_service.dart';
import 'package:build_stats_flutter/model/Domain/Service/data_connection_service.dart';
import 'package:build_stats_flutter/model/entity/checklist.dart';
import 'package:build_stats_flutter/model/storage/local_storage/file_access.dart';
import 'package:localstorage/localstorage.dart';
import 'package:mutex/mutex.dart';
import 'package:shared/app_strings.dart';

class ChecklistDayCache extends CacheService<ChecklistDay> {
  ChecklistDayCache(DataConnectionService<ChecklistDay> dataConnectionService,
      JsonFileAccess<ChecklistDay> fileIOService)
      : super(
            dataConnectionService,
            fileIOService,
            ChecklistDayFactory(),
            API_WorksitePath,
            Dir_ChecklistDayFileString,
            localStorage,
            ReadWriteMutex());
}

class ChecklistCache extends CacheService<Checklist> {
  ChecklistCache(DataConnectionService<Checklist> dataConnectionService,
      JsonFileAccess<Checklist> fileIOService)
      : super(
            dataConnectionService,
            fileIOService,
            ChecklistFactory(),
            API_ChecklistDayPath,
            Dir_ChecklistFileString,
            localStorage,
            ReadWriteMutex());
}
