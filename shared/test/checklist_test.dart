import 'package:mockito/mockito.dart';
import 'package:shared/src/base_entities/checklist/checklist.dart';
import 'package:test/test.dart';

import 'mocks.dart';

void main() {
  group('BaseChecklist', () {
    test('Constructor initializes properties correctly', () {
      final dateCreated = DateTime.now();
      final dateUpdated = dateCreated.add(Duration(hours: 1));

      final checklist = BaseChecklist(
        id: 'checklist1',
        worksiteId: 'worksite123',
        name: 'Daily Checklist',
        dateCreated: dateCreated,
        dateUpdated: dateUpdated,
        flagForDeletion: true,
      );

      expect(checklist.id, 'checklist1');
      expect(checklist.worksiteId, 'worksite123');
      expect(checklist.name, 'Daily Checklist');
      expect(checklist.checklistIdsByDate, isEmpty);
      expect(checklist.dateCreated, dateCreated);
      expect(checklist.dateUpdated, dateUpdated);
      expect(checklist.flagForDeletion, true);
    });

    test('fromBaseChecklist copies properties correctly', () {
      final originalChecklist = BaseChecklist(
        id: 'checklist1',
        worksiteId: 'worksite123',
        name: 'Daily Checklist',
        dateCreated: DateTime.now(),
        dateUpdated: DateTime.now(),
      );
      originalChecklist.checklistIdsByDate['2021-01-01'] = 'day1';

      final copiedChecklist =
          BaseChecklist.fromBaseChecklist(checklist: originalChecklist);

      expect(copiedChecklist.id, originalChecklist.id);
      expect(copiedChecklist.worksiteId, originalChecklist.worksiteId);
      expect(copiedChecklist.name, originalChecklist.name);
      expect(copiedChecklist.checklistIdsByDate,
          originalChecklist.checklistIdsByDate);
      expect(copiedChecklist.dateCreated, originalChecklist.dateCreated);
      expect(copiedChecklist.dateUpdated, originalChecklist.dateUpdated);
      expect(
          copiedChecklist.flagForDeletion, originalChecklist.flagForDeletion);
    });

    test('addChecklistDay adds day correctly', () {
      final checklist = BaseChecklist(
        id: 'checklist1',
        worksiteId: 'worksite123',
        dateCreated: DateTime.now(),
        dateUpdated: DateTime.now(),
      );

      final date = DateTime(2021, 1, 1);
      checklist.addChecklistDay(null, date, 'day1');

      expect(checklist.checklistIdsByDate['2021-01-01'], 'day1');
    });

    test('removeChecklistDay removes day correctly', () {
      final checklist = BaseChecklist(
        id: 'checklist1',
        worksiteId: 'worksite123',
        dateCreated: DateTime.now(),
        dateUpdated: DateTime.now(),
      );

      final date = DateTime(2021, 1, 1);
      final day = BaseChecklistDay(
        id: 'day1',
        checklistId: 'checklist1',
        date: date,
        dateCreated: DateTime.now(),
        dateUpdated: DateTime.now(),
      );

      checklist.addChecklistDay(day, null, null);
      expect(checklist.checklistIdsByDate['2021-01-01'], 'day1');

      checklist.removeChecklistDay(day);
      expect(checklist.checklistIdsByDate.containsKey('2021-01-01'), false);
    });

    test('toJson serializes correctly', () {
      final dateCreated = DateTime.parse('2021-01-01T00:00:00.000Z');
      final dateUpdated = DateTime.parse('2021-01-02T00:00:00.000Z');

      final checklist = BaseChecklist(
        id: 'checklist1',
        worksiteId: 'worksite123',
        name: 'Daily Checklist',
        dateCreated: dateCreated,
        dateUpdated: dateUpdated,
        flagForDeletion: true,
      );
      checklist.checklistIdsByDate['2021-01-01'] = 'day1';

      final json = checklist.toJson();

      expect(json, {
        'id': 'checklist1',
        'worksiteId': 'worksite123',
        'name': 'Daily Checklist',
        'checklistIdsByDate': {'2021-01-01': 'day1'},
        'dateCreated': '2021-01-01T00:00:00.000Z',
        'dateUpdated': '2021-01-02T00:00:00.000Z',
        'flagForDeletion': true,
      });
    });

    test('toJsonTransfer excludes temp IDs and flagForDeletion', () {
      final checklist = BaseChecklist(
        id: 'checklist1',
        worksiteId: 'worksite123',
        dateCreated: DateTime.now(),
        dateUpdated: DateTime.now(),
      );
      checklist.checklistIdsByDate['2021-01-01'] = 'day1';
      checklist.checklistIdsByDate['2021-01-02'] = 'temp_day2';

      final json = checklist.toJsonTransfer();

      expect(json['checklistIdsByDate'], {'2021-01-01': 'day1'});
      expect(json.containsKey('flagForDeletion'), false);
    });

    test('joinData concatenates data correctly', () {
      final dateCreated = DateTime.parse('2021-01-01T00:00:00.000Z');
      final dateUpdated = DateTime.parse('2021-01-02T00:00:00.000Z');

      final checklist = BaseChecklist(
        id: 'checklist1',
        worksiteId: 'worksite123',
        name: 'Daily Checklist',
        dateCreated: dateCreated,
        dateUpdated: dateUpdated,
      );
      checklist.checklistIdsByDate['2021-01-01'] = 'day1';
      checklist.checklistIdsByDate['2021-01-02'] = 'temp_day2';

      final joinedData = checklist.joinData();

      expect(joinedData,
          'checklist1|worksite123|Daily Checklist|2021-01-01,day1|2021-01-01T00:00:00.000Z|2021-01-02T00:00:00.000Z');
    });
  });

  group('BaseChecklistFactory', () {
    test('fromJson deserializes correctly', () {
      final json = {
        'id': 'checklist1',
        'worksiteId': 'worksite123',
        'name': 'Daily Checklist',
        'checklistIdsByDate': {'2021-01-01': 'day1'},
        'dateCreated': '2021-01-01T00:00:00.000Z',
        'dateUpdated': '2021-01-02T00:00:00.000Z',
        'flagForDeletion': true,
      };

      final factory = BaseChecklistFactory<BaseChecklist>();
      final checklist = factory.fromJson(json);

      expect(checklist.id, 'checklist1');
      expect(checklist.worksiteId, 'worksite123');
      expect(checklist.name, 'Daily Checklist');
      expect(checklist.checklistIdsByDate, {'2021-01-01': 'day1'});
      expect(checklist.dateCreated, DateTime.parse('2021-01-01T00:00:00.000Z'));
      expect(checklist.dateUpdated, DateTime.parse('2021-01-02T00:00:00.000Z'));
      expect(checklist.flagForDeletion, true);
    });
  });

  group('BaseChecklistDay', () {
    test('Constructor initializes properties correctly', () {
      final dateCreated = DateTime.now();
      final dateUpdated = dateCreated.add(Duration(hours: 1));

      final checklistDay = BaseChecklistDay(
        id: 'day1',
        checklistId: 'checklist1',
        date: DateTime(2021, 1, 1),
        comment: 'No issues',
        dateCreated: dateCreated,
        dateUpdated: dateUpdated,
        flagForDeletion: true,
      );

      expect(checklistDay.id, 'day1');
      expect(checklistDay.checklistId, 'checklist1');
      expect(checklistDay.date, DateTime(2021, 1, 1));
      expect(checklistDay.comment, 'No issues');
      expect(checklistDay.itemsByCatagory, isEmpty);
      expect(checklistDay.dateCreated, dateCreated);
      expect(checklistDay.dateUpdated, dateUpdated);
      expect(checklistDay.flagForDeletion, true);
    });

    test('fromBaseChecklistDay copies properties correctly', () {
      final originalDay = BaseChecklistDay(
        id: 'day1',
        checklistId: 'checklist1',
        date: DateTime(2021, 1, 1),
        comment: 'No issues',
        dateCreated: DateTime.now(),
        dateUpdated: DateTime.now(),
      );
      originalDay.addCategory('Safety');

      final copiedDay =
          BaseChecklistDay.fromBaseChecklistDay(checklistDay: originalDay);

      expect(copiedDay.id, originalDay.id);
      expect(copiedDay.checklistId, originalDay.checklistId);
      expect(copiedDay.date, originalDay.date);
      expect(copiedDay.comment, originalDay.comment);
      expect(copiedDay.itemsByCatagory, originalDay.itemsByCatagory);
      expect(copiedDay.dateCreated, originalDay.dateCreated);
      expect(copiedDay.dateUpdated, originalDay.dateUpdated);
      expect(copiedDay.flagForDeletion, originalDay.flagForDeletion);
    });

    test('addCategory adds a new category', () {
      final checklistDay = BaseChecklistDay(
        id: 'day1',
        checklistId: 'checklist1',
        date: DateTime(2021, 1, 1),
        dateCreated: DateTime.now(),
        dateUpdated: DateTime.now(),
      );

      checklistDay.addCategory('Safety');
      expect(checklistDay.itemsByCatagory.containsKey('Safety'), true);
      expect(checklistDay.itemsByCatagory['Safety'], isEmpty);
    });

    test('removeCategory removes an empty category', () {
      final checklistDay = BaseChecklistDay(
        id: 'day1',
        checklistId: 'checklist1',
        date: DateTime(2021, 1, 1),
        dateCreated: DateTime.now(),
        dateUpdated: DateTime.now(),
      );

      checklistDay.addCategory('Safety');
      checklistDay.removeCategory('Safety');
      expect(checklistDay.itemsByCatagory.containsKey('Safety'), false);
    });

    test('removeCategory throws exception if category is not empty', () {
      final checklistDay = BaseChecklistDay(
        id: 'day1',
        checklistId: 'checklist1',
        date: DateTime(2021, 1, 1),
        dateCreated: DateTime.now(),
        dateUpdated: DateTime.now(),
      );

      checklistDay.addCategory('Safety');
      checklistDay.addItemId('Safety', 'item1');

      expect(() => checklistDay.removeCategory('Safety'), throwsException);
    });

    test('addItemId adds item to category', () {
      final checklistDay = BaseChecklistDay(
        id: 'day1',
        checklistId: 'checklist1',
        date: DateTime(2021, 1, 1),
        dateCreated: DateTime.now(),
        dateUpdated: DateTime.now(),
      );

      checklistDay.addItemId('Safety', 'item1');
      expect(checklistDay.itemsByCatagory['Safety'], ['item1']);
    });

    test('removeItem removes item from category', () {
      final checklistDay = BaseChecklistDay(
        id: 'day1',
        checklistId: 'checklist1',
        date: DateTime(2021, 1, 1),
        dateCreated: DateTime.now(),
        dateUpdated: DateTime.now(),
      );

      checklistDay.addItemId('Safety', 'item1');
      final item = MockBaseItem();
      when(item.id).thenReturn('item1');
      checklistDay.removeItem('Safety', item);

      expect(checklistDay.itemsByCatagory['Safety'], isEmpty);
    });

    test('getItemsByCategory returns items correctly', () {
      final checklistDay = BaseChecklistDay(
        id: 'day1',
        checklistId: 'checklist1',
        date: DateTime(2021, 1, 1),
        dateCreated: DateTime.now(),
        dateUpdated: DateTime.now(),
      );

      checklistDay.addItemId('Safety', 'item1');
      checklistDay.addItemId('Safety', 'item2');

      final items = checklistDay.getItemsByCategory('Safety');
      expect(items, ['item1', 'item2']);
    });

    test('getCategoryForItem returns correct category', () {
      final checklistDay = BaseChecklistDay(
        id: 'day1',
        checklistId: 'checklist1',
        date: DateTime(2021, 1, 1),
        dateCreated: DateTime.now(),
        dateUpdated: DateTime.now(),
      );

      final item = MockBaseItem();
      when(item.id).thenReturn('item1');
      checklistDay.addItem('Safety', item);

      final category = checklistDay.getCategoryForItem(item);
      expect(category, 'Safety');
    });

    test('toJson serializes correctly', () {
      final dateCreated = DateTime.parse('2021-01-01T00:00:00.000Z');
      final dateUpdated = DateTime.parse('2021-01-02T00:00:00.000Z');

      final checklistDay = BaseChecklistDay(
        id: 'day1',
        checklistId: 'checklist1',
        date: DateTime.utc(2021, 1, 1),
        comment: 'No issues',
        dateCreated: dateCreated,
        dateUpdated: dateUpdated,
        flagForDeletion: true,
      );
      checklistDay.addItemId('Safety', 'item1');

      final json = checklistDay.toJson();

      expect(json, {
        'id': 'day1',
        'checklistId': 'checklist1',
        'date': '2021-01-01T00:00:00.000Z',
        'comment': 'No issues',
        'itemsByCatagory': {
          'Safety': ['item1']
        },
        'dateCreated': '2021-01-01T00:00:00.000Z',
        'dateUpdated': '2021-01-02T00:00:00.000Z',
        'flagForDeletion': true,
      });
    });

    test('toJsonTransfer excludes temp IDs and flagForDeletion', () {
      final checklistDay = BaseChecklistDay(
        id: 'day1',
        checklistId: 'checklist1',
        date: DateTime.now(),
        dateCreated: DateTime.now(),
        dateUpdated: DateTime.now(),
      );
      checklistDay.addItemId('Safety', 'item1');
      checklistDay.addItemId('Safety', 'temp_item2');

      final json = checklistDay.toJsonTransfer();

      expect(json['itemsByCatagory'], {
        'Safety': ['item1']
      });
      expect(json.containsKey('flagForDeletion'), false);
    });

    test('joinData concatenates data correctly', () {
      final dateCreated = DateTime.parse('2021-01-01T00:00:00.000Z');
      final dateUpdated = DateTime.parse('2021-01-02T00:00:00.000Z');

      final checklistDay = BaseChecklistDay(
        id: 'day1',
        checklistId: 'checklist1',
        date: DateTime.utc(2021, 1, 1),
        comment: 'No issues',
        dateCreated: dateCreated,
        dateUpdated: dateUpdated,
      );
      checklistDay.addItemId('Safety', 'item1');
      checklistDay.addItemId('Safety', 'temp_item2');

      final joinedData = checklistDay.joinData();

      expect(joinedData,
          'day1|checklist1|2021-01-01T00:00:00.000Z|No issues|Safety,item1|2021-01-01T00:00:00.000Z|2021-01-02T00:00:00.000Z');
    });
  });

  group('BaseChecklistDayFactory', () {
    test('fromJson deserializes correctly', () {
      final json = {
        'id': 'day1',
        'checklistId': 'checklist1',
        'date': '2021-01-01T00:00:00.000Z',
        'comment': 'No issues',
        'itemsByCatagory': {
          'Safety': ['item1', 'item2']
        },
        'dateCreated': '2021-01-01T00:00:00.000Z',
        'dateUpdated': '2021-01-02T00:00:00.000Z',
        'flagForDeletion': true,
      };

      final factory = BaseChecklistDayFactory<BaseChecklistDay>();
      final checklistDay = factory.fromJson(json);

      expect(checklistDay.id, 'day1');
      expect(checklistDay.checklistId, 'checklist1');
      expect(checklistDay.date, DateTime.parse('2021-01-01T00:00:00.000Z'));
      expect(checklistDay.comment, 'No issues');
      expect(checklistDay.itemsByCatagory, {
        'Safety': ['item1', 'item2']
      });
      expect(
          checklistDay.dateCreated, DateTime.parse('2021-01-01T00:00:00.000Z'));
      expect(
          checklistDay.dateUpdated, DateTime.parse('2021-01-02T00:00:00.000Z'));
      expect(checklistDay.flagForDeletion, true);
    });
  });
}
