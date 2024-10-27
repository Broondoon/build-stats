import 'dart:collection';

import 'package:build_stats_flutter/model/Domain/Interface/cachable.dart';
import 'package:build_stats_flutter/model/entity/checklist.dart';
import 'package:build_stats_flutter/resources/app_strings.dart';

//see if we can use this to update IDs and such?
//https://api.flutter.dev/flutter/foundation/ValueNotifier-class.html
class Worksite implements Cacheable {
  String id;
  String? ownerId;
  List<String>? checklistIds;
  DateTime dateCreated;
  DateTime dateUpdated;
  Checklist? currentChecklist;

  Worksite({
    required this.id,
    this.ownerId,
    this.checklistIds,
    required this.dateCreated,
    required this.dateUpdated,
    this.currentChecklist, //only for temporary use
  });

  @override
  toJson() {
    return {
      'id': id,
      'ownerId': ownerId,
      'checklistIds': checklistIds,
      'tempChecklistDayIds':
          currentChecklist?.TESTING_GetChecklistIdsByDate.toString(),
    };
  }

  @override
  getChecksum() {
    throw UnimplementedError();
  }
}

class WorksiteFactory extends CacheableFactory<Worksite> {
  @override
  Worksite fromJson(Map<String, dynamic> json) {
    String TEMP_firstChecklistDayId = "temp" + json['id'];
    Worksite worksite = Worksite(
      id: json['id'],
      ownerId: json['ownerId'],
      checklistIds: List<String>.from(json['checklistIds'] ?? <String>[]),
      dateCreated: DateTime.parse(json['dateCreated'] ?? FallbackDate),
      dateUpdated: DateTime.parse(json['dateUpdated'] ?? FallbackDate),
      //for dev only
      currentChecklist:
          Checklist(id: TEMP_firstChecklistDayId, worksiteId: json['id']),
    );

    //FOR DEV ONLY. We're cheating here so we don't have to setup multple checklist funcitonality just yet.
    HashMap<String, String> temp = HashMap<String, String>.from(
        json['tempChecklistDayIds'] ?? <String, String>{});
    for (String key in temp.keys) {
      worksite.currentChecklist?.addChecklistDay(ChecklistDay(
          id: temp[key]!,
          date: DateTime.parse(key),
          checklistId: TEMP_firstChecklistDayId,
          dateCreated: DateTime.now(),
          dateUpdated: DateTime.now()));
    }
    return worksite;
  }
}
