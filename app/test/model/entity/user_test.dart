import 'package:shared/resources/app_strings.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:build_stats_flutter/model/entity/user.dart';

void main() {
  late User user;
  group('User', () {
    setUp(() {
      user = User(
        id: 'user1',
        companyId: 'company1',
        dateCreated: DateTime.parse('2023-01-01T00:00:00.000Z'),
        dateUpdated: DateTime.parse('2023-01-02T00:00:00.000Z'),
      );
    });
    test('toJson returns correct map', () {
      final json = user.toJson();
      expect(json, {
        'id': 'user1',
        'companyId': 'company1',
        'dateCreated': '2023-01-01T00:00:00.000Z',
        'dateUpdated': '2023-01-02T00:00:00.000Z',
      });
    });

    test('joinData returns correct string', () {
      final joinedData = user.joinData();
      expect(joinedData,
          'user1|company1|2023-01-01T00:00:00.000Z|2023-01-02T00:00:00.000Z');
    });

    test('ChecklistDay getChecksum', () {
      var checksum = user.getChecksum();
      expect(checksum, '56eb4797');
    });
  });

  group('UserFactory', () {
    test('fromJson creates correct User object', () {
      final json = {
        'id': 'user1',
        'companyId': 'company1',
        'dateCreated': '2023-01-01T00:00:00.000Z',
        'dateUpdated': '2023-01-02T00:00:00.000Z',
      };

      final userFactory = UserFactory();
      final user = userFactory.fromJson(json);

      expect(user.id, '123');
      expect(user.companyId, '456');
      expect(user.dateCreated, DateTime.parse('2023-01-01T00:00:00.000Z'));
      expect(user.dateUpdated, DateTime.parse('2023-01-02T00:00:00.000Z'));
    });

    test('fromJson uses fallback date when dateCreated is null', () {
      final json = {
        'id': '123',
        'companyId': '456',
        'dateCreated': null,
        'dateUpdated': '2023-01-02T00:00:00.000Z',
      };

      final userFactory = UserFactory();
      final user = userFactory.fromJson(json);

      expect(user.dateCreated, DateTime.parse(Default_FallbackDate));
    });

    test('fromJson uses fallback date when dateUpdated is null', () {
      final json = {
        'id': '123',
        'companyId': '456',
        'dateCreated': '2023-01-01T00:00:00.000Z',
        'dateUpdated': null,
      };

      final userFactory = UserFactory();
      final user = userFactory.fromJson(json);

      expect(user.dateUpdated, DateTime.parse(Default_FallbackDate));
    });
  });
}
