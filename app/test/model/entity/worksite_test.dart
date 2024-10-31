import 'dart:collection';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:build_stats_flutter/model/entity/worksite.dart';

import '../../Mocks.dart';

void main() {
  group('Worksite', () {
    late MockChecklist mockChecklist;
    late Worksite worksite;

    setUp(() {
      mockChecklist = MockChecklist();
      when(mockChecklist.id).thenReturn('checklist1');
      when(mockChecklist.worksiteId).thenReturn('worksite1');
      when(mockChecklist.TESTING_GetChecklistIdsByDate())
          .thenReturn(HashMap<String, String>());

      worksite = Worksite(
        id: 'worksite1',
        ownerId: 'owner1',
        checklistIds: ['checklist1', 'checklist2'],
        dateCreated: DateTime.parse('2023-01-01T00:00:00.000Z'),
        dateUpdated: DateTime.parse('2023-01-02T00:00:00.000Z'),
      );
    });

    test('toJson returns correct map', () {
      final json = worksite.toJson();
      print(json);
      expect(json['id'], 'worksite1');
      expect(json['dateCreated'], '2023-01-01T00:00:00.000Z');
      expect(json['dateUpdated'], '2023-01-02T00:00:00.000Z');
      expect(json['ownerId'], 'owner1');
      expect(json['checklistIds'], ['checklist1', 'checklist2']);
      //expect(json['tempChecklistDayIds'], mockChecklist.TESTING_GetChecklistIdsByDate().toString());
    });

    test('joinData returns correct string', () {
      final joinedData = worksite.joinData();

      expect(joinedData,
          'worksite1|owner1|checklist1,checklist2|2023-01-01T00:00:00.000Z|2023-01-02T00:00:00.000Z');
    });

    test('Get Check Sum', () {
      var checksum = worksite.getChecksum();
      print(checksum);
      expect(checksum, '308ae280');
    });
  });

  group('WorksiteFactory', () {
    test('fromJson creates Worksite from JSON', () {
      final json = {
        'id': 'worksite1',
        'ownerId': 'owner1',
        'checklistIds': ['checklist1', 'checklist2'],
        'dateCreated': '2023-01-01T00:00:00.000Z',
        'dateUpdated': '2023-01-02T00:00:00.000Z',
        'tempChecklistDayIds': {
          '2023-01-01T00:00:00.000Z': 'checklistDay1',
        },
      };

      final factory = WorksiteFactory();
      final worksite = factory.fromJson(json);

      expect(worksite.id, 'worksite1');
      expect(worksite.ownerId, 'owner1');
      expect(worksite.checklistIds, ['checklist1', 'checklist2']);
      expect(worksite.dateCreated, DateTime.parse('2023-01-01T00:00:00.000Z'));
      expect(worksite.dateUpdated, DateTime.parse('2023-01-02T00:00:00.000Z'));
    });
  });
}