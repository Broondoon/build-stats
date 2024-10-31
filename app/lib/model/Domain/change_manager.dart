import 'dart:collection';
import 'dart:convert';

import 'package:build_stats_flutter/model/Domain/Exception/http_exception.dart';
import 'package:build_stats_flutter/model/Domain/Service/data_connection_service.dart';
import 'package:build_stats_flutter/model/Domain/Service/file_IO_service.dart';
import 'package:build_stats_flutter/model/entity/checklist.dart';
import 'package:build_stats_flutter/model/entity/item.dart';
import 'package:build_stats_flutter/model/entity/user.dart';
import 'package:build_stats_flutter/model/entity/worksite.dart';
import 'package:build_stats_flutter/model/storage/checklist_cache.dart';
import 'package:build_stats_flutter/model/storage/item_cache.dart';
import 'package:build_stats_flutter/model/storage/worksite_cache.dart';
import 'package:build_stats_flutter/resources/app_enums.dart';
import 'package:shared/app_strings.dart';
import 'package:shared/entity.dart';

class ChangeManager {
  final DataConnectionService<Worksite> _worksiteDataConnectionService;
  final DataConnectionService<Checklist> _checklistDataConnectionService;
  final DataConnectionService<ChecklistDay> _checklistDayDataConnectionService;
  final DataConnectionService<Item> _itemDataConnectionService;
  final WorksiteCache _worksiteCache;
  final ChecklistCache _checklistCache;
  final ChecklistDayCache _checklistDayCache;
  final ItemCache _itemCache;
  final FileIOService<Worksite> _worksiteFileIOService;
  final FileIOService<Checklist> _checklistFileIOService;
  final FileIOService<ChecklistDay> _checklistDayFileIOService;
  final FileIOService<Item> _itemFileIOService;
  final EntityFactory<Worksite> _worksiteFactory;
  final EntityFactory<Checklist> _checklistFactory;
  final EntityFactory<ChecklistDay> _checklistDayFactory;
  final EntityFactory<Item> _itemFactory;

  ChangeManager(
    this._worksiteDataConnectionService,
    this._checklistDataConnectionService,
    this._checklistDayDataConnectionService,
    this._itemDataConnectionService,
    this._worksiteCache,
    this._checklistCache,
    this._checklistDayCache,
    this._itemCache,
    this._worksiteFileIOService,
    this._checklistFileIOService,
    this._checklistDayFileIOService,
    this._itemFileIOService,
    this._worksiteFactory,
    this._checklistFactory,
    this._checklistDayFactory,
    this._itemFactory,
  );

  //No automatic detection for deleting desynced entities currently exists. Will implment in Milestone 3
  Future<List<Worksite>?> getUserWorksites(User user) async {
    return _worksiteCache.getUserWorksites(user);
  }

  Future<Worksite?> getWorksiteById(String id) async {
    return await _worksiteCache.getById(id);
  }

  Future<Worksite> createWorksite() async {
    String tempId =
        "${ID_TempIDPrefix}${ID_WorksitePrefix}${DateTime.now().millisecondsSinceEpoch.toString()}";
    Worksite worksite = Worksite(
        id: tempId,
        dateCreated: DateTime.now().toUtc(),
        dateUpdated: DateTime.now().toUtc());
    await _worksiteCache.store(tempId, worksite);
    return worksite;
  }

  Future<Worksite> updateWorksite(Worksite worksite) async {
    if (worksite.id.startsWith(ID_TempIDPrefix)) {
      try {
        Worksite updatedWorksite = _worksiteFactory.fromJson(jsonDecode(
            await _worksiteDataConnectionService.post(
                API_WorksitePath, worksite)));
        worksite.checklistIds
            ?.where((id) => id.startsWith(ID_TempIDPrefix))
            .forEach((id) async {
          //Assumption here. The only checklists we should be updating here are temporary checklists, thus stored in the cache or file.
          //If they were real checklists, then this worksite would have been updated already. Thus, we can assume that the checklist is only local.
          Checklist checklist = (await _checklistCache.getById(id))!;
          checklist.worksiteId = updatedWorksite.id;
          await _checklistCache.store(checklist.id, checklist);
        });
        _worksiteFileIOService
            .deleteFromDataFile(Dir_WorksiteFileString, [worksite.id]);
        worksite = await _worksiteCache.store(
            worksite.id, updatedWorksite); //replace the temp version
      } on HttpException catch (e) {
        switch (e.response) {
          default:
            break;
        }
      } finally {
        _worksiteFileIOService.saveDataFile(Dir_WorksiteFileString, [worksite]);
      }
    } else if (worksite.getChecksum() !=
        (await _worksiteCache.getById(worksite.id))!.getChecksum()) {
      try {
        worksite = await _worksiteCache.store(
            worksite.id,
            _worksiteFactory.fromJson(jsonDecode(
                await _worksiteDataConnectionService.put(
                    API_WorksitePath, worksite))));
      } on HttpException catch (e) {
        switch (e.response) {
          default:
            break;
        }
      } finally {
        _worksiteFileIOService.saveDataFile(Dir_WorksiteFileString, [worksite]);
      }
    }
    return worksite;
  }

