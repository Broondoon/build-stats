import 'dart:collection';

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

class ChecklistDay {
  String id;
  String checklistId;
  DateTime date;
  String? comment;
  late HashMap<String, List<String>> itemsByCatagory;
  DateTime dateCreated;
  DateTime dateUpdated;

  ChecklistDay(
      {required this.id,
      required this.checklistId,
      required this.date,
      this.comment,
      required this.dateCreated,
      required this.dateUpdated});

  factory ChecklistDay.fromJson(Map<String, dynamic> json) {
    return ChecklistDay(
      id: json['id'],
      checklistId: json['checklistId'],
      date: DateTime.parse(json['date'] ?? FallbackDate),
      comment: json['comment'],
      itemsByCatagory: HashMap<String, List<String>>.from(
          json['itemsByCatagory'] ?? <String, List<String>>{}),
      dateCreated: DateTime.parse(json['dateCreated'] ?? FallbackDate),
      dateUpdated: DateTime.parse(json['dateUpdated'] ?? FallbackDate),
    );
  }

  toJson() {
    return {
      'id': id,
      'checklistId': checklistId,
      'date': date?.toIso8601String(),
      'comment': comment,
      'itemsByCatagory': itemsByCatagory.toString(),
      'dateCreated': dateCreated?.toIso8601String(),
      'dateUpdated': dateUpdated?.toIso8601String(),
    };
  }

  getChecksum() {
    throw UnimplementedError();
  }
}
