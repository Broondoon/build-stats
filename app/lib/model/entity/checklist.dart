import 'dart:collection';

import 'package:build_stats_flutter/model/entity/cachable.dart';
import 'package:build_stats_flutter/model/entity/item.dart';
import 'package:shared/app_strings.dart';

class Checklist extends Cacheable {
  String worksiteId;
  String? name;
  late HashMap<String, String> checklistIdsByDate;

  Checklist({
    required super.id,
    required this.worksiteId,
    this.name,
    required super.dateCreated,
    required super.dateUpdated,
    super.flagForDeletion = false,
  }) {
    checklistIdsByDate = HashMap<String, String>();
  }
  addChecklistDay(ChecklistDay? day, DateTime? date, String? id) {
    if (day == null && date == null && id == null) {
      throw Exception('All arguments cannot be null');
    }
    checklistIdsByDate[(day?.date ?? date)!.toIso8601String()] =
        (day?.id ?? id)!;
  }

  removeChecklistDay(ChecklistDay checklistDay) {
    if (checklistIdsByDate.containsKey(checklistDay.date.toIso8601String())) {
      checklistIdsByDate.remove(checklistDay.date.toIso8601String());
    }
  }

  (bool, String?) getChecklistDayID(DateTime date) {
    if (checklistIdsByDate.isEmpty) {
      return (false, ID_DefaultBlankChecklistDayID);
    } else if (checklistIdsByDate.containsKey(date.toIso8601String())) {
      return (true, checklistIdsByDate[date.toIso8601String()]);
    } else {
      List<String> keys = checklistIdsByDate.keys.toList();
      keys.sort();
      for (String key in keys.reversed) {
        if (DateTime.parse(key).isBefore(date)) {
          return (
            checklistIdsByDate[key] == ID_DefaultBlankChecklistDayID,
            checklistIdsByDate[key]
          );
        }
      }
      return (
        checklistIdsByDate[keys.last] == ID_DefaultBlankChecklistDayID,
        checklistIdsByDate[keys.last]
      );
    }
  }

  @override
  toJson() {
    return {
      'id': id,
      'worksiteId': worksiteId,
      'name': name,
      'checklistIdsByDate': checklistIdsByDate.toString(),
      'dateCreated': dateCreated.toIso8601String(),
      'dateUpdated': dateUpdated.toIso8601String(),
      'flagForDeletion': flagForDeletion,
    };
  }

  @override
  toJsonTransfer() {
    return {
      'id': id,
      'worksiteId': worksiteId,
      'name': name,
      'checklistIdsByDate': HashMap.fromEntries(checklistIdsByDate.entries
          .where((e) => !e.value.startsWith(ID_TempIDPrefix))
          .map((e) => MapEntry(e.key, e.value))).toString(),
      'dateCreated': dateCreated.toIso8601String(),
      'dateUpdated': dateUpdated.toIso8601String(),
    };
  }

  @override
  joinData() {
    return [
      id,
      worksiteId,
      name ?? '',
      checklistIdsByDate.entries
          .where((e) => !e.value.startsWith(ID_TempIDPrefix))
          .map((e) => '${e.key},${e.value}')
          .join('|'),
      dateCreated.toIso8601String(),
      dateUpdated.toIso8601String(),
    ].join('|');
  }
}

class ChecklistFactory extends CacheableFactory<Checklist> {
  @override
  Checklist fromJson(Map<String, dynamic> json) {
    Checklist result = Checklist(
      id: json['id'],
      worksiteId: json['worksiteId'],
      name: json['name'],
      dateCreated: DateTime.parse(json['dateCreated'] ?? Default_FallbackDate),
      dateUpdated: DateTime.parse(json['dateUpdated'] ?? Default_FallbackDate),
      flagForDeletion: json['flagForDeletion'] ?? false,
    );
    for (String key in json['checklistIdsByDate'].keys) {
      result.addChecklistDay(
          null, DateTime.parse(key), json['checklistIdsByDate'][key]);
    }
    return result;
  }
}

class ChecklistDay extends Cacheable {
  String checklistId;
  DateTime date;
  String? comment;
  late HashMap<String, List<String>> itemsByCatagory;

  ChecklistDay({
    required super.id,
    required this.checklistId,
    required this.date,
    this.comment,
    required super.dateCreated,
    required super.dateUpdated,
    super.flagForDeletion = false,
  });

  addCategory(String category) {
    itemsByCatagory[category] = [];
  }

  removeCategory(String category) {
    if (itemsByCatagory.containsKey(category) &&
        itemsByCatagory[category]!.isNotEmpty) {
      throw Exception('Category $category is not empty');
    }
    itemsByCatagory.remove(category);
  }

  addItemId(String category, String itemId) {
    if (itemsByCatagory.containsKey(category)) {
      itemsByCatagory[category]!.add(itemId);
    } else {
      itemsByCatagory[category] = [itemId];
    }
  }

  addItem(String category, Item item) {
    addItemId(category, item.id);
  }

  removeItem(String category, Item item) {
    if (itemsByCatagory.containsKey(category)) {
      itemsByCatagory[category]!.remove(item.id);
    }
  }

  getItemsByCategory(String category) {
    return itemsByCatagory[category] ?? [];
  }

  getCategoryForItem(Item item) {
    for (String key in itemsByCatagory.keys) {
      if (itemsByCatagory[key]!.contains(item.id)) {
        return key;
      }
    }
    return null;
  }

  @override
  toJson() {
    return {
      'id': id,
      'checklistId': checklistId,
      'date': date.toIso8601String(),
      'comment': comment,
      'itemsByCatagory': itemsByCatagory.toString(),
      'dateCreated': dateCreated.toIso8601String(),
      'dateUpdated': dateUpdated.toIso8601String(),
      'flagForDeletion': flagForDeletion,
    };
  }

  @override
  toJsonTransfer() {
    return {
      'id': id,
      'checklistId': checklistId,
      'date': date.toIso8601String(),
      'comment': comment,
      'itemsByCatagory': HashMap.fromEntries(itemsByCatagory.entries.map((e) =>
          MapEntry(
              e.key,
              e.value
                  .where((x) => !x.startsWith(ID_TempIDPrefix))
                  .toList()))).toString(),
      'dateCreated': dateCreated.toIso8601String(),
      'dateUpdated': dateUpdated.toIso8601String(),
    };
  }

  @override
  joinData() {
    return [
      id,
      checklistId,
      date.toIso8601String(),
      comment ?? '',
      itemsByCatagory.entries
          .map((e) =>
              '${e.key},${e.value.where((element) => !element.startsWith(ID_TempIDPrefix)).join(',')}')
          .join('|'),
      dateCreated.toIso8601String(),
      dateUpdated.toIso8601String(),
    ].join('|');
  }
}

class ChecklistDayFactory extends CacheableFactory<ChecklistDay> {
  @override
  ChecklistDay fromJson(Map<String, dynamic> json) {
    ChecklistDay result = ChecklistDay(
      id: json['id'],
      checklistId: json['checklistId'],
      date: DateTime.parse(json['date'] ?? Default_FallbackDate),
      comment: json['comment'],
      dateCreated: DateTime.parse(json['dateCreated'] ?? Default_FallbackDate),
      dateUpdated: DateTime.parse(json['dateUpdated'] ?? Default_FallbackDate),
      flagForDeletion: json['flagForDeletion'] ?? false,
    );
    result.itemsByCatagory = HashMap<String, List<String>>.from(
        json['itemsByCatagory'] ?? <String, List<String>>{});

    return result;
  }
}
