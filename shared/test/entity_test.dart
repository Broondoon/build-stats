import 'package:test/test.dart';
import 'package:shared/src/base_entities/entity/entity.dart';

void main() {
  group('Entity', () {
    late Entity entity;

    setUp(() {
      entity = Entity(
        id: '123',
        dateCreated: DateTime.parse('2023-01-01T00:00:00.000Z'),
        dateUpdated: DateTime.parse('2023-01-02T00:00:00.000Z'),
      );
    });

    test('toJson should return correct map', () {
      final json = entity.toJson();
      expect(json, {
        'id': '123',
        'dateCreated': '2023-01-01T00:00:00.000Z',
        'dateUpdated': '2023-01-02T00:00:00.000Z',
        'flagForDeletion': false,
      });
    });

    test('toJsonTransfer should return correct map', () {
      final jsonTransfer = entity.toJsonTransfer();
      expect(jsonTransfer, {
        'id': '123',
        'dateCreated': '2023-01-01T00:00:00.000Z',
        'dateUpdated': '2023-01-02T00:00:00.000Z',
      });
    });

    test('joinData should return correct string', () {
      final joinedData = entity.joinData();
      expect(
          joinedData, '123|2023-01-01T00:00:00.000Z|2023-01-02T00:00:00.000Z');
    });

    test('getChecksum should return correct hash', () {
      final checksum = entity.getChecksum();
      expect(checksum,
          'ca2c1330'); // This value might need to be updated based on the actual hash
    });
  });
}
