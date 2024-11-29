// cache_service_test.dart

import 'dart:async';
import 'dart:collection';
import 'dart:convert';
import 'package:build_stats_flutter/model/Domain/Exception/http_exception.dart';
import 'package:build_stats_flutter/model/Domain/Service/cache_service.dart';
import 'package:build_stats_flutter/model/Domain/Service/data_connection_service.dart';
import 'package:build_stats_flutter/model/Domain/Service/file_IO_service.dart';
import 'package:build_stats_flutter/resources/app_enums.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:mutex/mutex.dart';
import 'package:shared/entity.dart';
import 'package:shared/cache.dart';

import '../../../mocks.dart';

/// A concrete implementation of Entity for testing purposes.
class TestEntity extends Entity {
  final String id;
  final DateTime dateUpdated;

  TestEntity(
      {required this.id,
      required this.dateUpdated,
      bool flagForDeletion = false})
      : super(
            id: id,
            dateCreated: dateUpdated,
            dateUpdated: dateUpdated,
            flagForDeletion: flagForDeletion);

  @override
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'dateUpdated': dateUpdated.toIso8601String(),
    };
  }

  static TestEntity fromJson(Map<String, dynamic> json) {
    return TestEntity(
      id: json['id'] as String,
      dateUpdated: DateTime.parse(json['dateUpdated'] as String),
    );
  }
}

/// A factory for creating TestEntity instances from JSON.
class TestEntityFactory extends EntityFactory<TestEntity> {
  @override
  TestEntity fromJson(Map<String, dynamic> json) {
    return TestEntity.fromJson(json);
  }
}

/// A subclass of CacheService that exposes protected methods for testing.
class TestCacheService<T extends Entity> extends CacheService<T> {
  TestCacheService(
    DataConnectionService<T> dataConnectionService,
    FileIOService<T> fileIOService,
    EntityFactory<T> parser,
    String apiPath,
    String filePath,
    LocalStorage cacheLocalStorage,
    ReadWriteMutex m,
  ) : super(
          dataConnectionService,
          fileIOService,
          parser,
          apiPath,
          filePath,
          cacheLocalStorage,
          m,
          "",
        );

  @override
  Future<T> storeUnprotected(String key, T value) {
    return super.storeUnprotected(key, value);
  }

  @override
  Future<void> deleteUnprotected(String key) {
    return super.deleteUnprotected(key);
  }
}

