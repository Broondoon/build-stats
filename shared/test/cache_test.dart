import 'dart:collection';
import 'dart:convert';
import 'package:test/test.dart';
import 'package:mockito/mockito.dart';
import 'package:mockito/annotations.dart';
import 'package:mutex/mutex.dart';
import 'package:shared/src/base_entities/entity/entity.dart';
import 'package:shared/src/base_services/cache/cache.dart';
import 'package:shared/src/base_services/cache/localStorage.dart';

import 'mocks.dart';

@GenerateMocks([Entity, LocalStorage, EntityFactory, ReadWriteMutex])
void main() {
  late Cache<Entity> cache;
  late MockLocalStorage mockLocalStorage;
  late MockEntityFactory mockEntityFactory;
  late MockReadWriteMutex mockMutex;

  setUp(() {
    mockLocalStorage = MockLocalStorage();
    mockEntityFactory = MockEntityFactory();
    mockMutex = MockReadWriteMutex();
    cache = Cache<Entity>(mockEntityFactory, mockLocalStorage, mockMutex);
  });

  test('store and get entity', () async {
    final entity = MockEntity();
    when(entity.id).thenReturn('entity_id');
    when(entity.toJson()).thenReturn({'id': 'entity_id'});

    await cache.store(entity.id, entity);

    when(mockLocalStorage.getItem(entity.id))
        .thenAnswer((_) async => jsonEncode(entity.toJson()));

    final result = await cache.get([entity.id], (_) async => []);
    expect(result, isNotNull);
    expect(result!.length, 1);
    expect(result.first.id, entity.id);
  });

  test('getAll entities', () async {
    final entity = MockEntity();
    when(entity.id).thenReturn('entity_id');
    when(entity.toJson()).thenReturn({'id': 'entity_id'});

    await cache.store(entity.id, entity);

    when(mockLocalStorage.keys).thenReturn([entity.id]);
    when(mockLocalStorage.getItem(entity.id))
        .thenAnswer((_) async => jsonEncode(entity.toJson()));

    final result = await cache.getAll((_) async => []);
    expect(result, isNotNull);
    expect(result!.length, 1);
    expect(result.first.id, entity.id);
  });

  test('delete entity', () async {
    final entity = MockEntity();
    when(entity.id).thenReturn('entity_id');

    await cache.store(entity.id, entity);
    await cache.delete(entity.id);

    when(mockLocalStorage.getItem(entity.id)).thenAnswer((_) async => null);

    final result = await cache.get([entity.id], (_) async => []);
    expect(result, isNotNull);
    expect(result!.isEmpty, true);
  });

  test('setCacheSyncFlags', () async {
    final entity = MockEntity();
    when(entity.id).thenReturn('entity_id');

    await cache.store(entity.id, entity);

    final serverCheckSums = HashMap<String, String>();
    serverCheckSums[entity.id] = 'new_checksum';

    await cache.setCacheSyncFlags(serverCheckSums);

    expect(cache.cacheSyncFlags[entity.id], false);
  });

  test('getCacheCheckStates', () async {
    final entity = MockEntity();
    when(entity.id).thenReturn('entity_id');
    when(entity.getChecksum()).thenReturn('checksum');

    await cache.store(entity.id, entity);

    final checkStates = await cache.getCacheCheckStates();
    expect(checkStates[entity.id], entity.getChecksum());
  });
}
