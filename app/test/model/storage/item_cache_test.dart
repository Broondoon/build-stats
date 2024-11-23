// item_cache_test.dart

import 'dart:collection';
import 'dart:convert';

import 'package:build_stats_flutter/model/entity/item.dart';
import 'package:build_stats_flutter/model/storage/item_cache.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:mutex/mutex.dart';

import 'package:shared/app_strings.dart';

import '../../mocks.dart';

void main() {
  group('ItemCache', () {
    provideDummy<HashMap<String, String>>(HashMap<String, String>());
    provideDummy<HashMap<String, List<String>>>(
        HashMap<String, List<String>>());
    late ItemCache itemCache;
    late MockDataConnectionService<Item> mockDataConnectionService;
    late MockJsonFileAccess<Item> mockFileIOService;
    late MockItemFactory mockItemFactory;
    late MockLocalStorage mockLocalStorage;
    late ReadWriteMutex mutex;

    setUp(() {
      mockDataConnectionService = MockDataConnectionService<Item>();
      mockFileIOService = MockJsonFileAccess<Item>();
      mockItemFactory = MockItemFactory();
      mockLocalStorage = MockLocalStorage();
      mutex = ReadWriteMutex();

      itemCache = ItemCache(
        mockDataConnectionService,
        mockFileIOService,
        mockItemFactory,
        mockLocalStorage,
        mutex,
      );
    });

    test('loadChecklistItemsForChecklist returns items for given checklist',
        () async {
      // Arrange
      final mockChecklist = MockChecklist();
      final checklistId = 'checklist123';
      when(mockChecklist.id).thenReturn(checklistId);

      final HashMap<String, String> checklistDayIds = HashMap.from({
        '2022-01-01': 'checklistDay1',
        '2022-01-02': 'checklistDay2',
      });
      when(mockChecklist.checklistIdsByDate).thenReturn(checklistDayIds);

      final apiPath = '$API_ItemOnChecklistPath/$checklistId';

      final serverItems = [
        {
          'id': 'item1',
          'checklistDayId': 'checklistDay1',
          'dateUpdated': '2022-01-01T00:00:00Z',
        },
        {
          'id': 'item2',
          'checklistDayId': 'checklistDay2',
          'dateUpdated': '2022-01-02T00:00:00Z',
        },
      ];

      final serverItemsJson = jsonEncode(serverItems);

      when(mockDataConnectionService.get(apiPath))
          .thenAnswer((_) async => serverItemsJson);

      final localItems = [
        TestItem(
          id: 'item2',
          checklistDayId: 'checklistDay2',
          dateUpdated: DateTime.parse('2022-01-03T00:00:00Z'),
          dateCreated: DateTime.parse('2022-01-03T00:00:00Z'),
        ),
        TestItem(
          id: 'item3',
          checklistDayId: 'checklistDay3',
          dateUpdated: DateTime.parse('2022-01-01T00:00:00Z'),
          dateCreated: DateTime.parse('2022-01-01T00:00:00Z'),
        ),
      ];

      when(mockFileIOService.readDataFile(Dir_ItemFileString))
          .thenAnswer((_) async => localItems);

      when(mockItemFactory.fromJson(any)).thenAnswer((invocation) {
        final json = invocation.positionalArguments[0] as Map<String, dynamic>;
        return localItems.firstWhere((item) => item.id == json['id']);
      });

      // Act
      final result =
          await itemCache.loadChecklistItemsForChecklist(mockChecklist);

      // Assert
      expect(result, isNotNull);
      expect(result!.length, equals(2));
      expect(result.map((e) => e.id), containsAll(['item1', 'item2']));
      expect(result.map((e) => e.id), isNot(contains('item3')));

      // item2 should be from local as it's newer
      final item2 = result.firstWhere((item) => item.id == 'item2') as TestItem;
      expect(item2.dateUpdated, equals(DateTime.parse('2022-01-03T00:00:00Z')));
    });

//This isn't set up properly. We need to setup the mocks for the bulk load and get all methods.
    test('getItemsForChecklistDay returns items sorted by category', () async {
      // Arrange
      final mockChecklistDay = MockChecklistDay();
      final checklistDayId = 'checklistDay123';
      when(mockChecklistDay.id).thenReturn(checklistDayId);

      final HashMap<String, List<String>> itemsByCategory = HashMap.from({
        'Category1': ['item1', 'item2'],
        'Category2': ['item3'],
      });
      when(mockChecklistDay.itemsByCatagory).thenReturn(itemsByCategory);

      // Mock getCategoryForItem method
      when(mockChecklistDay.getCategoryForItem(any)).thenAnswer((invocation) {
        final item = invocation.positionalArguments[0] as Item;
        if (itemsByCategory['Category1']!.contains(item.id)) {
          return 'Category1';
        } else if (itemsByCategory['Category2']!.contains(item.id)) {
          return 'Category2';
        } else {
          return 'Unknown';
        }
      });

      // The keys to get are the item IDs
      final itemKeys = ['item1', 'item2', 'item3'];

      // Mock the get method in itemCache
      // Since get is a method in the superclass, we'll create a spy using a mock
      final mockItemCache = MockItemCache();

      when(mockItemCache.get(any, any)).thenAnswer((invocation) async {
        final keys = invocation.positionalArguments[0] as List<String>;
        final items = [
          TestItem(
            id: 'item1',
            checklistDayId: checklistDayId,
            dateUpdated: DateTime.now(),
            dateCreated: DateTime.now(),
          ),
          TestItem(
            id: 'item2',
            checklistDayId: checklistDayId,
            dateUpdated: DateTime.now(),
            dateCreated: DateTime.now(),
          ),
          TestItem(
            id: 'item3',
            checklistDayId: checklistDayId,
            dateUpdated: DateTime.now(),
            dateCreated: DateTime.now(),
          ),
        ];
        return items.where((item) => keys.contains(item.id)).toList();
      });

      final result = await itemCache.getItemsForChecklistDay(mockChecklistDay);

      // Assert
      expect(result.length, equals(2));
      expect(result.keys, containsAll(['Category1', 'Category2']));
      expect(result['Category1']!.map((e) => e.id),
          containsAll(['item1', 'item2']));
      expect(result['Category2']!.map((e) => e.id), contains('item3'));
    });
  });
}
