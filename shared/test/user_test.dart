import 'package:shared/src/base_entities/user/user.dart';
import 'package:shared/src/resources/app_strings.dart';
import 'package:test/test.dart';

void main() {
  group('BaseUser', () {
    test('Constructor initializes properties correctly', () {
      final dateCreated = DateTime.now().toUtc();
      final dateUpdated = dateCreated.add(Duration(hours: 1)).toUtc();

      final user = BaseUser(
        id: 'user123',
        companyId: 'company456',
        dateCreated: dateCreated,
        dateUpdated: dateUpdated,
        flagForDeletion: true,
      );

      expect(user.id, 'user123');
      expect(user.companyId, 'company456');
      expect(user.dateCreated, dateCreated);
      expect(user.dateUpdated, dateUpdated);
      expect(user.flagForDeletion, true);
    });

    test('fromBaseUser copies properties correctly', () {
      final originalUser = BaseUser(
        id: 'user123',
        companyId: 'company456',
        dateCreated: DateTime.now().toUtc(),
        dateUpdated: DateTime.now().toUtc(),
        flagForDeletion: true,
      );

      final copiedUser = BaseUser.fromBaseUser(user: originalUser);

      expect(copiedUser.id, originalUser.id);
      expect(copiedUser.companyId, originalUser.companyId);
      expect(copiedUser.dateCreated, originalUser.dateCreated);
      expect(copiedUser.dateUpdated, originalUser.dateUpdated);
      expect(copiedUser.flagForDeletion, originalUser.flagForDeletion);
    });

    test('toJson serializes correctly', () {
      final dateCreated = DateTime.parse('2021-01-01T00:00:00.000Z').toUtc();
      final dateUpdated = DateTime.parse('2021-01-02T00:00:00.000Z').toUtc();

      final user = BaseUser(
        id: 'user123',
        companyId: 'company456',
        dateCreated: dateCreated,
        dateUpdated: dateUpdated,
        flagForDeletion: true,
      );

      final json = user.toJson();

      expect(json, {
        'id': 'user123',
        'companyId': 'company456',
        'dateCreated': '2021-01-01T00:00:00.000Z',
        'dateUpdated': '2021-01-02T00:00:00.000Z',
        'flagForDeletion': true,
      });
    });

    test('toJsonTransfer serializes correctly without flagForDeletion', () {
      final dateCreated = DateTime.parse('2021-01-01T00:00:00.000Z').toUtc();
      final dateUpdated = DateTime.parse('2021-01-02T00:00:00.000Z').toUtc();

      final user = BaseUser(
        id: 'user123',
        companyId: 'company456',
        dateCreated: dateCreated,
        dateUpdated: dateUpdated,
      );

      final json = user.toJsonTransfer();

      expect(json, {
        'id': 'user123',
        'companyId': 'company456',
        'dateCreated': '2021-01-01T00:00:00.000Z',
        'dateUpdated': '2021-01-02T00:00:00.000Z',
      });
    });

    test('joinData concatenates data correctly', () {
      final dateCreated = DateTime.parse('2021-01-01T00:00:00.000Z').toUtc();
      final dateUpdated = DateTime.parse('2021-01-02T00:00:00.000Z').toUtc();

      final user = BaseUser(
        id: 'user123',
        companyId: 'company456',
        dateCreated: dateCreated,
        dateUpdated: dateUpdated,
      );

      final joinedData = user.joinData();

      expect(
        joinedData,
        'user123|company456|2021-01-01T00:00:00.000Z|2021-01-02T00:00:00.000Z',
      );
    });
  });

  group('BaseUserFactory', () {
    test('fromJson deserializes correctly', () {
      final json = {
        'id': 'user123',
        'companyId': 'company456',
        'dateCreated': '2021-01-01T00:00:00.000Z',
        'dateUpdated': '2021-01-02T00:00:00.000Z',
        'flagForDeletion': true,
      };

      final factory = BaseUserFactory<BaseUser>();
      final user = factory.fromJson(json);

      expect(user.id, 'user123');
      expect(user.companyId, 'company456');
      expect(
          user.dateCreated, DateTime.parse('2021-01-01T00:00:00.000Z').toUtc());
      expect(
          user.dateUpdated, DateTime.parse('2021-01-02T00:00:00.000Z').toUtc());
      expect(user.flagForDeletion, true);
    });

    test('fromJson handles missing optional fields', () {
      final json = {
        'id': 'user123',
        'companyId': 'company456',
        // 'dateCreated' and 'dateUpdated' are missing
        // 'flagForDeletion' is missing
      };

      final factory = BaseUserFactory<BaseUser>();
      final user = factory.fromJson(json);

      expect(user.id, 'user123');
      expect(user.companyId, 'company456');
      expect(user.dateCreated, DateTime.parse(Default_FallbackDate));
      expect(user.dateUpdated, DateTime.parse(Default_FallbackDate));
      expect(user.flagForDeletion, false);
    });
  });
}
