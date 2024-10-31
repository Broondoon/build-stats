import 'dart:collection';

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
    DateTime dateKey = day?.date ?? date!;
    checklistIdsByDate['${dateKey.year}-${dateKey.month}-${dateKey.day}'] =
        (day?.id ?? id)!;
  }

  removeChecklistDay(BaseChecklistDay checklistDay) {
    if (checklistIdsByDate.containsKey(checklistDay.date.toIso8601String())) {
      checklistIdsByDate.remove(checklistDay.date.toIso8601String());
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

class BaseChecklistFactory<T extends BaseChecklist> extends EntityFactory<T> {
  @override
  BaseChecklist fromJson(Map<String, dynamic> json) {
    BaseChecklist result = BaseChecklist(
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
  });

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
      flagForDeletion: json['flagForDeletion'] ?? false,
    );
    result.itemsByCatagory = HashMap<String, List<String>>.from(
        json['itemsByCatagory'] ?? <String, List<String>>{});

    return result;
  }
}
