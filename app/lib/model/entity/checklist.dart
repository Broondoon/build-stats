import 'package:shared/checklist.dart';
import 'package:shared/app_strings.dart';
import 'package:shared/entity.dart';

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
