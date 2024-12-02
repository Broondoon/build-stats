import 'package:shared/checklist.dart';
import 'package:shared/app_strings.dart';

class Checklist extends BaseChecklist {
  Checklist({
    required super.id,
    super.name,
    required super.worksiteId,
    required super.dateCreated,
    required super.dateUpdated,
    super.flagForDeletion = false,
  });

  Checklist.fromBaseChecklist({required super.checklist})
      : super.fromBaseChecklist();
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
    super.name,
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
