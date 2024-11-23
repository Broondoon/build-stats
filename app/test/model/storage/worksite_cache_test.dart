// worksite_cache_test.dart

import 'dart:convert';

import 'package:build_stats_flutter/model/entity/worksite.dart';
import 'package:build_stats_flutter/model/storage/worksite_cache.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import 'package:shared/app_strings.dart';
import '../../Mocks.dart';

void main() {
  group('WorksiteCache', () {
    late WorksiteCache worksiteCache;
    late MockDataConnectionService<Worksite> mockDataConnectionService;
    late MockJsonFileAccess<Worksite> mockFileIOService;
    late MockWorksiteFactory mockParser;
    late MockLocalStorage mockLocalStorage;
    late TestReadWriteMutex mutex;
    late MockUser mockUser;

    setUp(() {
      mockDataConnectionService = MockDataConnectionService<Worksite>();
      mockFileIOService = MockJsonFileAccess<Worksite>();
      mockParser = MockWorksiteFactory();
      mockLocalStorage = MockLocalStorage();
      mutex = TestReadWriteMutex();
      mockUser = MockUser();

      worksiteCache = WorksiteCache(
        mockDataConnectionService,
        mockFileIOService,
        mockParser,
        mockLocalStorage,
        mutex,
      );
    });

    test('getUserWorksites loads worksites when not loaded before', () async {
      // Arrange
      when(mockUser.id).thenReturn('user123');
      when(mockUser.companyId).thenReturn('company456');

      final apiPath =
          '$API_WorksiteUserVisiblePath/${mockUser.companyId}/${mockUser.id}';

      final serverWorksitesJson = jsonEncode([
        {
          'id': 'worksite1',
          'ownerId': 'user123',
          'dateUpdated': '2022-01-01T00:00:00Z'
        },
        {
          'id': 'worksite2',
          'ownerId': 'user123',
          'dateUpdated': '2022-01-02T00:00:00Z'
        },
      ]);

      when(mockDataConnectionService.get(apiPath))
          .thenAnswer((_) async => serverWorksitesJson);

      // Mock the parsing of JSON into Worksite instances
      final mockWorksite1 = MockWorksite();
      when(mockWorksite1.id).thenReturn('worksite1');
      when(mockWorksite1.ownerId).thenReturn('user123');
      when(mockWorksite1.dateUpdated)
          .thenReturn(DateTime.parse('2022-01-01T00:00:00Z'));

      final mockWorksite2 = MockWorksite();
      when(mockWorksite2.id).thenReturn('worksite2');
      when(mockWorksite2.ownerId).thenReturn('user123');
      when(mockWorksite2.dateUpdated)
          .thenReturn(DateTime.parse('2022-01-02T00:00:00Z'));

      when(mockParser.fromJson(any)).thenAnswer((invocation) {
        final json = invocation.positionalArguments[0] as Map<String, dynamic>;
        if (json['id'] == 'worksite1') {
          return mockWorksite1;
        } else {
          return mockWorksite2;
        }
      });

      // Act
      final result = await worksiteCache.getUserWorksites(mockUser);

      // Assert
      expect(result, isNotNull);
      expect(result!.length, equals(2));
      expect(result, containsAll([mockWorksite1, mockWorksite2]));
      expect(result.map((e) => e.id), containsAll(['worksite1', 'worksite2']));
    });

    test('getUserWorksites gets worksites from cache when already loaded',
        () async {
      // Arrange
      when(mockUser.id).thenReturn('user123');
      when(mockUser.companyId).thenReturn('company456');

      // Set _haveLoadedUserWorksites to true
      worksiteCache.overrideHaveLoadedUserWorksites(true);

      final mockWorksite1 = MockWorksite();
      when(mockWorksite1.id).thenReturn('worksite1');
      when(mockWorksite1.ownerId).thenReturn('user123');
      when(mockWorksite1.dateUpdated)
          .thenReturn(DateTime.parse('2022-01-01T00:00:00Z'));

      final mockWorksite2 = MockWorksite();
      when(mockWorksite2.id).thenReturn('worksite2');
      when(mockWorksite2.ownerId).thenReturn('user123');
      when(mockWorksite2.dateUpdated)
          .thenReturn(DateTime.parse('2022-01-02T00:00:00Z'));

      final cachedWorksites = [mockWorksite1, mockWorksite2];

      // Mock getAll to return cached worksites
      final MockWorksiteCache mockWorksiteCache = MockWorksiteCache();
      when(mockWorksiteCache.getAll(any))
          .thenAnswer((invocation) async => cachedWorksites);
      when(mockWorksiteCache.getAll(any))
          .thenAnswer((_) async => cachedWorksites);

      // Act
      final result = await worksiteCache.getUserWorksites(mockUser);

      // Assert
      expect(result, isNotNull);
      expect(result!.length, equals(2));
      expect(result, containsAll([mockWorksite1, mockWorksite2]));
      expect(result.map((e) => e.id), containsAll(['worksite1', 'worksite2']));
    });

    test('getUserWorksites handles exception when loading worksites', () async {
      // Arrange
      when(mockUser.id).thenReturn('user123');
      when(mockUser.companyId).thenReturn('company456');

      final apiPath =
          '$API_WorksiteUserVisiblePath/${mockUser.companyId}/${mockUser.id}';

      when(mockDataConnectionService.get(apiPath))
          .thenThrow(Exception('Network error'));

      // Act
      expect(
        () => worksiteCache.getUserWorksites(mockUser),
        throwsA(isA<Exception>()
            .having((e) => e.toString(), 'message', contains('Network error'))),
      );
    });
  });
}
