import 'package:build_stats_flutter/model/entity/checklist.dart';
import 'package:build_stats_flutter/model/storage/checklist_cache.dart';
import 'package:build_stats_flutter/model/storage/item_cache.dart';
import 'package:build_stats_flutter/model/storage/worksite_cache.dart';
import 'package:to_csv/to_csv.dart' as exportCSV;
import 'package:injector/injector.dart';

class ToCSV {
  // ignore: non_constant_identifier_names
  static WorksiteToCSV(String worksiteId) async {
    List<String> headers = [
      'ChecklistName',
      'Date',
      'Catagory',
      'Unit',
      'Desc',
      'Result',
      'Verified',
      'ItemComment',
      'ChecklistDayComment'
    ];
    List<List<String>> data = [];

    final injector = Injector.appInstance;
    final worksite = await injector.get<WorksiteCache>().getById(worksiteId);
    if (worksite == null) {
      return;
    }
    final checklists =
        await injector.get<ChecklistCache>().getChecklistForWorksite(worksite);
    if (checklists == null) {
      return;
    }
    final checklistDaysCache = injector.get<ChecklistDayCache>();
    final itemCache = injector.get<ItemCache>();
    for (Checklist checklist in checklists) {
      final checklistDays =
          await checklistDaysCache.getChecklistDaysForChecklist(checklist);
      if (checklistDays == null) {
        continue;
      }
      for (ChecklistDay checklistDay in checklistDays) {
        final items = await itemCache.getItemsForChecklistDay(checklistDay);
        for (String catagory in items.keys) {
          for (var item in items[catagory]!) {
            data.add([
              checklist.name ?? '',
              checklistDay.date.toIso8601String(),
              catagory,
              item.unit ?? '',
              item.desc ?? '',
              item.result ?? '',
              item.verified.toString(),
              item.comment ?? '',
              checklistDay.comment ?? ''
            ]);
          }
        }
      }
    }

    await exportCSV.myCSV(
      headers,
      data,
      setHeadersInFirstRow: true,
      fileName:
          '${worksite.id}_Full_Export_${DateTime.now().toIso8601String().replaceAll(RegExp(r'[.\:-]'), "_")}.csv',
      removeDuplicates: true,
    );
  }
}
