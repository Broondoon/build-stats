import 'package:build_stats_flutter/model/Domain/Service/cache_service.dart';
import 'package:build_stats_flutter/model/Domain/Service/data_connection_service.dart';
import 'package:build_stats_flutter/model/entity/checklist.dart';
import 'package:build_stats_flutter/model/entity/worksite.dart';
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

  Future<List<ChecklistDay>?> getChecklistDaysForChecklist(
          Checklist checklist) async =>
      await get(
          checklist.checklistIdsByDate.values.toList(),
          (x) async => await LoadBulk(
              "$API_DaysOnChecklistPath//${checklist.id}",
              (ChecklistDay x) => x.checklistId == checklist.id));
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

  Future<List<Checklist>?> getChecklistForWorksite(Worksite worksite) async =>
      await get(
          worksite.checklistIds ?? [],
          (x) async => await LoadBulk(
              "$API_ChecklistOnWorksitePath//${worksite.id}",
              (Checklist x) => x.worksiteId == worksite.id));
}
