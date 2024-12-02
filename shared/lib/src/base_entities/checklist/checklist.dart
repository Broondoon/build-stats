import 'dart:collection';
import 'dart:convert';

import 'package:shared/app_strings.dart';
import 'package:shared/src/base_entities/entity/entity.dart';
import 'package:shared/src/base_entities/item/item.dart';

class BaseChecklist extends Entity {
  late String worksiteId;
  late HashMap<String, String> checklistIdsByDate;

  BaseChecklist({
    required super.id,
    super.name,
    required this.worksiteId,
    required super.dateCreated,
    required super.dateUpdated,
    super.flagForDeletion = false,
  }) {
    checklistIdsByDate = HashMap<String, String>();
  }

  BaseChecklist.fromBaseChecklist({required BaseChecklist checklist}) : this.fromEntity(entity: checklist, worksiteId: checklist.worksiteId, checklistIdsByDate: checklist.checklistIdsByDate);

  BaseChecklist.fromEntity({required super.entity, required this.worksiteId, required this.checklistIdsByDate})
      : super.fromEntity();

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
    Map<String, dynamic> map = super.toJson() as Map<String, dynamic>;
    map['worksiteId'] = worksiteId;
    map['checklistIdsByDate'] = checklistIdsByDate;
    return map;
  }

  @override
  toJsonTransfer() {
    Map<String, dynamic> map = super.toJsonTransfer() as Map<String, dynamic>;
    map['worksiteId'] = worksiteId;
    map['checklistIdsByDate'] = HashMap.fromEntries(checklistIdsByDate.entries
        .where((e) => !e.value.startsWith(ID_TempIDPrefix))
        .map((e) => MapEntry(e.key, e.value)));
    return map;
  }

  @override
  joinData() {
        return super.joinData() + '|' + ([
      worksiteId,
      checklistIdsByDate.entries
          .where((e) => !e.value.startsWith(ID_TempIDPrefix))
          .map((e) => '${e.key},${e.value}')
          .join('|'),
    ].join('|'));
  }
}

class BaseChecklistFactory<T extends BaseChecklist> extends EntityFactory<T> {
  @override
  BaseChecklist fromJson(Map<String, dynamic> json) {
    BaseChecklist result = BaseChecklist.fromEntity(
      entity: super.fromJson(json),
      worksiteId: json['worksiteId'],
      checklistIdsByDate: HashMap<String, String>.from(
        json['checklistIdsByDate'] ?? <String, String>{})
    );
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
    super.name,
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
      {required BaseChecklistDay checklistDay}) : this.fromEntity(entity: checklistDay, checklistId: checklistDay.checklistId, date: checklistDay.date, comment: checklistDay.comment, itemsByCatagory: checklistDay.itemsByCatagory);

  BaseChecklistDay.fromEntity({required super.entity, required this.checklistId, required this.date, this.comment, required this.itemsByCatagory})
      : super.fromEntity();

  getCategories() {
    return itemsByCatagory.keys.toList();
  }

  addCategory(String category) {
    itemsByCatagory[category] = List<String>.empty(growable: true);
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
      else if(itemsByCatagory[key]!.contains(ID_TempIDPrefix + item.id)){
        return key;
      }
    }
    return "";
  }

  @override
  toJson() {
        Map<String, dynamic> map = super.toJson() as Map<String, dynamic>;
    map['checklistId'] = checklistId;
    map['date'] = date.toUtc().toIso8601String();
    map['comment'] = comment;
    map['itemsByCatagory'] = itemsByCatagory;
    return map;
  }

  @override
  toJsonTransfer() {
    Map<String, dynamic> map = super.toJsonTransfer() as Map<String, dynamic>;
    map['checklistId'] = checklistId;
    map['date'] = date.toUtc().toIso8601String();
    map['comment'] = comment;
    map['itemsByCatagory'] = HashMap.fromEntries(itemsByCatagory.entries.map((e) =>
        MapEntry(e.key,
            e.value.where((x) => !x.startsWith(ID_TempIDPrefix)).toList())));
    return map;
  }

  @override
  joinData() {
    return super.joinData() + '|' + ([
      checklistId,
      date.toUtc().toIso8601String(),
      comment ?? '',
      itemsByCatagory.entries
          .map((e) =>
              '${e.key},${e.value.where((element) => !element.startsWith(ID_TempIDPrefix)).join(',')}')
          .join('|'),
    ].join('|'));
  }
}

class BaseChecklistDayFactory<T extends BaseChecklistDay>
    extends EntityFactory<T> {
  @override
  BaseChecklistDay fromJson(Map<String, dynamic> json) {
    BaseChecklistDay result = BaseChecklistDay.fromEntity(
      entity: super.fromJson(json),
      checklistId: json['checklistId'],
      date: DateTime.parse(json['date'] ?? Default_FallbackDate),
      comment: json['comment'],
      itemsByCatagory: HashMap<String, List<String>>()
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
