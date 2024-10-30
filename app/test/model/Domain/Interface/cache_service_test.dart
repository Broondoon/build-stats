import 'dart:collection';
import 'dart:convert';

import 'package:build_stats_flutter/model/Domain/Interface/cache_service.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import 'package:build_stats_flutter/model/Domain/Exception/http_exception.dart';
import 'package:build_stats_flutter/model/Domain/Interface/cachable.dart';
import 'package:build_stats_flutter/model/Domain/Interface/data_connection_service.dart';
import 'package:build_stats_flutter/model/Domain/Interface/file_IO_service.dart';
import 'package:build_stats_flutter/resources/app_enums.dart';
import 'package:localstorage/localstorage.dart';

import '../../../Mocks.dart';

void main() {
  group('CacheService Tests', () {
    late CacheService<Cacheable> cacheService;
    late DataConnectionService<Cacheable> mockDataConnectionService;
    late FileIOService mockFileIOService;
    late CacheableFactory<Cacheable> mockParser;
    late LocalStorage mockLocalStorage;
    late Cacheable item = MockItem();
    final String key = item.id;

    setUp(() {
      mockDataConnectionService = MockDataConnectionService<Cacheable>();
      mockFileIOService = MockJsonFileAccess<Cacheable>();
      mockParser = MockCacheableFactory<Cacheable>();
      mockLocalStorage = MockLocalStorage();

      // Initialize CacheService with mocks
      cacheService = CacheService<Cacheable>(
          mockDataConnectionService,
          mockFileIOService,
          mockParser,
          "test/apiPath",
          "test/filePath",
          mockLocalStorage);
    });
    test('store stores the item in local storage and updates cacheCheckSums',
        () async {
      // Mock item.getChecksum()
      // when(item.getChecksum()).thenReturn('checksum');

      // Call store
      await cacheService.store(key, item);
      // Verify
      expect(cacheService.cacheCheckSums[key], equals(item.getChecksum()));
      expect(cacheService.cacheSyncFlags[key], isTrue);
      verify(mockLocalStorage.setItem).called(1);
    });

    test('getById loads entity when not in local storage or sync flag is false',
        () async {
      // Call getById
      final result = await cacheService.getById(key);

      // Verify
      expect(result, isNotNull);
      expect(result!.id, equals('item1'));

      verify(mockLocalStorage.getItem(key)).called(1);
      verify(mockDataConnectionService.get).called(1);
      verify(mockParser.fromJson).called(1);
      verify(mockLocalStorage.setItem).called(1);
    });

    test('getById returns entity when in local storage and sync flag is true',
        () async {
      // Call getById
      final result = await cacheService.getById(key);

      // Verify
      expect(result, isNotNull);
      expect(result!.id, equals('item1'));

      verify(mockLocalStorage.getItem(key)).called(1);
      verifyNever(mockDataConnectionService.get);
    });

    test(
        'delete removes the item from local storage and updates cacheCheckSums',
        () async {
      final String key = 'item1';
      cacheService.cacheCheckSums[key] = 'checksum';
      cacheService.cacheSyncFlags[key] = true;

      // Call delete
      await cacheService.delete(key);

      // Verify
      expect(cacheService.cacheCheckSums.containsKey(key), isFalse);
      expect(cacheService.cacheSyncFlags.containsKey(key), isFalse);
      verify(mockLocalStorage.removeItem(key)).called(1);
    });

    test(
        'loadById returns null and deletes item if dataConnectionService returns 410',
        () async {
      // Call loadById
      final result = await cacheService.loadById(key);

      // Verify
      expect(result, isNull);
      verify(mockFileIOService.readDataFile).called(1);
      verify(mockLocalStorage.removeItem).called(1);
    });

    test(
        'setCacheSyncFlags updates cacheSyncFlags and deletes items if serverCheckSums indicate deletion',
        () async {
      final String key = 'item1';
      cacheService._cacheCheckSums[key] = 'checksum1';

      final serverCheckSums = HashMap<String, String>();
      serverCheckSums[key] = EntityState.deleted.toString();

      // Call setCacheSyncFlags
      await cacheService.setCacheSyncFlags(serverCheckSums);

      // Verify
      expect(cacheService._cacheCheckSums.containsKey(key), isFalse);
      verify(mockLocalStorage.removeItem(key)).called(1);
    });

    test('getCacheCheckStates returns current cache checksums', () async {
      final String key = 'item1';
      cacheService._cacheCheckSums[key] = 'checksum1';

      // Call getCacheCheckStates
      final result = await cacheService.getCacheCheckStates();

      // Verify
      expect(result, isA<HashMap<String, String>>());
      expect(result[key], equals('checksum1'));
    });
  });
}