void main() {
  group('CacheService', () {
    late TestCacheService<TestEntity> cacheService;
    late MockDataConnectionService<TestEntity> mockDataConnectionService;
    late MockFileIOService<TestEntity> mockFileIOService;
    late TestEntityFactory testEntityFactory;
    late MockLocalStorage mockLocalStorage;
    late ReadWriteMutex mutex;

    setUp(() {
      mockDataConnectionService = MockDataConnectionService<TestEntity>();
      mockFileIOService = MockFileIOService<TestEntity>();
      mockLocalStorage = MockLocalStorage();
      testEntityFactory = TestEntityFactory();
      mutex = ReadWriteMutex();

      cacheService = TestCacheService<TestEntity>(
        mockDataConnectionService,
        mockFileIOService,
        testEntityFactory,
        'api/path',
        'file/path',
        mockLocalStorage,
        mutex,
      );
    });

    test('getById returns entity when present locally and on server', () async {
      // Arrange
      final key = 'entity1';
      final entityServer = TestEntity(
        id: key,
        dateUpdated: DateTime.now().subtract(Duration(days: 1)),
      );
      final entityLocal = TestEntity(
        id: key,
        dateUpdated: DateTime.now(),
      );

      when(mockDataConnectionService.get('api/path/$key'))
          .thenAnswer((_) async => jsonEncode(entityServer.toJson()));

      when(mockFileIOService.readDataFileByKey('file/path', key))
          .thenAnswer((_) async => entityLocal);

      // Act
      final result = await cacheService.getById(key);

      // Assert
      expect(result, isNotNull);
      expect(result!.id, equals(entityLocal.id));
      expect(result.dateUpdated, equals(entityLocal.dateUpdated));
    });

    test('getById returns server entity when local entity is older', () async {
      // Arrange
      final key = 'entity1';
      final entityServer = TestEntity(
        id: key,
        dateUpdated: DateTime.now(),
      );
      final entityLocal = TestEntity(
        id: key,
        dateUpdated: DateTime.now().subtract(Duration(days: 1)),
      );

      when(mockDataConnectionService.get('api/path/$key'))
          .thenAnswer((_) async => jsonEncode(entityServer.toJson()));

      when(mockFileIOService.readDataFileByKey('file/path', key))
          .thenAnswer((_) async => entityLocal);

      // Act
      final result = await cacheService.getById(key);

      // Assert
      expect(result, isNotNull);
      expect(result!.id, equals(entityServer.id));
      expect(result.dateUpdated, equals(entityServer.dateUpdated));
    });

    // test('getById returns local entity when server entity not found', () async {
    //   // Arrange
    //   final key = 'entity1';
    //   final entityLocal = TestEntity(
    //     id: key,
    //     dateUpdated: DateTime.now(),
    //   );

    //   when(mockDataConnectionService.get('api/path/$key')).thenThrow(
    //     HttpException(HttpResponse.NotFound.code, 'Not Found'),
    //   );

    //   when(mockFileIOService.readDataFileByKey('file/path', key))
    //       .thenAnswer((_) async => entityLocal);

    //   // Act
    //   final result = await cacheService.getById(key);

    //   // Assert
    //   expect(result, isNotNull);
    //   expect(result!.id, equals(entityLocal.id));
    //   expect(result.dateUpdated, equals(entityLocal.dateUpdated));
    // });

    test('getById returns null when entity not found locally or on server',
        () async {
      // Arrange
      final key = 'entity1';

      when(mockDataConnectionService.get('api/path/$key')).thenThrow(
        HttpException(HttpResponse.NotFound.code, 'Not Found'),
      );

      when(mockFileIOService.readDataFileByKey('file/path', key))
          .thenAnswer((_) async => null);

      // Act
      final result = await cacheService.getById(key);

      // Assert
      expect(result, isNull);
    });

    test('getById handles service unavailable exception gracefully', () async {
      // Arrange
      final key = 'entity1';
      final entityLocal = TestEntity(
        id: key,
        dateUpdated: DateTime.now(),
      );

      when(mockDataConnectionService.get('api/path/$key')).thenThrow(
        HttpException(
            HttpResponse.ServiceUnavailable.code, 'Service Unavailable'),
      );

      when(mockFileIOService.readDataFileByKey('file/path', key))
          .thenAnswer((_) async => entityLocal);

      // Act
      final result = await cacheService.getById(key);

      // Assert
      expect(result, isNotNull);
      expect(result!.id, equals(entityLocal.id));
      expect(result.dateUpdated, equals(entityLocal.dateUpdated));
    });

    test('loadById stores and returns the newer entity', () async {
      // Arrange
      final key = 'entity1';
      final entityServer = TestEntity(
        id: key,
        dateUpdated: DateTime.now().subtract(Duration(days: 1)),
      );
      final entityLocal = TestEntity(
        id: key,
        dateUpdated: DateTime.now(),
      );

      when(mockDataConnectionService.get('api/path/$key'))
          .thenAnswer((_) async => jsonEncode(entityServer.toJson()));

      when(mockFileIOService.readDataFileByKey('file/path', key))
          .thenAnswer((_) async => entityLocal);

      // Act
      final result = await cacheService.loadById(key);

      // Assert
      expect(result, isNotNull);
      expect(result!.length, equals(1));

      final loadedEntityJson = jsonDecode(result.first) as Map<String, dynamic>;
      final loadedEntity = testEntityFactory.fromJson(loadedEntityJson);

      expect(loadedEntity.id, equals(key));
      expect(loadedEntity.dateUpdated, equals(entityLocal.dateUpdated));
    });

    test('LoadBulk loads and stores entities correctly', () async {
      // Arrange
      final apiPath = 'api/path';
      final entity1 = TestEntity(
        id: 'entity1',
        dateUpdated: DateTime.now().subtract(Duration(days: 2)),
      );
      final entity2 = TestEntity(
        id: 'entity2',
        dateUpdated: DateTime.now(),
      );
      final entityLocal = TestEntity(
        id: 'entity1',
        dateUpdated: DateTime.now(),
      );

      final entitiesJsonRemote = jsonEncode([
        entity1.toJson(),
        entity2.toJson(),
      ]);

      when(mockDataConnectionService.get(apiPath))
          .thenAnswer((_) async => entitiesJsonRemote);

      when(mockFileIOService.readDataFile('file/path')).thenAnswer(
        (_) async => [entityLocal],
      );

      // Act
      final result = await cacheService.LoadBulk(apiPath, (e) => true);

      // Assert
      expect(result, isNotNull);
      expect(result!.length, equals(2));

      final loadedEntities = result.map((e) {
        final json = jsonDecode(e) as Map<String, dynamic>;
        return testEntityFactory.fromJson(json);
      }).toList();

      expect(loadedEntities.any((e) => e.id == 'entity1'), isTrue);
      expect(loadedEntities.any((e) => e.id == 'entity2'), isTrue);

      final entity1Loaded = loadedEntities.firstWhere((e) => e.id == 'entity1');
      final entity2Loaded = loadedEntities.firstWhere((e) => e.id == 'entity2');

      // entity1 should be the local version since it's newer
      expect(entity1Loaded.dateUpdated, equals(entityLocal.dateUpdated));

      // entity2 should be from the server
      expect(entity2Loaded.dateUpdated, equals(entity2.dateUpdated));
    });

    test('Set Cache Sync Flags', () async {
      // // Create and store mock entities
      // // final entity1 = MockEntity();
      // // final entity2 = MockEntity();
      // when(entity1.id).thenReturn('1');
      // when(entity2.id).thenReturn('2');
      // when(entity1.getChecksum()).thenReturn('checksum1');
      // when(entity2.getChecksum()).thenReturn('checksum2');
      // when(entity1.toJson()).thenReturn({'id': '1', 'data': 'data1'});
      // when(entity2.toJson()).thenReturn({'id': '2', 'data': 'data2'});

      final entity1 = TestEntity(
        id: 'entity1',
        dateUpdated: DateTime.now().subtract(Duration(days: 2)),
      );
      final entity2 = TestEntity(
        id: 'entity2',
        dateUpdated: DateTime.now(),
      );

      await cacheService.store(entity1.id, entity1);
      await cacheService.store(entity2.id, entity2);

      // Set cache sync flags with different checksums
      HashMap<String, String> serverCheckSums = HashMap();
      serverCheckSums[entity1.id] = 'checksum1_modified'; // Different checksum
      serverCheckSums[entity2.id] = entity2.getChecksum(); // Same checksum

      await cacheService.setCacheSyncFlags(serverCheckSums);

      // Check that cacheSyncFlags have been updated
      expect(cacheService.cacheSyncFlags[entity1.id], false);
      expect(cacheService.cacheSyncFlags[entity2.id], true);
    });

    
    test('Set Cache Sync Flags with Deleted Entity', () async {
      // Create and store a mock entity
      // final entity = MockEntity();
      // when(entity.id).thenReturn('1');
      // when(entity.getChecksum()).thenReturn('checksum1');
      // when(entity.toJson()).thenReturn({'id': '1', 'data': 'data1'});

      final entity = TestEntity(
        id: 'entity1',
        dateUpdated: DateTime.now().subtract(Duration(days: 2)),
      );

      await cacheService.store(entity.id, entity);

      // Set cache sync flags indicating the entity is deleted
      HashMap<String, String> serverCheckSums = HashMap();
      serverCheckSums[entity.id] = EntityState.deleted.toString();

      await cacheService.setCacheSyncFlags(serverCheckSums);

      // cacheCheckSums should not contain the entity
      Map<String, String> cacheCheckStates = await cacheService.getCacheCheckStates();
      expect(cacheCheckStates.containsKey(entity.id), isFalse);
    });
  });
}
