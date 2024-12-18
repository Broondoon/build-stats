import 'package:Server/entity/worksite.dart';
import 'package:shared/app_strings.dart';
import 'package:shared/worksite.dart';
import 'package:test/test.dart';

void main() {
  group('Worksite', () {
    test('Constructor initializes properties correctly', () {
      final dateCreated = DateTime.now().toUtc();
      final dateUpdated = dateCreated.add(Duration(hours: 1)).toUtc();

      final worksite = Worksite(
        id: 'worksite123',
        ownerId: 'owner456',
        companyId: 'company789',
        checklistIds: ['checklist1', 'checklist2'],
        dateCreated: dateCreated,
        dateUpdated: dateUpdated,
        flagForDeletion: true,
      );

      expect(worksite.id, 'worksite123');
      expect(worksite.ownerId, 'owner456');
      expect(worksite.companyId, 'company789');
      expect(worksite.checklistIds, ['checklist1', 'checklist2']);
      expect(worksite.dateCreated, dateCreated);
      expect(worksite.dateUpdated, dateUpdated);
      expect(worksite.flagForDeletion, true);
    });

    test('Constructor handles null checklistIds', () {
      final worksite = Worksite(
        id: 'worksite123',
        dateCreated: DateTime.now().toUtc(),
        dateUpdated: DateTime.now().toUtc(),
      );

      expect(worksite.checklistIds, isEmpty);
    });

    test('fromBaseWorksite copies properties correctly', () {
      final originalWorksite = BaseWorksite(
        id: 'worksite123',
        ownerId: 'owner456',
        companyId: 'company789',
        checklistIds: ['checklist1', 'checklist2'],
        dateCreated: DateTime.now().toUtc(),
        dateUpdated: DateTime.now().toUtc(),
        flagForDeletion: true,
      );

      final copiedWorksite =
          Worksite.fromBaseWorksite(worksite: originalWorksite);

      expect(copiedWorksite.id, originalWorksite.id);
      expect(copiedWorksite.ownerId, originalWorksite.ownerId);
      expect(copiedWorksite.companyId, originalWorksite.companyId);
      expect(copiedWorksite.checklistIds, originalWorksite.checklistIds);
      expect(copiedWorksite.dateCreated, originalWorksite.dateCreated);
      expect(copiedWorksite.dateUpdated, originalWorksite.dateUpdated);
      expect(copiedWorksite.flagForDeletion, originalWorksite.flagForDeletion);
    });

    test('toJson serializes correctly', () {
      final dateCreated = DateTime.parse('2021-01-01T00:00:00.000Z').toUtc();
      final dateUpdated = DateTime.parse('2021-01-02T00:00:00.000Z').toUtc();

      final worksite = Worksite(
        id: 'worksite123',
        name: '',
        ownerId: 'owner456',
        companyId: 'company789',
        checklistIds: ['checklist1', 'checklist2'],
        dateCreated: dateCreated,
        dateUpdated: dateUpdated,
        flagForDeletion: true,
      );

      final json = worksite.toJson();

      expect(json, {
        'id': 'worksite123',
        'name': '',
        'ownerId': 'owner456',
        'companyId': 'company789',
        'checklistIds': ['checklist1', 'checklist2'],
        'dateCreated': '2021-01-01T00:00:00.000Z',
        'dateUpdated': '2021-01-02T00:00:00.000Z',
        'flagForDeletion': 'true',
      });
    });

    test('joinData concatenates data correctly', () {
      final dateCreated = DateTime.parse('2021-01-01T00:00:00.000Z').toUtc();
      final dateUpdated = DateTime.parse('2021-01-02T00:00:00.000Z').toUtc();

      final worksite = Worksite(
        id: 'worksite123',
        ownerId: 'owner456',
        companyId: 'company789',
        checklistIds: ['checklist1', 'temp_checklist2'],
        dateCreated: dateCreated,
        dateUpdated: dateUpdated,
      );

      final joinedData = worksite.joinData();

      expect(
        joinedData,
        'worksite123||2021-01-01T00:00:00.000Z|2021-01-02T00:00:00.000Z|owner456|company789|checklist1',
      );
    });
  });

  group('WorksiteFactory', () {
    test('fromJson deserializes correctly', () {
      final json = {
        'id': 'worksite123',
        'name': '',
        'ownerId': 'owner456',
        'companyId': 'company789',
        'checklistIds': ['checklist1', 'checklist2'],
        'dateCreated': '2021-01-01T00:00:00.000Z',
        'dateUpdated': '2021-01-02T00:00:00.000Z',
        'flagForDeletion': 'true',
      };

      final factory = WorksiteFactory();
      final worksite = factory.fromJson(json);

      expect(worksite.id, 'worksite123');
      expect(worksite.ownerId, 'owner456');
      expect(worksite.companyId, 'company789');
      expect(worksite.checklistIds, ['checklist1', 'checklist2']);
      expect(worksite.dateCreated,
          DateTime.parse('2021-01-01T00:00:00.000Z').toUtc());
      expect(worksite.dateUpdated,
          DateTime.parse('2021-01-02T00:00:00.000Z').toUtc());
      expect(worksite.flagForDeletion, true);
    });

    test('fromJson handles missing optional fields', () {
      final json = {
        'id': 'worksite123',
        // 'ownerId' is missing
        // 'companyId' is missing
        // 'checklistIds' is missing
        // 'dateCreated' and 'dateUpdated' are missing
        // 'flagForDeletion' is missing
      };

      final factory = WorksiteFactory();
      final worksite = factory.fromJson(json);

      expect(worksite.id, 'worksite123');
      expect(worksite.ownerId, isNull);
      expect(worksite.companyId, isNull);
      expect(worksite.checklistIds, isEmpty);
      expect(worksite.dateCreated, DateTime.parse(Default_FallbackDate));
      expect(worksite.dateUpdated, DateTime.parse(Default_FallbackDate));
      expect(worksite.flagForDeletion, false);
    });
  });
}
