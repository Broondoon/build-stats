import 'package:flutter_test/flutter_test.dart';
import 'package:build_stats_flutter/model/entity/item.dart';

void main() {
  group('Item', () {
    final item = Item(
      id: '1',
      checklistDayId: 'checklist1',
      unit: 'unit1',
      desc: 'description',
      result: 'result1',
      comment: 'comment1',
      creatorId: 123,
      verified: true,
      dateCreated: DateTime.parse('2023-01-01T00:00:00.000Z'),
      dateUpdated: DateTime.parse('2023-01-02T00:00:00.000Z'),
    );

    test('toJson returns correct map', () {
      final json = item.toJson();
      expect(json, {
        'id': '1',
        'checklistDayId': 'checklist1',
        'unit': 'unit1',
        'desc': 'description',
        'result': 'result1',
        'comment': 'comment1',
        'creatorId': 123,
        'verified': true,
        'dateCreated': '2023-01-01T00:00:00.000Z',
        'dateUpdated': '2023-01-02T00:00:00.000Z',
      });
    });

    test('joinData returns correct string', () {
      final joinedData = item.joinData();
      expect(joinedData,
          '1|checklist1|unit1|description|result1|comment1|123|true|2023-01-01T00:00:00.000Z|2023-01-02T00:00:00.000Z');
    });

    test('getChecksum returns correct checksum', () {
      final checksum = item.getChecksum();
      expect(checksum, '25492fbb'); // Replace with the actual expected checksum
    });
  });

  group('ItemFactory', () {
    final itemFactory = ItemFactory();

    test('fromJson creates correct Item object', () {
      final json = {
        'id': '1',
        'checklistDayId': 'checklist1',
        'unit': 'unit1',
        'desc': 'description',
        'result': 'result1',
        'comment': 'comment1',
        'creatorId': 123,
        'verified': true,
        'dateCreated': '2023-01-01T00:00:00.000Z',
        'dateUpdated': '2023-01-02T00:00:00.000Z',
      };

      final item = itemFactory.fromJson(json);

      expect(item.id, '1');
      expect(item.checklistDayId, 'checklist1');
      expect(item.unit, 'unit1');
      expect(item.desc, 'description');
      expect(item.result, 'result1');
      expect(item.comment, 'comment1');
      expect(item.creatorId, 123);
      expect(item.verified, true);
      expect(item.dateCreated, DateTime.parse('2023-01-01T00:00:00.000Z'));
      expect(item.dateUpdated, DateTime.parse('2023-01-02T00:00:00.000Z'));
    });
  });
}