  Future<bool> deleteWorksite(Worksite worksite) async {
    try {
      if (!worksite.id.startsWith(ID_TempIDPrefix)) {
        await _worksiteDataConnectionService
            .delete(API_WorksitePath, [worksite.id]);
      }
      List<String> itemIds = [];
      List<String> checklistDayIds = [];
      List<String> checklistIds = worksite.checklistIds ?? <String>[];
      for (String checklistId in checklistIds) {
        List<String> itemIdsTemp = [];
        List<String> checklistDayIdsTemp = [];
        (checklistDayIdsTemp, itemIdsTemp) = await _removeChecklist(
            (await _checklistCache.getById(checklistId))!);
        itemIds.addAll(itemIdsTemp);
        checklistDayIds.addAll(checklistDayIdsTemp);
      }
      await _itemFileIOService.deleteFromDataFile(Dir_ItemFileString, itemIds);
      await _checklistDayFileIOService.deleteFromDataFile(
          Dir_ChecklistDayFileString, checklistDayIds);
      await _checklistFileIOService.deleteFromDataFile(
          Dir_ChecklistFileString, checklistIds);
      await _worksiteFileIOService
          .deleteFromDataFile(Dir_WorksiteFileString, [worksite.id]);
      await _worksiteCache.delete(worksite.id);
      return true;
    } on HttpException catch (e) {
      switch (e.response) {
        default:
          worksite.flagForDeletion = true;
          await _worksiteCache.store(worksite.id, worksite);
          await _worksiteFileIOService
              .saveDataFile(Dir_WorksiteFileString, [worksite]);
          return true;
      }
    }
  }

  //TEMP IMPELMENTATION
  //dirty implementation to preload checklist days and Items. I Fing hate this.
  HashSet<String> _checklistIds = HashSet<String>();
  Future<Checklist?> getChecklistById(String id) async {
    Checklist? checklist = await _checklistCache.getById(id);
    if (_checklistIds.contains(id)) {
      return checklist;
    }
    _checklistIds.add(id);
    if (checklist != null) {
      await _checklistDayCache.getChecklistDaysForChecklist(checklist);
      await _itemCache.loadChecklistItemsForChecklist(checklist);
    }
    return checklist;
  }

  Future<Checklist> createChecklist(Worksite worksite) async {
    String tempId =
        "${ID_TempIDPrefix}${ID_ChecklistPrefix}${DateTime.now().millisecondsSinceEpoch.toString()}";
    Checklist checklist = Checklist(
        id: tempId,
        worksiteId: worksite.id,
        dateCreated: DateTime.now().toUtc(),
        dateUpdated: DateTime.now().toUtc());
    worksite.checklistIds?.add(tempId);
    return await _checklistCache.store(tempId, checklist);
  }

  Future<Checklist> updateChecklist(Checklist checklist) async {
    if (checklist.id.startsWith(ID_TempIDPrefix)) {
      Worksite worksite = (await _worksiteCache.getById(checklist.worksiteId))!;

      //ensure worksite exists
      if (checklist.worksiteId.startsWith(ID_TempIDPrefix)) {
        worksite = await updateWorksite(worksite);
        checklist.worksiteId = worksite.id;
      }
      try {
        //update checklist
        Checklist updatedChecklist = _checklistFactory.fromJson(jsonDecode(
            await _checklistDataConnectionService.post(
                API_ChecklistPath, checklist)));

        //update checklistDays with new parent checklist ID
        checklist.checklistIdsByDate.values
            .where((id) => id.startsWith(ID_TempIDPrefix))
            .forEach((id) async {
          //Assumption here. The only checklistsDays we should be updating here are temporary checklistsDays, thus stored in the cache or file.
          //If they were real checklists, then this worksite would have been updated already. Thus, we can assume that the checklist is only local.
          ChecklistDay checklistDay = (await _checklistDayCache.getById(id))!;
          checklistDay.checklistId = updatedChecklist.id;
          await _checklistDayCache.store(checklistDay.id, checklistDay);
        });

        //update worksite with new checklist ID
        worksite.checklistIds?.add(updatedChecklist.id);
        worksite.checklistIds?.remove(checklist.id);
        worksite = await updateWorksite(worksite);

        //update checklist
        _checklistFileIOService
            .deleteFromDataFile(Dir_ChecklistFileString, [checklist.id]);
        checklist = await _checklistCache.store(
            checklist.id, updatedChecklist); //replace the temp version
      } on HttpException catch (e) {
        switch (e.response) {
          default:
            break;
        }
      } finally {
        _checklistFileIOService
            .saveDataFile(Dir_ChecklistFileString, [checklist]);
      }
    } else if (checklist.getChecksum() !=
        (await _checklistCache.getById(checklist.id))!.getChecksum()) {
      try {
        checklist = await _checklistCache.store(
            checklist.id,
            _checklistFactory.fromJson(jsonDecode(
                await _checklistDataConnectionService.put(
                    API_ChecklistPath, checklist))));
      } on HttpException catch (e) {
        switch (e.response) {
          default:
            break;
        }
      } finally {
        _checklistFileIOService
            .saveDataFile(Dir_ChecklistFileString, [checklist]);
      }
    }
    return checklist;
  }

