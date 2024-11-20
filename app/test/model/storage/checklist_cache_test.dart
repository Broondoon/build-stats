// checklist_cache_test.dart

import 'dart:convert';

import 'package:build_stats_flutter/model/entity/checklist.dart';
import 'package:build_stats_flutter/model/storage/checklist_cache.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
// Import the classes under test and their dependencies
import 'package:shared/app_strings.dart';

// Generate mocks for the dependencies
import '../../Mocks.dart';

void main() {
  group('ChecklistCache', () {
    late ChecklistCache checklistCache;
    late MockDataConnectionService<Checklist> mockDataConnectionService;
    late MockJsonFileAccess<Checklist> mockFileIOService;
    late MockChecklistFactory mockParser;
    late MockLocalStorage mockLocalStorage;
    late TestReadWriteMutex mutex;

    setUp(() {
      mockDataConnectionService = MockDataConnectionService<Checklist>();
      mockFileIOService = MockJsonFileAccess<Checklist>();
      mockParser = MockChecklistFactory();
      mockLocalStorage = MockLocalStorage();
      mutex = TestReadWriteMutex();

      checklistCache = ChecklistCache(
        mockDataConnectionService,
        mockFileIOService,
        mockParser,
        mockLocalStorage,
        mutex,
      );
    });

    test('getChecklistForWorksite returns checklists', () async {
      // Arrange
      final mockWorksite = MockWorksite();
      final worksiteId = 'worksite123';
      when(mockWorksite.id).thenReturn(worksiteId);
      when(mockWorksite.checklistIds).thenReturn(['checklist1', 'checklist2']);
      when(mockWorksite.getChecksum()).thenReturn('checksum0');
      final mockChecklist1 = MockChecklist();
      when(mockChecklist1.id).thenReturn('checklist1');
      when(mockChecklist1.worksiteId).thenReturn(worksiteId);
      when(mockChecklist1.toJson())
          .thenReturn({'id': 'checklist1', 'worksiteId': worksiteId});
      when(mockChecklist1.getChecksum()).thenReturn('checksum1');
      final mockChecklist2 = MockChecklist();
      when(mockChecklist2.id).thenReturn('checklist2');
      when(mockChecklist2.worksiteId).thenReturn(worksiteId);
      when(mockChecklist2.toJson())
          .thenReturn({'id': 'checklist2', 'worksiteId': worksiteId});
      when(mockChecklist2.getChecksum()).thenReturn('checksum2');

      final keys = mockWorksite.checklistIds!;

      final serverChecklistsJson = jsonEncode([
        {'id': 'checklist1', 'worksiteId': worksiteId},
        {'id': 'checklist2', 'worksiteId': worksiteId},
      ]);

      when(mockDataConnectionService
              .get('$API_ChecklistOnWorksitePath/$worksiteId'))
          .thenAnswer((_) async => serverChecklistsJson);

      when(mockFileIOService.readDataFile(any)).thenAnswer((_) async => null);

      when(mockParser.fromJson(any)).thenAnswer((invocation) {
        final json = invocation.positionalArguments[0] as Map<String, dynamic>;
        return ((json['id'] == 'checklist1') ? mockChecklist1 : mockChecklist2);
      });

      // Act
      final result = await checklistCache.getChecklistForWorksite(mockWorksite);

      // Assert
      expect(result, isNotNull);
      expect(result!.length, equals(2));
      expect(
          result.map((e) => e.id), containsAll(['checklist1', 'checklist2']));
    });
  });
}
