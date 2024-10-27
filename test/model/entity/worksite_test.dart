import 'dart:collection';

import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:build_stats_flutter/model/entity/worksite.dart';
import 'package:build_stats_flutter/model/entity/checklist.dart';
import 'package:build_stats_flutter/resources/app_strings.dart';

// Create a mock class for Checklist
class MockChecklist extends Mock implements Checklist {
  @override
  String get id =>
      super.noSuchMethod(Invocation.getter(#id), returnValue: 'checklist1');

  @override
  String get worksiteId => super
      .noSuchMethod(Invocation.getter(#worksiteId), returnValue: 'worksite1');

  @override
  HashMap<String, String> TESTING_GetChecklistIdsByDate() => super.noSuchMethod(
        Invocation.method(#TESTING_GetChecklistIdsByDate, []),
        returnValue: HashMap<String, String>(),
      );
}

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
        currentChecklist: mockChecklist,
      );
    });

    test('toJson returns correct map', () {
      final json = worksite.toJson();
      print(json);
      expect(json['id'], 'worksite1');
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
      expect(worksite.currentChecklist?.id, 'tempworksite1');
      expect(worksite.currentChecklist?.worksiteId, 'worksite1');
    });
  });
}
