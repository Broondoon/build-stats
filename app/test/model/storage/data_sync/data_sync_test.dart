// data_sync_test.dart

import 'dart:collection';

import 'package:build_stats_flutter/model/storage/data_sync/data_sync.dart';
import 'package:build_stats_flutter/model/storage/unit_cache.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import '../../../mocks.dart';
import 'data_sync_test.mocks.dart';

// Import the classes under test and their dependencies
@GenerateMocks([UnitCache])
void main() {
  group('DataSync', () {
    provideDummy<HashMap<String, String>>(HashMap<String, String>());

    late DataSync dataSync;
    late MockWorksiteCache mockWorksiteCache;
    late MockChecklistCache mockChecklistCache;
    late MockChecklistDayCache mockChecklistDayCache;
    late MockItemCache mockItemCache;
    late MockUser mockUser;
    late MockUnitCache mockUnitCache;

    setUp(() {
      mockWorksiteCache = MockWorksiteCache();
      mockChecklistCache = MockChecklistCache();
      mockChecklistDayCache = MockChecklistDayCache();
      mockItemCache = MockItemCache();
      mockUser = MockUser();
      mockUnitCache = MockUnitCache();


      dataSync = DataSync(
        mockWorksiteCache,
        mockChecklistCache,
        mockChecklistDayCache,
        mockItemCache,
        mockUnitCache,
        null
      );
    });

    test('checkCacheSync completes successfully with correct calls', () async {
      // Arrange
      when(mockUser.id).thenReturn('user123');
      when(mockUser.companyId).thenReturn('company456');

      final HashMap<String, String> checklistCacheStates =
          HashMap.from({'checklist1': 'checksum1'});
      final HashMap<String, String> checklistDayCacheStates =
          HashMap.from({'checklistDay1': 'checksum2'});
      final HashMap<String, String> itemCacheStates =
          HashMap.from({'item1': 'checksum3'});
      final HashMap<String, String> worksiteCacheStates =
          HashMap.from({'worksite1': 'checksum4'});

      when(mockChecklistCache.getCacheCheckStates())
          .thenAnswer((_) async => checklistCacheStates);
      when(mockChecklistDayCache.getCacheCheckStates())
          .thenAnswer((_) async => checklistDayCacheStates);
      when(mockItemCache.getCacheCheckStates())
          .thenAnswer((_) async => itemCacheStates);
      when(mockWorksiteCache.getCacheCheckStates())
          .thenAnswer((_) async => worksiteCacheStates);

      // Act
      await dataSync.checkCacheSync(mockUser);

      // Assert
      // Verify that getCacheCheckStates was called
      verify(mockChecklistCache.getCacheCheckStates())
          .called(2); // called twice
      verify(mockChecklistDayCache.getCacheCheckStates()).called(2);
      verify(mockItemCache.getCacheCheckStates()).called(2);
      verify(mockWorksiteCache.getCacheCheckStates()).called(1); // called once

      // Verify that setCacheSyncFlags was called with correct arguments
      verify(mockWorksiteCache.setCacheSyncFlags(worksiteCacheStates))
          .called(1);
      verify(mockChecklistCache.setCacheSyncFlags(checklistCacheStates))
          .called(1);
      verify(mockChecklistDayCache.setCacheSyncFlags(checklistDayCacheStates))
          .called(1);
      verify(mockItemCache.setCacheSyncFlags(itemCacheStates)).called(1);
    });

    test('checkCacheSync handles exceptions from getCacheCheckStates',
        () async {
      // Arrange
      when(mockUser.id).thenReturn('user123');
      when(mockUser.companyId).thenReturn('company456');

      when(mockChecklistCache.getCacheCheckStates())
          .thenThrow(Exception('Test exception'));

      // Act & Assert
      expect(() => dataSync.checkCacheSync(mockUser), throwsException);

      // Verify that getCacheCheckStates was called
      verify(mockChecklistCache.getCacheCheckStates()).called(1);

      // Verify that setCacheSyncFlags was not called
      verifyNever(mockChecklistCache.setCacheSyncFlags(any));
    });

//     test('checkCacheSync continues if some caches return empty states',
//         () async {
//       // Arrange
//       when(mockUser.id).thenReturn('user123');
//       when(mockUser.companyId).thenReturn('company456');

//       when(mockChecklistCache.getCacheCheckStates())
//     .thenAnswer((_) async => HashMap<String, String>());
// when(mockChecklistDayCache.getCacheCheckStates())
//     .thenAnswer((_) async => HashMap<String, String>());
// when(mockItemCache.getCacheCheckStates())
//     .thenAnswer((_) async => HashMap<String, String>());
// when(mockWorksiteCache.getCacheCheckStates())
//     .thenAnswer((_) async => HashMap<String, String>());

//       // Act
//       await dataSync.checkCacheSync(mockUser);

//       // Assert
//       // Verify that getCacheCheckStates was called
//       verify(mockChecklistCache.getCacheCheckStates()).called(2);
//       verify(mockChecklistDayCache.getCacheCheckStates()).called(2);
//       verify(mockItemCache.getCacheCheckStates()).called(2);
//       verify(mockWorksiteCache.getCacheCheckStates()).called(1);

//       // Verify that setCacheSyncFlags was called with empty maps
//       verify(mockWorksiteCache
//               .setCacheSyncFlags({} as HashMap<String, String>?))
//           .called(1);
//       verify(mockChecklistCache
//               .setCacheSyncFlags({} as HashMap<String, String>?))
//           .called(1);
//       verify(mockChecklistDayCache
//               .setCacheSyncFlags({} as HashMap<String, String>?))
//           .called(1);
//       verify(mockItemCache.setCacheSyncFlags({} as HashMap<String, String>?))
//           .called(1);
//     });
  });
}
