import 'package:build_stats_flutter/model/storage/checklist_cache.dart';
import 'package:shared/checklist.dart';
import 'package:shared/app_strings.dart';

class Checklist extends BaseChecklist {
  Checklist({
    required super.id,
    required super.worksiteId,
    super.name,
    required super.dateCreated,
    required super.dateUpdated,
    super.flagForDeletion = false,
  });

  Checklist.fromBaseChecklist({required super.checklist})
      : super.fromBaseChecklist();

  (bool, String?) getChecklistDayID(DateTime date) {
    String dateKey =
        '${date.toUtc().year}-${date.toUtc().month.toString().padLeft(2, '0')}-${date.toUtc().day.toString().padLeft(2, '0')}';
    if (checklistIdsByDate.isEmpty) {
      return (false, ID_DefaultBlankChecklistDayID);
    } else if (checklistIdsByDate.containsKey(dateKey)) {
      return (true, checklistIdsByDate[dateKey]);
    } else {
      return (false, ID_DefaultBlankChecklistDayID);
    }
  }
}

class ChecklistFactory extends BaseChecklistFactory<Checklist> {
  @override
  Checklist fromJson(Map<String, dynamic> json) {
    Checklist result =
        Checklist.fromBaseChecklist(checklist: super.fromJson(json));
    return result;
  }
}

class ChecklistDay extends BaseChecklistDay {
  ChecklistDay({
    required super.id,
    required super.checklistId,
    required super.date,
    super.comment,
    required super.dateCreated,
    required super.dateUpdated,
    super.flagForDeletion = false,
  });

  ChecklistDay.fromBaseChecklistDay({required super.checklistDay})
      : super.fromBaseChecklistDay();
}

class ChecklistDayFactory extends BaseChecklistDayFactory<ChecklistDay> {
  @override
  ChecklistDay fromJson(Map<String, dynamic> json) {
    ChecklistDay result =
        ChecklistDay.fromBaseChecklistDay(checklistDay: super.fromJson(json));
    return result;
  }
}
