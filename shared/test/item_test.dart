import 'package:shared/app_strings.dart';
import 'package:shared/src/base_entities/item/item.dart';
import 'package:test/test.dart';

void main() {
  group('BaseItem', () {
    test('Constructor initializes properties correctly', () {
      final dateCreated = DateTime.now();
      final dateUpdated = dateCreated.add(Duration(hours: 1));

      final baseItem = BaseItem(
        id: '123',
        checklistDayId: '456',
        unitId: 'UnitTest',
        desc: 'Test description',
        result: 'Pass',
        comment: 'No issues',
        creatorId: 'creator123',
        verified: true,
        dateCreated: dateCreated,
        dateUpdated: dateUpdated,
        flagForDeletion: true,
      );

      expect(baseItem.id, '123');
      expect(baseItem.checklistDayId, '456');
      expect(baseItem.unitId, 'UnitTest');
      expect(baseItem.desc, 'Test description');
      expect(baseItem.result, 'Pass');
      expect(baseItem.comment, 'No issues');
      expect(baseItem.creatorId, 'creator123');
      expect(baseItem.verified, true);
      expect(baseItem.dateCreated, dateCreated);
      expect(baseItem.dateUpdated, dateUpdated);
      expect(baseItem.flagForDeletion, true);
    });

    test('fromBaseItem copies properties correctly', () {
      final dateCreated = DateTime.now();
      final dateUpdated = dateCreated.add(Duration(hours: 1));

      final originalItem = BaseItem(
        id: '123',
        checklistDayId: '456',
        unitId: 'UnitTest',
        desc: 'Test description',
        result: 'Pass',
        comment: 'No issues',
        creatorId: 'creator123',
        verified: true,
        dateCreated: dateCreated,
        dateUpdated: dateUpdated,
        flagForDeletion: true,
      );

      final copiedItem = BaseItem.fromBaseItem(item: originalItem);

      expect(copiedItem.id, originalItem.id);
      expect(copiedItem.checklistDayId, originalItem.checklistDayId);
      expect(copiedItem.unitId, originalItem.unitId);
      expect(copiedItem.desc, originalItem.desc);
      expect(copiedItem.result, originalItem.result);
      expect(copiedItem.comment, originalItem.comment);
      expect(copiedItem.creatorId, originalItem.creatorId);
      expect(copiedItem.verified, originalItem.verified);
      expect(copiedItem.dateCreated, originalItem.dateCreated);
      expect(copiedItem.dateUpdated, originalItem.dateUpdated);
      expect(copiedItem.flagForDeletion, originalItem.flagForDeletion);
    });

    test('toJson serializes correctly', () {
      final dateCreated = DateTime.parse('2021-01-01T12:00:00.000Z');
      final dateUpdated = DateTime.parse('2021-01-01T13:00:00.000Z');

      final baseItem = BaseItem(
        id: '123',
        checklistDayId: '456',
        unitId: 'UnitTest',
        desc: 'Test description',
        result: 'Pass',
        comment: 'No issues',
        creatorId: 'creator123',
        verified: true,
        dateCreated: dateCreated,
        dateUpdated: dateUpdated,
        flagForDeletion: true,
      );

      final json = baseItem.toJson();

      expect(json, {
        'id': '123',
        'checklistDayId': '456',
        'unit': 'UnitTest',
        'desc': 'Test description',
        'result': 'Pass',
        'comment': 'No issues',
        'creatorId': 'creator123',
        'verified': true,
        'dateCreated': '2021-01-01T12:00:00.000Z',
        'dateUpdated': '2021-01-01T13:00:00.000Z',
        'flagForDeletion': true,
      });
    });

    test('toJsonTransfer serializes correctly without flagForDeletion', () {
      final dateCreated = DateTime.parse('2021-01-01T12:00:00.000Z');
      final dateUpdated = DateTime.parse('2021-01-01T13:00:00.000Z');

      final baseItem = BaseItem(
        id: '123',
        checklistDayId: '456',
        unitId: 'UnitTest',
        desc: 'Test description',
        result: 'Pass',
        comment: 'No issues',
        creatorId: 'creator123',
        verified: true,
        dateCreated: dateCreated,
        dateUpdated: dateUpdated,
      );

      final json = baseItem.toJsonTransfer();

      expect(json, {
        'id': '123',
        'checklistDayId': '456',
        'unit': 'UnitTest',
        'desc': 'Test description',
        'result': 'Pass',
        'comment': 'No issues',
        'creatorId': 'creator123',
        'verified': true,
        'dateCreated': '2021-01-01T12:00:00.000Z',
        'dateUpdated': '2021-01-01T13:00:00.000Z',
      });
    });

    test('joinData concatenates data correctly', () {
      final dateCreated = DateTime.parse('2021-01-01T12:00:00.000Z');
      final dateUpdated = DateTime.parse('2021-01-01T13:00:00.000Z');

      final baseItem = BaseItem(
        id: '123',
        checklistDayId: '456',
        unitId: 'UnitTest',
        desc: 'Test description',
        result: 'Pass',
        comment: 'No issues',
        creatorId: 'creator123',
        verified: true,
        dateCreated: dateCreated,
        dateUpdated: dateUpdated,
      );

      final joinedData = baseItem.joinData();

      expect(joinedData,
          '123|456|UnitTest|Test description|Pass|No issues|creator123|true|2021-01-01T12:00:00.000Z|2021-01-01T13:00:00.000Z');
    });
  });

  group('BaseItemFactory', () {
    test('fromJson deserializes correctly', () {
      final json = {
        'id': '123',
        'checklistDayId': '456',
        'unit': 'UnitTest',
        'desc': 'Test description',
        'result': 'Pass',
        'comment': 'No issues',
        'creatorId': 'creator123',
        'verified': true,
        'dateCreated': '2021-01-01T12:00:00.000Z',
        'dateUpdated': '2021-01-01T13:00:00.000Z',
        'flagForDeletion': true,
      };

      final factory = BaseItemFactory<BaseItem>();
      final baseItem = factory.fromJson(json);

      expect(baseItem.id, '123');
      expect(baseItem.checklistDayId, '456');
      expect(baseItem.unitId, 'UnitTest');
      expect(baseItem.desc, 'Test description');
      expect(baseItem.result, 'Pass');
      expect(baseItem.comment, 'No issues');
      expect(baseItem.creatorId, 'creator123');
      expect(baseItem.verified, true);
      expect(baseItem.dateCreated, DateTime.parse('2021-01-01T12:00:00.000Z'));
      expect(baseItem.dateUpdated, DateTime.parse('2021-01-01T13:00:00.000Z'));
      expect(baseItem.flagForDeletion, true);
    });

    test('fromJson handles missing optional fields', () {
      final json = {
        'id': '123',
        'checklistDayId': '456',
        'dateCreated': '2021-01-01T12:00:00.000Z',
        'dateUpdated': '2021-01-01T13:00:00.000Z',
      };

      final factory = BaseItemFactory<BaseItem>();
      final baseItem = factory.fromJson(json);

      expect(baseItem.id, '123');
      expect(baseItem.checklistDayId, '456');
      expect(baseItem.unitId, isNull);
      expect(baseItem.desc, isNull);
      expect(baseItem.result, isNull);
      expect(baseItem.comment, isNull);
      expect(baseItem.creatorId, isNull);
      expect(baseItem.verified, isNull);
      expect(baseItem.dateCreated, DateTime.parse('2021-01-01T12:00:00.000Z'));
      expect(baseItem.dateUpdated, DateTime.parse('2021-01-01T13:00:00.000Z'));
      expect(baseItem.flagForDeletion, false); // default value
    });

    test('fromJson handles null dateCreated and dateUpdated', () {
      final json = {
        'id': '123',
        'checklistDayId': '456',
        'dateCreated': null,
        'dateUpdated': null,
      };

      final factory = BaseItemFactory<BaseItem>();
      final baseItem = factory.fromJson(json);

      expect(baseItem.dateCreated, DateTime.parse(Default_FallbackDate));
      expect(baseItem.dateUpdated, DateTime.parse(Default_FallbackDate));
    });
  });
}
