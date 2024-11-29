import 'dart:collection';
import 'dart:convert';

import 'package:build_stats_flutter/model/Domain/Service/data_connection_service.dart';
import 'package:build_stats_flutter/model/Domain/change_manager.dart';
import 'package:build_stats_flutter/model/entity/checklist.dart';
import 'package:build_stats_flutter/model/entity/item.dart';
import 'package:build_stats_flutter/model/Domain/Service/cache_service.dart';
import 'package:build_stats_flutter/model/storage/checklist_cache.dart';
import 'package:build_stats_flutter/model/storage/local_storage/file_access.dart';
import 'package:injector/injector.dart';
import 'package:mutex/mutex.dart';
import 'package:shared/app_strings.dart';
import 'package:shared/cache.dart';

class ItemCache extends CacheService<Item> {
  ItemFactory parser;
  ItemCache(
      DataConnectionService<Item> dataConnectionService,
      JsonFileAccess<Item> fileIOService,
      this.parser,
      LocalStorage localStorage,
      ReadWriteMutex m)
      : super(dataConnectionService, fileIOService, parser, API_ItemPath,
            Dir_ItemFileString, localStorage, m, ID_ItemPrefix);

  //nasty solution. Need to refactor
  Future<List<Item>?> loadChecklistItemsForChecklist(
          Checklist checklist) async =>
      (await LoadBulk(
              "$API_ItemOnChecklistPath/${checklist.id}",
              (Item x) => checklist.checklistIdsByDate.values
                  .contains(x.checklistDayId)))
          ?.map((e) => parser.fromJson(jsonDecode(e)))
          .toList();

  Future<HashMap<String, List<Item>>> getItemsForChecklistDay(
      ChecklistDay checklistDay) async {
    List<String> keys =
        checklistDay.itemsByCatagory.values.expand((x) => x).toList();
    List<Item> unsortedItems = await get(
            keys,
            (x) async => await LoadBulk(
                "$API_ItemOnChecklistDayPath/${checklistDay.id}",
                (Item x) => x.checklistDayId == checklistDay.id)) ??
        [];

    HashMap<String, List<Item>> items = HashMap<String, List<Item>>();
    for (String catagory in checklistDay.itemsByCatagory.keys) {
      items[catagory] = [];
    }
    for (Item item in unsortedItems) {
      items[checklistDay.getCategoryForItem(item)]!.add(item);
    }
    return items;
  }
}
