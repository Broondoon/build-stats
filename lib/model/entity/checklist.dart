import 'dart:collection';

import 'package:build_stats_flutter/model/Domain/Interface/cachable.dart';
import 'package:build_stats_flutter/model/entity/item.dart';
import 'package:build_stats_flutter/resources/app_strings.dart';
import 'package:meta/meta.dart';

class Checklist extends Cacheable {
  String worksiteId;
  String? name;
  DateTime dateCreated;
  DateTime dateUpdated;
  late HashMap<String, String> _checklistIdsByDate;
  @visibleForTesting
  HashMap<String, String> get checklistIdsByDate => _checklistIdsByDate;

  Checklist(
      {required super.id,
      required this.worksiteId,
      this.name,
      required this.dateCreated,
      required this.dateUpdated}) {
    _checklistIdsByDate = HashMap<String, String>();
  }
  addChecklistDay(ChecklistDay? day, DateTime? date, String? id) {
    if (day == null && date == null && id == null) {
      throw Exception('All arguments cannot be null');
    }
    _checklistIdsByDate[(day?.date ?? date)!.toIso8601String()] =
        (day?.id ?? id)!;
  }

  (bool, String?) getChecklistDayID(DateTime date) {
    if (_checklistIdsByDate.isEmpty) {
      return (false, ID_DefaultBlankChecklistDayID);
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

  @override
  toJson() {
    return {
      'id': id,
      'worksiteId': worksiteId,
      'name': name,
      'checklistIdsByDate': _checklistIdsByDate.toString(),
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
      _checklistIdsByDate.entries
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
      date: DateTime.parse(json['date'] ?? Default_FallbackDate),
      comment: json['comment'],
      dateCreated: DateTime.parse(json['dateCreated'] ?? Default_FallbackDate),
      dateUpdated: DateTime.parse(json['dateUpdated'] ?? Default_FallbackDate),
    );
    result.itemsByCatagory = HashMap<String, List<String>>.from(
        json['itemsByCatagory'] ?? <String, List<String>>{});

    return result;
  }
}
