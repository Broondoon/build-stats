import 'package:build_stats_flutter/model/Domain/Interface/data_connection_service.dart';
import 'package:build_stats_flutter/model/Domain/Interface/file_IO_service.dart';
import 'package:build_stats_flutter/model/entity/checklist.dart';
import 'package:build_stats_flutter/model/entity/item.dart';
import 'package:build_stats_flutter/model/entity/worksite.dart';
import 'package:build_stats_flutter/model/storage/checklist_cache.dart';
import 'package:build_stats_flutter/model/storage/item_cache.dart';
import 'package:build_stats_flutter/model/storage/worksite_cache.dart';

class ChangeManager {
  final DataConnectionService<Worksite> _worksiteDataConnectionService;
  final DataConnectionService<ChecklistDay> _checklistDayDataConnectionService;
  final DataConnectionService<Item> _itemDataConnectionService;
  final WorksiteCache _worksiteCache;
  final ChecklistCache _checklistCache;
  final ItemCache _itemCache;
  final FileIOService _fileIOService;

  ChangeManager(
      this._worksiteDataConnectionService,
      this._checklistDayDataConnectionService,
      this._itemDataConnectionService,
      this._worksiteCache,
      this._checklistCache,
      this._itemCache,
      this._fileIOService);

  Future<List<Worksite>> GetUserWorksites(String userId) async {
    List<Worksite> worksites =
        (await _worksiteDataConnectionService.get(path, [userId])).toList();

    throw UnimplementedError();
  }

  Future<Worksite?> GetWorksiteById(String id) async {
    throw UnimplementedError();
  }

  Future<Worksite> CreateWorksite() async {
    throw UnimplementedError();
  }

  Future<Worksite> UpdateWorksite(Worksite worksite) async {
    throw UnimplementedError();

    static Future<Null> SaveWorksite(Worksite worksite) async {
    List<Worksite> worksites = await _getWorksites();

    // Flag to check if the worksite was saved
    // Traverse the hierarchy to find where to save the worksite
    int worksiteIndex = worksites.indexWhere((i) => i.id == worksite.id);
    if (worksiteIndex != -1) {
      worksites[worksiteIndex] = worksite;
    } else {
      worksites.add(worksite);
    }
    // Encode the worksites back to JSON and save to the file
    String updatedJson =
        jsonEncode(worksites.map((worksite) => worksite.toJson()).toList());
    await FileAccess.SaveDataFile(WorksiteFileString, updatedJson);
  }
  }

  Future<bool> DeleteWorksite(Worksite worksite) async {
    throw UnimplementedError();
  }

  Future<ChecklistDay> GetChecklistDayByDate(
      DateTime date, Checklist checklist) async {
    throw UnimplementedError();
  }

  Future<ChecklistDay?> GetChecklistDayById(String id) async {
    throw UnimplementedError();
  }

  Future<bool> RemoveChecklistDay(
      Checklist checklist, ChecklistDay checklistDay) async {
    throw UnimplementedError();
  }

  Future<bool> RemoveChecklist(Checklist checklist) async {
    throw UnimplementedError();
  }

  Future<bool> DeleteChecklist(Checklist checklist) async {
    throw UnimplementedError();
  }

  Future<Item> GetItemById(String id) async {
    throw UnimplementedError();
  }

  Future<List<Item>> GetItemsByCategory(String category) async {
    throw UnimplementedError();
  }

  Future<bool> RemoveItem(Item item) async {
    throw UnimplementedError();
  }

  Future<bool> DeleteItem(String checklistDayId, Item item) async {
    throw UnimplementedError();
  }

  Future<ChecklistDay> UpdateChecklistDay(
      ChecklistDay checklistDay, DateTime date) async {
    throw UnimplementedError();
  }

  Future<Checklist> UpdateChecklist(Checklist checklist) async {
    throw UnimplementedError();
  }

  Future<Item> UpdateItem(Item item) async {
    throw UnimplementedError();
  }
}
