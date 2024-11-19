import 'package:Server/entity/item.dart';
import 'package:shared/item.dart';
import 'package:test/test.dart';

void main() {
  group('Item', () {
    test('Constructor initializes properties correctly', () {
      final dateCreated = DateTime.now();
      final dateUpdated = dateCreated.add(Duration(hours: 1));

      final item = Item(
        id: 'item123',
        checklistDayId: 'checklistDay456',
        unit: 'UnitTest',
        desc: 'Test description',
        result: 'Pass',
        comment: 'No issues',
        creatorId: 'creator789',
        verified: true,
        dateCreated: dateCreated,
        dateUpdated: dateUpdated,
        flagForDeletion: true,
      );

      expect(item.id, 'item123');
      expect(item.checklistDayId, 'checklistDay456');
      expect(item.unit, 'UnitTest');
      expect(item.desc, 'Test description');
      expect(item.result, 'Pass');
      expect(item.comment, 'No issues');
      expect(item.creatorId, 'creator789');
      expect(item.verified, true);
      expect(item.dateCreated, dateCreated);
      expect(item.dateUpdated, dateUpdated);
      expect(item.flagForDeletion, true);
    });

    test('fromBaseItem copies properties correctly', () {
      final originalItem = BaseItem(
        id: 'item123',
        checklistDayId: 'checklistDay456',
        unit: 'UnitTest',
        desc: 'Test description',
        result: 'Pass',
        comment: 'No issues',
        creatorId: 'creator789',
        verified: true,
        dateCreated: DateTime.now(),
        dateUpdated: DateTime.now(),
        flagForDeletion: true,
      );

      final item = Item.fromBaseItem(item: originalItem);

      expect(item.id, originalItem.id);
      expect(item.checklistDayId, originalItem.checklistDayId);
      expect(item.unit, originalItem.unit);
      expect(item.desc, originalItem.desc);
      expect(item.result, originalItem.result);
      expect(item.comment, originalItem.comment);
      expect(item.creatorId, originalItem.creatorId);
      expect(item.verified, originalItem.verified);
      expect(item.dateCreated, originalItem.dateCreated);
      expect(item.dateUpdated, originalItem.dateUpdated);
      expect(item.flagForDeletion, originalItem.flagForDeletion);
    });

    test('toJson serializes correctly', () {
      final dateCreated = DateTime.parse('2021-01-01T12:00:00.000Z');
      final dateUpdated = DateTime.parse('2021-01-01T13:00:00.000Z');

      final item = Item(
        id: 'item123',
        checklistDayId: 'checklistDay456',
        unit: 'UnitTest',
        desc: 'Test description',
        result: 'Pass',
        comment: 'No issues',
        creatorId: 'creator789',
        verified: true,
        dateCreated: dateCreated,
        dateUpdated: dateUpdated,
        flagForDeletion: true,
      );

      final json = item.toJson();

      expect(json, {
        'id': 'item123',
        'checklistDayId': 'checklistDay456',
        'unit': 'UnitTest',
        'desc': 'Test description',
        'result': 'Pass',
        'comment': 'No issues',
        'creatorId': 'creator789',
        'verified': true,
        'dateCreated': '2021-01-01T12:00:00.000Z',
        'dateUpdated': '2021-01-01T13:00:00.000Z',
        'flagForDeletion': true,
      });
    });

    test('joinData concatenates data correctly', () {
      final dateCreated = DateTime.parse('2021-01-01T12:00:00.000Z');
      final dateUpdated = DateTime.parse('2021-01-01T13:00:00.000Z');

      final item = Item(
        id: 'item123',
        checklistDayId: 'checklistDay456',
        unit: 'UnitTest',
        desc: 'Test description',
        result: 'Pass',
        comment: 'No issues',
        creatorId: 'creator789',
        verified: true,
        dateCreated: dateCreated,
        dateUpdated: dateUpdated,
      );

      final joinedData = item.joinData();

      expect(
        joinedData,
        'item123|checklistDay456|UnitTest|Test description|Pass|No issues|creator789|true|2021-01-01T12:00:00.000Z|2021-01-01T13:00:00.000Z',
      );
    });
  });

  group('ItemFactory', () {
    test('fromJson deserializes correctly', () {
      final json = {
        'id': 'item123',
        'checklistDayId': 'checklistDay456',
        'unit': 'UnitTest',
        'desc': 'Test description',
        'result': 'Pass',
        'comment': 'No issues',
        'creatorId': 'creator789',
        'verified': true,
        'dateCreated': '2021-01-01T12:00:00.000Z',
        'dateUpdated': '2021-01-01T13:00:00.000Z',
        'flagForDeletion': true,
      };

      final factory = ItemFactory();
      final item = factory.fromJson(json);

      expect(item.id, 'item123');
      expect(item.checklistDayId, 'checklistDay456');
      expect(item.unit, 'UnitTest');
      expect(item.desc, 'Test description');
      expect(item.result, 'Pass');
      expect(item.comment, 'No issues');
      expect(item.creatorId, 'creator789');
      expect(item.verified, true);
      expect(item.dateCreated, DateTime.parse('2021-01-01T12:00:00.000Z'));
      expect(item.dateUpdated, DateTime.parse('2021-01-01T13:00:00.000Z'));
      expect(item.flagForDeletion, true);
    });

    test('fromJson handles missing optional fields', () {
      final json = {
        'id': 'item123',
        'checklistDayId': 'checklistDay456',
        // Optional fields are missing
        'dateCreated': '2021-01-01T12:00:00.000Z',
        'dateUpdated': '2021-01-01T13:00:00.000Z',
      };

      final factory = ItemFactory();
      final item = factory.fromJson(json);

      expect(item.id, 'item123');
      expect(item.checklistDayId, 'checklistDay456');
      expect(item.unit, isNull);
      expect(item.desc, isNull);
      expect(item.result, isNull);
      expect(item.comment, isNull);
      expect(item.creatorId, isNull);
      expect(item.verified, isNull);
      expect(item.dateCreated, DateTime.parse('2021-01-01T12:00:00.000Z'));
      expect(item.dateUpdated, DateTime.parse('2021-01-01T13:00:00.000Z'));
      expect(item.flagForDeletion, false); // default value
    });
  });
}