  Future<Worksite> deleteChecklist(
      Worksite worksite, Checklist checklist) async {
    try {
      if (!checklist.id.startsWith(ID_TempIDPrefix)) {
        await _checklistDataConnectionService
            .delete(API_ChecklistPath, [checklist.id]);
      }
      List<String> itemIds = [];
      List<String> checklistDayIds = [];
      (checklistDayIds, itemIds) = await _removeChecklist(checklist);
      await _itemFileIOService.deleteFromDataFile(Dir_ItemFileString, itemIds);
      await _checklistDayFileIOService.deleteFromDataFile(
          Dir_ChecklistDayFileString, checklistDayIds);
      await _checklistFileIOService
          .deleteFromDataFile(Dir_ChecklistFileString, [checklist.id]);
    } on HttpException catch (e) {
      switch (e.response) {
        default:
          checklist.flagForDeletion = true;
          await _checklistCache.store(checklist.id, checklist);
          await _checklistFileIOService
              .saveDataFile(Dir_ChecklistFileString, [checklist]);
      }
    } finally {
      worksite.checklistIds?.remove(checklist.id);
      if (checklist.id.startsWith(ID_TempIDPrefix)) {
        worksite = await _worksiteCache.store(worksite.id, worksite);
      } else {
        worksite = await updateWorksite(worksite);
      }
    }
    return worksite;
  }

  Future<(List<String>, List<String>)> _removeChecklist(
      Checklist checklist) async {
    List<String> itemIds = [];
    List<String> checklistDayIds = checklist.checklistIdsByDate.values.toList();
    for (String checklistDay in checklistDayIds) {
      itemIds.addAll(await _removeChecklistDay(
          (await _checklistDayCache.getById(checklistDay))!));
    }
    await _checklistCache.delete(checklist.id);
    return (checklistDayIds, itemIds);
  }

  Future<ChecklistDay> createChecklistDay(
      Checklist checklist, ChecklistDay? checklistDay, DateTime date) async {
    String tempId = ID_DefaultBlankChecklistDayID;
    ChecklistDay newChecklistDay = ChecklistDay(
        id: tempId,
        checklistId: checklistDay?.checklistId ?? checklist.id,
        date: date,
        dateCreated: DateTime.now().toUtc(),
        dateUpdated: DateTime.now().toUtc());
    //copy items from the previous day
    for (String category in checklistDay?.itemsByCatagory.keys ?? <String>[]) {
      for (String itemid
          in checklistDay?.itemsByCatagory[category] ?? <String>[]) {
        newChecklistDay.addItemId(category, itemid);
      }
    }
    checklist.addChecklistDay(newChecklistDay, null, null);
    checklist = await _checklistCache.store(checklist.id, checklist);
    return await _checklistDayCache.store(tempId, newChecklistDay);
  }

  Future<ChecklistDay> GetChecklistDayByDate(
      DateTime date, Checklist checklist) async {
    bool exists = false;
    String? id = "";
    (exists, id) = checklist.getChecklistDayID(date);
    if (exists) {
      return (await _checklistDayCache.getById(id!))!;
    } else {
      //if the checklist day does not exist, create it
      if (checklist.id.startsWith(ID_TempIDPrefix)) {
        return await createChecklistDay(checklist, null, date);
      }
      //copy from an existing day, and give it the temp ID. This will be updated later.
      else {
        return await createChecklistDay(
            checklist,
            (await _checklistDayCache
                .getById(checklist.checklistIdsByDate.values.last))!,
            date);
      }
    }
  }

