import 'dart:collection';
import 'dart:convert';

import 'package:shared/app_strings.dart';
import 'package:shared/src/base_entities/entity/entity.dart';
import 'package:shared/src/base_entities/item/item.dart';

class BaseChecklist extends Entity {
  late String worksiteId;
  late String? name;
  late HashMap<String, String> checklistIdsByDate;

  BaseChecklist({
    required super.id,
    required this.worksiteId,
    this.name,
    required super.dateCreated,
    required super.dateUpdated,
    super.flagForDeletion = false,
  }) {
    name ??= '';
    checklistIdsByDate = HashMap<String, String>();
  }

  BaseChecklist.fromBaseChecklist({required BaseChecklist checklist})
      : super(
          id: checklist.id,
          dateCreated: checklist.dateCreated,
          dateUpdated: checklist.dateUpdated,
          flagForDeletion: checklist.flagForDeletion,
        ) {
    worksiteId = checklist.worksiteId;
    name = checklist.name;
    checklistIdsByDate = checklist.checklistIdsByDate;
  }

  addChecklistDay(BaseChecklistDay? day, DateTime? date, String? id) {
    if (day == null && date == null && id == null) {
      throw Exception('All arguments cannot be null');
    }
    DateTime dateUtc = day?.date.toUtc() ?? date!.toUtc();
    String dateKey =
        '${dateUtc.year}-${dateUtc.month.toString().padLeft(2, '0')}-${dateUtc.day.toString().padLeft(2, '0')}';
    checklistIdsByDate[dateKey] = (day?.id ?? id)!;
  }

  removeChecklistDay(BaseChecklistDay checklistDay) {
    DateTime dateUtc = checklistDay.date.toUtc();
    String dateKey =
        '${dateUtc.year}-${dateUtc.month.toString().padLeft(2, '0')}-${dateUtc.day.toString().padLeft(2, '0')}';
    if (checklistIdsByDate.containsKey(dateKey)) {
      checklistIdsByDate.remove(dateKey);
    }
  }

  @override
  toJson() {
    return {
      'id': id,
      'worksiteId': worksiteId,
      'name': name,
      'checklistIdsByDate': checklistIdsByDate,
      'dateCreated': dateCreated.toUtc().toIso8601String(),
      'dateUpdated': dateUpdated.toUtc().toIso8601String(),
      'flagForDeletion': flagForDeletion.toString(),
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
          .map((e) => MapEntry(e.key, e.value))),
      'dateCreated': dateCreated.toUtc().toIso8601String(),
      'dateUpdated': dateUpdated.toUtc().toIso8601String(),
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
      dateCreated.toUtc().toIso8601String(),
      dateUpdated.toUtc().toIso8601String(),
    ].join('|');
  }
}

class BaseChecklistFactory<T extends BaseChecklist> extends EntityFactory<T> {
  @override
  BaseChecklist fromJson(Map<String, dynamic> json) {
    BaseChecklist result = BaseChecklist(
      id: json['id'],
      worksiteId: json['worksiteId'],
      name: json['name'],
      dateCreated: DateTime.parse(json['dateCreated'] ?? Default_FallbackDate),
      dateUpdated: DateTime.parse(json['dateUpdated'] ?? Default_FallbackDate),
      flagForDeletion: json['flagForDeletion'] == "true",
    );

    result.checklistIdsByDate = HashMap<String, String>.from(
        json['checklistIdsByDate'] ?? <String, String>{});

    return result;
  }
}

class BaseChecklistDay extends Entity {
  late String checklistId;
  late DateTime date;
  late String? comment;
  late HashMap<String, List<String>> itemsByCatagory;

  BaseChecklistDay({
    required super.id,
    required this.checklistId,
    required this.date,
    this.comment,
    required super.dateCreated,
    required super.dateUpdated,
    super.flagForDeletion = false,
  }) {
    itemsByCatagory = HashMap<String, List<String>>();
  }

  BaseChecklistDay.fromBaseChecklistDay(
      {required BaseChecklistDay checklistDay})
      : super(
          id: checklistDay.id,
          dateCreated: checklistDay.dateCreated,
          dateUpdated: checklistDay.dateUpdated,
          flagForDeletion: checklistDay.flagForDeletion,
        ) {
    checklistId = checklistDay.checklistId;
    date = checklistDay.date;
    comment = checklistDay.comment;
    itemsByCatagory = checklistDay.itemsByCatagory;
  }

  getCategories() {
    return itemsByCatagory.keys.toList();
  }

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

  addItem(String category, BaseItem item) {
    addItemId(category, item.id);
  }

  removeItem(String category, BaseItem item) {
    if (itemsByCatagory.containsKey(category)) {
      itemsByCatagory[category]!.remove(item.id);
    }
  }

  getItemsByCategory(String category) {
    return itemsByCatagory[category] ?? [];
  }

  getCategoryForItem(BaseItem item) {
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
      'date': date.toUtc().toIso8601String(),
      'comment': comment,
      'itemsByCatagory': itemsByCatagory,
      'dateCreated': dateCreated.toUtc().toIso8601String(),
      'dateUpdated': dateUpdated.toUtc().toIso8601String(),
      'flagForDeletion': flagForDeletion.toString(),
    };
  }

  @override
  toJsonTransfer() {
    return {
      'id': id,
      'checklistId': checklistId,
      'date': date.toUtc().toIso8601String(),
      'comment': comment,
      'itemsByCatagory': HashMap.fromEntries(itemsByCatagory.entries.map((e) =>
          MapEntry(e.key,
              e.value.where((x) => !x.startsWith(ID_TempIDPrefix)).toList()))),
      'dateCreated': dateCreated.toUtc().toIso8601String(),
      'dateUpdated': dateUpdated.toUtc().toIso8601String(),
    };
  }

  @override
  joinData() {
    return [
      id,
      checklistId,
      date.toUtc().toIso8601String(),
      comment ?? '',
      itemsByCatagory.entries
          .map((e) =>
              '${e.key},${e.value.where((element) => !element.startsWith(ID_TempIDPrefix)).join(',')}')
          .join('|'),
      dateCreated.toUtc().toIso8601String(),
      dateUpdated.toUtc().toIso8601String(),
    ].join('|');
  }
}

class BaseChecklistDayFactory<T extends BaseChecklistDay>
    extends EntityFactory<T> {
  @override
  BaseChecklistDay fromJson(Map<String, dynamic> json) {
    BaseChecklistDay result = BaseChecklistDay(
      id: json['id'],
      checklistId: json['checklistId'],
      date: DateTime.parse(json['date'] ?? Default_FallbackDate),
      comment: json['comment'],
      dateCreated: DateTime.parse(json['dateCreated'] ?? Default_FallbackDate),
      dateUpdated: DateTime.parse(json['dateUpdated'] ?? Default_FallbackDate),
      flagForDeletion: json['flagForDeletion'] == "true",
    );

    Map<String, dynamic> itemsByCatagory = json['itemsByCatagory'] ?? {};
    for (MapEntry<String, dynamic> entry in itemsByCatagory.entries) {
      result.itemsByCatagory[entry.key] = List<String>.from(entry.value);
    }

    // result.itemsByCatagory = HashMap<String, List<String>>.from(
    //     json['itemsByCatagory'] as Map<String, List<String>>? ??
    //         <String, List<String>>{});
    //jsonDecode(json['itemsByCatagory']) ?? <String, List<String>>{});

    return result;
  }
}
