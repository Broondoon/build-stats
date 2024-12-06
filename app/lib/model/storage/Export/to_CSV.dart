
import 'dart:collection';
import 'dart:io';

import 'package:build_stats_flutter/model/entity/checklist.dart';
import 'package:build_stats_flutter/model/entity/item.dart';
import 'package:build_stats_flutter/model/entity/user.dart';
import 'package:build_stats_flutter/model/storage/checklist_cache.dart';
import 'package:build_stats_flutter/model/storage/item_cache.dart';
import 'package:build_stats_flutter/model/storage/unit_cache.dart';
import 'package:build_stats_flutter/model/storage/worksite_cache.dart';
import 'package:csv/csv.dart';
import 'package:injector/injector.dart';
import 'package:external_path/external_path.dart';
import 'package:path_provider/path_provider.dart';

class ToCSV {
  // ignore: non_constant_identifier_names
      static WorksiteToCSV(User user, String worksiteId) async {
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
    data.add(headers);

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
    checklists.sort((a, b) => a.name.compareTo(b.name));
    final checklistDaysCache = injector.get<ChecklistDayCache>();
    final itemCache = injector.get<ItemCache>();
    final unitCache = injector.get<UnitCache>();
    HashMap<String, String> units = HashMap.from(await unitCache
        .getCompanyUnits(user)
        .then((value) => Map<String, String>.fromEntries(
            value!.map((e) => MapEntry(e.id, e.name)))));
    units.addEntries([const MapEntry('', '')]);
    for (Checklist checklist in checklists) {
      final checklistDays =
          await checklistDaysCache.getChecklistDaysForChecklist(checklist);
      if (checklistDays == null) {
        continue;
      }
      checklistDays.sort((a, b) => a.date.compareTo(b.date));
      for (ChecklistDay checklistDay in checklistDays) {
        final items = await itemCache.getItemsForChecklistDay(checklistDay);
        List<String> keys = items.keys.toList();
        keys.sort();
        for (String catagory in keys) {
          List<Item> itemsList = items[catagory]!;
          //sort by unit and then by desc
          itemsList.sort((a, b) {
            if (a.unitId == b.unitId) {
              return (a.desc ?? '').compareTo(b.desc ?? '');
            }
            return (units[a.unitId ?? ''] ?? '').compareTo(units[b.unitId ?? ''] ?? '');
          });
          for (var item in itemsList) {
            data.add([
              checklist.name,
              checklistDay.date.toIso8601String(),
              catagory,
              units[item.unitId ?? ''] ?? '',
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

    // List<dynamic> Test = await exportCSV.myCSV(
    //   headers,
    //   data,
    //   setHeadersInFirstRow: true,
    //   fileName:
    //       '${worksite.name.isEmpty ? worksite.id : worksite.name}_Full_Export_${DateTime.now().toIso8601String().replaceAll(RegExp(r'[.\:-]'), "_")}',
    //   removeDuplicates: true,
    // );
    String dir;
    if (Platform.isWindows || Platform.isLinux || Platform.isMacOS) {
      dir = (await getDownloadsDirectory())!.path;
    } else if (Platform.isAndroid || Platform.isIOS) {
      dir =  await ExternalPath.getExternalStoragePublicDirectory(ExternalPath.DIRECTORY_DOWNLOADS);
    } else {
      dir = (await getApplicationDocumentsDirectory()).path;
    }

    String csv = const ListToCsvConverter().convert(data);
    String filePath = "$dir/${worksite.name.isEmpty ? worksite.id : worksite.name}_Full_Export_${DateTime.now().toIso8601String().replaceAll(RegExp(r'[.\:-]'), "_")}.csv";
    File file = File(filePath);
    await file.writeAsString(csv);
      }

  
}