  Future<ChecklistDay> updateChecklistDay(
      ChecklistDay checklistDay, DateTime date) async {
    if (checklistDay.id.startsWith(ID_TempIDPrefix)) {
      if (checklistDay.date != date) {
        checklistDay.date = date;
      }

      Checklist checklist =
          (await _checklistCache.getById(checklistDay.checklistId))!;

      //ensure checklist exists
      if (checklistDay.checklistId.startsWith(ID_TempIDPrefix)) {
        checklist = await updateChecklist(checklist);
        checklistDay.checklistId = checklist.id;
      }
      try {
        //update checklist day
        ChecklistDay updatedChecklistDay = _checklistDayFactory.fromJson(
            jsonDecode(await _checklistDayDataConnectionService.post(
                API_ChecklistDayPath, checklistDay)));

        //update items with new parent checklistDay ID
        checklistDay.itemsByCatagory.values
            .expand((i) => i)
            .where((id) => id.startsWith(ID_TempIDPrefix))
            .forEach((id) async {
          //Assumption here. The only items we should be updating here are temporary items, thus stored in the cache or file.
          //If they were real items, then this checklist day would have been updated already. Thus, we can assume that the checklist is only local.
          Item item = (await _itemCache.getById(id))!;
          item.checklistDayId = updatedChecklistDay.id;
          await _itemCache.store(item.id, item);
        });

        //update parent checklist with new checklistDay ID
        checklist.addChecklistDay(updatedChecklistDay, null, null);
        checklist = await updateChecklist(checklist);

        //update checklist Day
        checklistDay = await _checklistDayCache.store(
            checklistDay.id, updatedChecklistDay); //replace the temp version
      } on HttpException catch (e) {
        switch (e.response) {
          default:
            //change the id to a temp one so we can store it locally
            String tempId =
                "${ID_TempIDPrefix}${ID_ChecklistDayPrefix}${DateTime.now().millisecondsSinceEpoch.toString()}";
            checklistDay.id = tempId;
            checklist.addChecklistDay(checklistDay, null, null);
            checklist = await updateChecklist(checklist);
            checklistDay =
                await _checklistDayCache.store(checklistDay.id, checklistDay);
        }
      } finally {
        _checklistDayFileIOService
            .saveDataFile(API_ChecklistDayPath, [checklistDay]);
      }
    } else if (checklistDay.getChecksum() !=
        (await _checklistCache.getById(checklistDay.id))!.getChecksum()) {
      try {
        checklistDay = await _checklistDayCache.store(
            checklistDay.id,
            _checklistDayFactory.fromJson(jsonDecode(
                await _checklistDayDataConnectionService.put(
                    API_ChecklistDayPath, checklistDay))));
      } on HttpException catch (e) {
        switch (e.response) {
          default:
            break;
        }
      } finally {
        _checklistDayFileIOService
            .saveDataFile(API_ChecklistDayPath, [checklistDay]);
      }
    }
    return checklistDay;
  }

  Future<List<String>> _removeChecklistDay(ChecklistDay checklistDay) async {
    List<String> itemIds =
        checklistDay.itemsByCatagory.values.expand((i) => i).toList();
    for (String item in itemIds) {
      await _removeItem(item);
    }
    await _checklistDayCache.delete(checklistDay.id);
    return itemIds;
  }

  Future<Item?> getItemById(String id) async {
    return await _itemCache.getById(id);
  }

  //Note. This doesnt distirnguish between foreman or project managers currently. This is a temp implementation.
  Future<Item> createItemFromItem(Item item) async {
    String tempId =
        "${ID_TempIDPrefix}${ID_ItemPrefix}${DateTime.now().millisecondsSinceEpoch.toString()}";
    return Item(
        id: tempId,
        checklistDayId: item.checklistDayId,
        dateCreated: DateTime.now().toUtc(),
        dateUpdated: DateTime.now().toUtc(),
        unit: item.unit,
        desc: item.desc,
        result: item.result,
        comment: item.comment,
        creatorId: item.creatorId,
        verified: item.verified);
  }

  Future<Item> createItem(ChecklistDay checklistDay, String category) async {
    String tempId =
        "${ID_TempIDPrefix}${ID_ItemPrefix}${DateTime.now().millisecondsSinceEpoch.toString()}";
    Item item = Item(
        id: tempId,
        checklistDayId: checklistDay.checklistId,
        dateCreated: DateTime.now().toUtc(),
        dateUpdated: DateTime.now().toUtc(),
        unit: "",
        desc: "",
        result: "",
        comment: "",
        creatorId: "",
        verified: false);
    checklistDay.addItem(category, item);
    checklistDay =
        await _checklistDayCache.store(checklistDay.id, checklistDay);
    return await _itemCache.store(tempId, item);
  }

