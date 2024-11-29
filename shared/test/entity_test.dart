import 'package:test/test.dart';
import 'package:shared/src/base_entities/entity/entity.dart';

void main() {
  group('Entity', () {
    late Entity entity;

    setUp(() {
      entity = Entity(
        id: '123',
        name: "testEntity",
        dateCreated: DateTime.parse('2023-01-01T00:00:00.000Z'),
        dateUpdated: DateTime.parse('2023-01-02T00:00:00.000Z'),
      );
    });

    test('fromEntity should return correct entity', () {
      final entityFromEntity = Entity.fromEntity(entity: entity);
      expect(entityFromEntity.id, '123');
      expect(entityFromEntity.name, 'testEntity');
      expect(entityFromEntity.dateCreated, DateTime.parse('2023-01-01T00:00:00.000Z'));
      expect(entityFromEntity.dateUpdated, DateTime.parse('2023-01-02T00:00:00.000Z'));
      expect(entityFromEntity.flagForDeletion, false);
    });

    test('toJson should return correct map', () {
      final json = entity.toJson();
      expect(json, {
        'id': '123',
        'name': 'testEntity',
        'dateCreated': '2023-01-01T00:00:00.000Z',
        'dateUpdated': '2023-01-02T00:00:00.000Z',
        'flagForDeletion': 'false',
      });
    });

    test('toJsonTransfer should return correct map', () {
      final jsonTransfer = entity.toJsonTransfer();
      expect(jsonTransfer, {
        'id': '123',
        'name': 'testEntity',
        'dateCreated': '2023-01-01T00:00:00.000Z',
        'dateUpdated': '2023-01-02T00:00:00.000Z',
      });
    });

    test('joinData should return correct string', () {
      final joinedData = entity.joinData();
      expect(
          joinedData, '123|testEntity|2023-01-01T00:00:00.000Z|2023-01-02T00:00:00.000Z');
    });

    test('getChecksum should return correct hash', () {
      final checksum = entity.getChecksum();
      expect(checksum,
          'ea26cf41'); // This value might need to be updated based on the actual hash
    });
  });
}
