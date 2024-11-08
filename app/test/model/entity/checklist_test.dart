import 'package:shared/resources/app_strings.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:build_stats_flutter/model/entity/checklist.dart';
import 'dart:collection';

void main() {
  group('Checklist Tests', () {
    late Checklist checklist;
    late ChecklistDay checklistDay1;
    late ChecklistDay checklistDay2;

    setUp(() {
      checklist = Checklist(id: 'checklist1', worksiteId: 'worksite1');
      checklistDay1 = ChecklistDay(
        id: 'day1',
        checklistId: 'checklist1',
        date: DateTime(2023, 1, 1),
        dateCreated: DateTime(2023, 1, 1),
        dateUpdated: DateTime(2023, 1, 1),
      );
      checklistDay2 = ChecklistDay(
        id: 'day2',
        checklistId: 'checklist1',
        date: DateTime(2023, 1, 2),
        dateCreated: DateTime(2023, 1, 2),
        dateUpdated: DateTime(2023, 1, 2),
      );
    });

    test('Initial checklist should have no checklist days', () {
      expect(checklist.TESTING_GetChecklistIdsByDate().isEmpty, true);
    });

    test('Add checklist day', () {
      checklist.addChecklistDay(checklistDay1);
      expect(checklist.TESTING_GetChecklistIdsByDate().length, 1);
      expect(
          checklist.TESTING_GetChecklistIdsByDate()[
              checklistDay1.date.toIso8601String()],
          checklistDay1.id);
    });

    test('Get checklist day ID for existing date', () {
      checklist.addChecklistDay(checklistDay1);
      var result = checklist.getChecklistDayID(DateTime(2023, 1, 1));
      expect(result, (true, 'day1'));
    });

    test('Get checklist day ID for non-existing date', () {
      checklist.addChecklistDay(checklistDay1);
      var result = checklist.getChecklistDayID(DateTime(2023, 1, 3));
      expect(result, (false, 'day1'));
    });

    test('Get checklist day ID for empty checklist', () {
      var result = checklist.getChecklistDayID(DateTime(2023, 1, 1));
      expect(result, (false, ID_DefaultBlankChecklistDayID));
    });
  });

  group('ChecklistDay Tests', () {
    late ChecklistDay checklistDay;
    setUp(() {
      checklistDay = ChecklistDay(
        id: 'day1',
        checklistId: 'checklist1',
        comment: 'Test comment',
        date: DateTime(2023, 1, 1),
        dateCreated: DateTime(2023, 1, 1),
        dateUpdated: DateTime(2023, 1, 1),
      );

      checklistDay.itemsByCatagory = HashMap<String, List<String>>();
      checklistDay.itemsByCatagory['cat1'] = ['item1', 'item2'];
    });

    test('ChecklistDay toJson', () {
      var json = checklistDay.toJson();
      expect(json['id'], 'day1');
      expect(json['checklistId'], 'checklist1');
      expect(json['date'], '2023-01-01T00:00:00.000');
      expect(json['comment'], 'Test comment');
      expect(json['itemsByCatagory'], '{cat1: [item1, item2]}');
      expect(json['dateCreated'], '2023-01-01T00:00:00.000');
      expect(json['dateUpdated'], '2023-01-01T00:00:00.000');
    });

    test('ChecklistDay joinData', () {
      var joinedData = checklistDay.joinData();
      expect(joinedData,
          'day1|checklist1|2023-01-01T00:00:00.000|Test comment|cat1,item1,item2|2023-01-01T00:00:00.000|2023-01-01T00:00:00.000');
    });

    test('ChecklistDay getChecksum', () {
      var checksum = checklistDay.getChecksum();
      expect(checksum, '56eb4797');
    });
  });
  group('ChecklistDayFactory Tests', () {
    test('ChecklistDayFactory fromJson', () {
      var json = {
        'id': 'day1',
        'checklistId': 'checklist1',
        'date': '2023-01-01T00:00:00.000',
        'comment': 'Test comment',
        'dateCreated': '2023-01-01T00:00:00.000',
        'dateUpdated': '2023-01-01T00:00:00.000',
        'itemsByCatagory': {}
      };
      var factory = ChecklistDayFactory();
      var checklistDay = factory.fromJson(json);
      expect(checklistDay.id, 'day1');
      expect(checklistDay.checklistId, 'checklist1');
      expect(checklistDay.date, DateTime(2023, 1, 1));
      expect(checklistDay.comment, 'Test comment');
      expect(checklistDay.dateCreated, DateTime(2023, 1, 1));
      expect(checklistDay.dateUpdated, DateTime(2023, 1, 1));
    });
  });
}
