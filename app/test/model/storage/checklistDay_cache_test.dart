// checklist_day_cache_test.dart

import 'dart:collection';
import 'dart:convert';

import 'package:build_stats_flutter/model/entity/checklist.dart';
import 'package:build_stats_flutter/model/storage/checklist_cache.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import '../../Mocks.dart';

// Import the classes under test and their dependencies
import 'package:shared/app_strings.dart';

void main() {
  group('ChecklistDayCache', () {
    provideDummy<HashMap<String, String>>(HashMap<String, String>());
    late ChecklistDayCache checklistDayCache;
    late MockDataConnectionService<ChecklistDay> mockDataConnectionService;
    late MockJsonFileAccess<ChecklistDay> mockFileIOService;
    late MockChecklistDayFactory mockParser;
    late MockLocalStorage mockLocalStorage;
    late TestReadWriteMutex mutex;

    setUp(() {
      mockDataConnectionService = MockDataConnectionService<ChecklistDay>();
      mockFileIOService = MockJsonFileAccess<ChecklistDay>();
      mockParser = MockChecklistDayFactory();
      mockLocalStorage = MockLocalStorage();
      mutex = TestReadWriteMutex();

      checklistDayCache = ChecklistDayCache(
        mockDataConnectionService,
        mockFileIOService,
        mockParser,
        mockLocalStorage,
        mutex,
      );
    });

    test('getChecklistDaysForChecklist returns checklist days', () async {
      // Arrange
      final mockChecklist = MockChecklist();
      final checklistId = 'checklist123';
      when(mockChecklist.id).thenReturn(checklistId);
      final HashMap<String, String> checklistDayIds = HashMap.from(
          {'2022-01-01': 'checklistDay1', '2022-01-02': 'checklistDay2'});
      when(mockChecklist.checklistIdsByDate).thenReturn(checklistDayIds);
      when(mockChecklist.getChecksum()).thenReturn('checksum0');
      final ChecklistDay mockChecklistDay1 = MockChecklistDay();
      when(mockChecklistDay1.id).thenReturn('checklistDay1');
      when(mockChecklistDay1.checklistId).thenReturn(checklistId);
      when(mockChecklistDay1.toJson())
          .thenReturn({'id': 'checklistDay1', 'checklistId': checklistId});
      when(mockChecklistDay1.getChecksum()).thenReturn('checksum1');
      final ChecklistDay mockChecklistDay2 = MockChecklistDay();
      when(mockChecklistDay2.id).thenReturn('checklistDay2');
      when(mockChecklistDay2.checklistId).thenReturn(checklistId);
      when(mockChecklistDay2.toJson())
          .thenReturn({'id': 'checklistDay2', 'checklistId': checklistId});
      when(mockChecklistDay2.getChecksum()).thenReturn('checksum2');

      final serverChecklistDaysJson = jsonEncode([
        {'id': 'checklistDay1', 'checklistId': checklistId},
        {'id': 'checklistDay2', 'checklistId': checklistId},
      ]);

      when(mockDataConnectionService
              .get('$API_DaysOnChecklistPath/$checklistId'))
          .thenAnswer((_) async => serverChecklistDaysJson);
      when(mockFileIOService.readDataFile(any)).thenAnswer((_) async => null);

      when(mockParser.fromJson(any)).thenAnswer((invocation) {
        final json = invocation.positionalArguments[0] as Map<String, dynamic>;
        return ((json['id'] == 'checklistDay1')
            ? mockChecklistDay1
            : mockChecklistDay2);
      });

      // Act
      final result =
          await checklistDayCache.getChecklistDaysForChecklist(mockChecklist);

      // Assert
      expect(result, isNotNull);
      expect(result!.length, equals(2));
      expect(result.map((e) => e.id),
          containsAll(['checklistDay1', 'checklistDay2']));
    });
  });
}
