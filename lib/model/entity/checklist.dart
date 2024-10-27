import 'dart:collection';

import 'package:build_stats_flutter/model/Domain/Interface/cachable.dart';
import 'package:build_stats_flutter/model/entity/item.dart';
import 'package:build_stats_flutter/resources/app_strings.dart';

class Checklist {
  String id;
  String worksiteId;
  String? name;
  late HashMap<String, String> _checklistIdsByDate;

  Checklist({required this.id, required this.worksiteId, this.name}) {
    _checklistIdsByDate = HashMap<String, String>();
  }

  HashMap<String, String> TESTING_GetChecklistIdsByDate() {
    return _checklistIdsByDate;
  }

  addChecklistDay(ChecklistDay day) {
    _checklistIdsByDate[day.date.toIso8601String()] = day.id;
  }

  (bool, String?) getChecklistDayID(DateTime date) {
    if (_checklistIdsByDate.isEmpty) {
      return (false, DefaultBlankChecklistDayID);
    } else if (_checklistIdsByDate.containsKey(date.toIso8601String())) {
      return (true, _checklistIdsByDate[date.toIso8601String()]);
    } else {
      List<String> keys = _checklistIdsByDate.keys.toList();
      keys.sort();
      for (String key in keys.reversed) {
        if (DateTime.parse(key).isBefore(date)) {
          return (false, _checklistIdsByDate[key]);
        }
      }
      return (false, _checklistIdsByDate[keys.last]);
    }
  }
}

class ChecklistDay extends Cacheable {
  String checklistId;
  DateTime date;
  String? comment;
  late HashMap<String, List<String>> itemsByCatagory;
  DateTime dateCreated;
  DateTime dateUpdated;

  ChecklistDay(
      {required super.id,
      required this.checklistId,
      required this.date,
      this.comment,
      required this.dateCreated,
      required this.dateUpdated});

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
      date: DateTime.parse(json['date'] ?? FallbackDate),
      comment: json['comment'],
      dateCreated: DateTime.parse(json['dateCreated'] ?? FallbackDate),
      dateUpdated: DateTime.parse(json['dateUpdated'] ?? FallbackDate),
    );
    result.itemsByCatagory = HashMap<String, List<String>>.from(
        json['itemsByCatagory'] ?? <String, List<String>>{});

    return result;
  }
}