  Future<Item> updateItem(
      Item item, ChecklistDay checklistDay, DateTime date) async {
    String itemCategory = checklistDay.getCategoryForItem(item);

    if (checklistDay.id != item.checklistDayId) {
      checklistDay.removeItem(itemCategory, item);
      item = await createItemFromItem(item);
      checklistDay.addItem(itemCategory, item);
      item.checklistDayId = checklistDay.id;
    }
    if (item.id.startsWith(ID_TempIDPrefix)) {
      if ((item.desc?.isNotEmpty ?? false) &&
          (item.unit?.isNotEmpty ?? false)) {
        //ensure checklist day exists
        if (checklistDay.id.startsWith(ID_TempIDPrefix)) {
          checklistDay = await updateChecklistDay(checklistDay, date);
          item.checklistDayId = checklistDay.id;
        }

        try {
          //update Item
          Item updatedItem = _itemFactory.fromJson(jsonDecode(
              await _itemDataConnectionService.post(API_ItemPath, item)));

          //update parent checklistDay with new item ID
          checklistDay.removeItem(itemCategory, item);
          checklistDay.addItem(itemCategory, updatedItem);
          checklistDay = await updateChecklistDay(checklistDay, date);

          //update item
          item = await _itemCache.store(
              item.id, updatedItem); //replace the temp version
        } on HttpException catch (e) {
          switch (e.response) {
            default:
              break;
          }
        } finally {
          _itemFileIOService.saveDataFile(Dir_ItemFileString, [item]);
        }
      }
    } else if (item.getChecksum() !=
        (await _itemCache.getById(item.id))!.getChecksum()) {
      try {
        item = await _itemCache.store(
            item.id,
            _itemFactory.fromJson(jsonDecode(
                await _itemDataConnectionService.put(API_ItemPath, item))));
      } on HttpException catch (e) {
        switch (e.response) {
          default:
            break;
        }
      } finally {
        _itemFileIOService.saveDataFile(Dir_ItemFileString, [item]);
      }
    }
    return item;
  }

  Future<ChecklistDay> deleteItem(ChecklistDay checklistDay, Item item) async {
    try {
      if (item.checklistDayId == checklistDay.id) {
        if (!item.id.startsWith(ID_TempIDPrefix)) {
          await _itemDataConnectionService.delete(API_ItemPath, [item.id]);
        }
        await _removeItem(item.id);
        await _itemFileIOService
            .deleteFromDataFile(Dir_ItemFileString, [item.id]);
      }
    } on HttpException catch (e) {
      switch (e.response) {
        default:
          item.flagForDeletion = true;
          await _itemCache.store(item.id, item);
          await _itemFileIOService
              .saveDataFile(Dir_ChecklistFileString, [item]);
      }
    } finally {
      checklistDay.removeItem(checklistDay.getCategoryForItem(item), item);
      if (checklistDay.id.startsWith(ID_TempIDPrefix)) {
        checklistDay =
            await _checklistDayCache.store(checklistDay.id, checklistDay);
      } else {
        checklistDay =
            await updateChecklistDay(checklistDay, checklistDay.date);
      }
    }
    return checklistDay;
  }

  Future<void> _removeItem(String id) async {
    _itemCache.delete(id);
  }

  Future<void> addCategory(ChecklistDay checklistDay, String category) async {
    checklistDay.addCategory(category);
    await _checklistDayCache.store(checklistDay.id, checklistDay);
  }

  Future<void> editCategory(ChecklistDay checklistDay, DateTime date,
      String oldCategory, String newCategory) async {
    if (!checklistDay.itemsByCatagory.containsKey(newCategory)) {
      checklistDay.addCategory(newCategory);
    }
    checklistDay.getItemsByCategory(oldCategory).forEach((item) {
      checklistDay.itemsByCatagory[newCategory]!.add(item.id);
    });
    checklistDay.removeCategory(oldCategory);
    if (checklistDay.id.startsWith(ID_TempIDPrefix)) {
      await _checklistDayCache.store(checklistDay.id, checklistDay);
    } else {
      await updateChecklistDay(checklistDay, date);
    }
  }

  Future<void> removeCategory(
      ChecklistDay checklistDay, DateTime date, String category) async {
    checklistDay.removeCategory(category);
    if (checklistDay.id.startsWith(ID_TempIDPrefix)) {
      await _checklistDayCache.store(checklistDay.id, checklistDay);
    } else {
      await updateChecklistDay(checklistDay, date);
    }
  }
}