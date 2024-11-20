// change_manager_test.dart

import 'dart:collection';
import 'dart:convert';

import 'package:build_stats_flutter/model/Domain/change_manager.dart';
import 'package:build_stats_flutter/model/entity/checklist.dart';
import 'package:build_stats_flutter/model/entity/item.dart';
import 'package:build_stats_flutter/model/entity/worksite.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import '../../mocks.dart';

// Import the classes under test and their dependencies
// Adjust the imports according to your project structure
import 'package:shared/app_strings.dart';

// @GenerateMocks([
//   WorksiteCache,
//   ChecklistCache,
//   ChecklistDayCache,
//   ItemCache,
//   Worksite,
//   Checklist,
//   ChecklistDay,
//   Item,
//   User,
//   ChecklistDayFactory,
//   JsonFileAccess,
//   ChecklistFactory,
//   ItemFactory,
//   WorksiteFactory,
// ])
void main() {
  group('ChangeManager', () {
    provideDummy<HashMap<String, String>>(HashMap<String, String>());
    provideDummy<HashMap<String, List<String>>>(
        HashMap<String, List<String>>());
    late ChangeManager changeManager;
    late MockDataConnectionService<Worksite> mockWorksiteDataConnectionService;
    late MockDataConnectionService<Checklist>
        mockChecklistDataConnectionService;
    late MockDataConnectionService<ChecklistDay>
        mockChecklistDayDataConnectionService;
    late MockDataConnectionService<Item> mockItemDataConnectionService;
    late MockWorksiteCache mockWorksiteCache;
    late MockChecklistCache mockChecklistCache;
    late MockChecklistDayCache mockChecklistDayCache;
    late MockItemCache mockItemCache;
    late MockFileIOService<Worksite> mockWorksiteFileIOService;
    late MockFileIOService<Checklist> mockChecklistFileIOService;
    late MockFileIOService<ChecklistDay> mockChecklistDayFileIOService;
    late MockFileIOService<Item> mockItemFileIOService;
    late MockEntityFactory<Worksite> mockWorksiteFactory;
    late MockEntityFactory<Checklist> mockChecklistFactory;
    late MockEntityFactory<ChecklistDay> mockChecklistDayFactory;
    late MockEntityFactory<Item> mockItemFactory;
    late MockUser mockUser;

    setUp(() {
      mockWorksiteDataConnectionService = MockDataConnectionService<Worksite>();
      mockChecklistDataConnectionService =
          MockDataConnectionService<Checklist>();
      mockChecklistDayDataConnectionService =
          MockDataConnectionService<ChecklistDay>();
      mockItemDataConnectionService = MockDataConnectionService<Item>();

      mockWorksiteCache = MockWorksiteCache();
      when(mockWorksiteCache.store(any, any)).thenAnswer((_) async {
        return _.positionalArguments[1] as Worksite;
      });
      mockChecklistCache = MockChecklistCache();
      when(mockChecklistCache.store(any, any)).thenAnswer((_) async {
        return _.positionalArguments[1] as Checklist;
      });
      mockChecklistDayCache = MockChecklistDayCache();
      when(mockChecklistDayCache.store(any, any)).thenAnswer((_) async {
        return _.positionalArguments[1] as ChecklistDay;
      });
      mockItemCache = MockItemCache();
      when(mockItemCache.store(any, any)).thenAnswer((_) async {
        return _.positionalArguments[1] as Item;
      });

      mockWorksiteFileIOService = MockFileIOService<Worksite>();
      when(mockWorksiteFileIOService.deleteFromDataFile(any, any))
          .thenAnswer((_) async => true);
      when(mockWorksiteFileIOService.saveDataFile(any, any))
          .thenAnswer((_) async => true);
      mockChecklistFileIOService = MockFileIOService<Checklist>();
      when(mockChecklistFileIOService.deleteFromDataFile(any, any))
          .thenAnswer((_) async => true);
      when(mockChecklistFileIOService.saveDataFile(any, any))
          .thenAnswer((_) async => true);
      mockChecklistDayFileIOService = MockFileIOService<ChecklistDay>();
      when(mockChecklistDayFileIOService.deleteFromDataFile(any, any))
          .thenAnswer((_) async => true);
      when(mockChecklistDayFileIOService.saveDataFile(any, any))
          .thenAnswer((_) async => true);
      mockItemFileIOService = MockFileIOService<Item>();
      when(mockItemFileIOService.deleteFromDataFile(any, any))
          .thenAnswer((_) async => true);
      when(mockItemFileIOService.saveDataFile(any, any))
          .thenAnswer((_) async => true);

      mockWorksiteFactory = MockEntityFactory<Worksite>();
      mockChecklistFactory = MockEntityFactory<Checklist>();
      mockChecklistDayFactory = MockEntityFactory<ChecklistDay>();
      mockItemFactory = MockEntityFactory<Item>();

      mockUser = MockUser();

      changeManager = ChangeManager(
        mockWorksiteDataConnectionService,
        mockChecklistDataConnectionService,
        mockChecklistDayDataConnectionService,
        mockItemDataConnectionService,
        mockWorksiteCache,
        mockChecklistCache,
        mockChecklistDayCache,
        mockItemCache,
        mockWorksiteFileIOService,
        mockChecklistFileIOService,
        mockChecklistDayFileIOService,
        mockItemFileIOService,
        mockWorksiteFactory,
        mockChecklistFactory,
        mockChecklistDayFactory,
        mockItemFactory,
      );
    });

    test('getUserWorksites returns list of worksites', () async {
      // Arrange
      final userId = ID_UserPrefix + '123';
      final companyId = ID_CompanyPrefix + '456';
      when(mockUser.id).thenReturn(userId);
      when(mockUser.companyId).thenReturn(companyId);

      final worksite1 = MockWorksite();
      final worksite2 = MockWorksite();
      final worksites = [worksite1, worksite2];

      when(mockWorksiteCache.getUserWorksites(mockUser))
          .thenAnswer((_) async => worksites);

      // Act
      final result = await changeManager.getUserWorksites(mockUser);

      // Assert
      expect(result, isNotNull);
      expect(result!.length, equals(2));
      expect(result, equals(worksites));

      verify(mockWorksiteCache.getUserWorksites(mockUser)).called(1);
    });
    test('createWorksite creates and stores a new worksite', () async {
      // Arrange
      final tempIdPattern = RegExp(r'^temp_worksite_\d+$');

      when(mockWorksiteCache.store(any, any)).thenAnswer((_) async {
        return _.positionalArguments[1] as Worksite;
      });

      // Act
      final result = await changeManager.createWorksite();

      // Assert
      expect(result, isNotNull);
      expect(result.id, matches(tempIdPattern));

      verify(mockWorksiteCache.store(result.id, result)).called(1);
    });

    test('updateWorksite updates a worksite with a temporary ID', () async {
      // Arrange
      final tempId = ID_TempIDPrefix + ID_WorksitePrefix + '123456789';
      final worksite = MockWorksite();
      when(worksite.id).thenReturn(tempId);
      when(worksite.checklistIds)
          .thenReturn([ID_TempIDPrefix + ID_ChecklistPrefix + '987654321']);

      final updatedWorksiteJson = {
        'id': ID_WorksitePrefix + '123',
        'dateUpdated': '2022-01-01T00:00:00Z'
      };
      final updatedWorksite = MockWorksite();
      when(updatedWorksite.id).thenReturn(ID_WorksitePrefix + '123');
      when(updatedWorksite.dateUpdated)
          .thenReturn(DateTime.parse('2022-01-01T00:00:00Z'));
      when(mockWorksiteFactory.fromJson(updatedWorksiteJson))
          .thenReturn(updatedWorksite);

      when(mockWorksiteDataConnectionService.post(API_WorksitePath, worksite))
          .thenAnswer((_) async => jsonEncode(updatedWorksiteJson));

      final MockChecklist mockCheckList = MockChecklist();
      when(mockCheckList.id)
          .thenReturn(ID_TempIDPrefix + ID_ChecklistPrefix + '987654321');

      when(mockChecklistCache
              .getById(ID_TempIDPrefix + ID_ChecklistPrefix + '987654321'))
          .thenAnswer((_) async => mockCheckList);

      // when(mockWorksiteFileIOService.deleteFromDataFile(
      //     Dir_WorksiteFileString, [worksite.id])).thenAnswer((_) async => true);

      // when(mockWorksiteCache.store(worksite.id, updatedWorksite))
      //     .thenAnswer((_) async => updatedWorksite);

      // Act
      final result = await changeManager.updateWorksite(worksite);

      // Assert
      expect(result, equals(updatedWorksite));
      verify(mockWorksiteDataConnectionService.post(API_WorksitePath, worksite))
          .called(1);
      //verify(mockWorksiteFileIOService
      //    .deleteFromDataFile(Dir_WorksiteFileString, [worksite.id])).called(1);
      //verify(mockWorksiteCache.store(worksite.id, updatedWorksite)).called(1);
    });

    test('deleteWorksite deletes a worksite successfully', () async {
      // Arrange
      final worksite = MockWorksite();
      when(worksite.id).thenReturn(ID_WorksitePrefix + '123');
      when(worksite.checklistIds)
          .thenReturn([ID_ChecklistPrefix + '1', ID_ChecklistPrefix + '2']);

      when(mockWorksiteDataConnectionService.delete(
          API_WorksitePath, [worksite.id])).thenAnswer((_) async => null);

      when(mockChecklistCache.getById(any)).thenAnswer((invocation) async {
        final checklistId = invocation.positionalArguments[0];
        final checklist = MockChecklist();
        when(checklist.id).thenReturn(checklistId);
        when(checklist.checklistIdsByDate).thenReturn({
          '2022-01-01': ID_ChecklistDayPrefix + '1'
        } as HashMap<String, String>);
        return checklist;
      });

      when(mockChecklistDayCache.getById(any)).thenAnswer((invocation) async {
        final checklistDayId = invocation.positionalArguments[0];
        final checklistDay = MockChecklistDay();
        when(checklistDay.id).thenReturn(checklistDayId);
        when(checklistDay.itemsByCatagory).thenReturn({
          'category1': [
            ID_ChecklistDayPrefix + '1',
            ID_ChecklistDayPrefix + '2'
          ]
        } as HashMap<String, List<String>>);
        return checklistDay;
      });

      when(mockItemCache.getById(any)).thenAnswer((_) async => MockItem());

      // Act
      final result = await changeManager.deleteWorksite(worksite);

      // Assert
      expect(result, isTrue);

      verify(mockWorksiteDataConnectionService
          .delete(API_WorksitePath, [worksite.id])).called(1);
      //verify(mockWorksiteFileIOService
      //    .deleteFromDataFile(Dir_WorksiteFileString, [worksite.id])).called(1);
      //verify(mockWorksiteCache.delete(worksite.id)).called(1);
    });
    test(
        'getChecklistById returns a checklist and loads related data if not already loaded',
        () async {
      // Arrange
      final checklistId = ID_ChecklistPrefix + '123';
      final checklist = MockChecklist();
      when(checklist.id).thenReturn(checklistId);
      when(checklist.checklistIdsByDate).thenReturn({
        '2022-01-01': ID_ChecklistDayPrefix + '1'
      } as HashMap<String, String>);

      when(mockChecklistCache.getById(checklistId))
          .thenAnswer((_) async => checklist);
      when(mockChecklistDayCache.getChecklistDaysForChecklist(checklist))
          .thenAnswer((_) async => [MockChecklistDay()]);
      when(mockItemCache.loadChecklistItemsForChecklist(checklist))
          .thenAnswer((_) async => [MockItem()]);

      // Act
      final result = await changeManager.getChecklistById(checklistId);

      // Assert
      expect(result, equals(checklist));

      verify(mockChecklistCache.getById(checklistId)).called(1);
      verify(mockChecklistDayCache.getChecklistDaysForChecklist(checklist))
          .called(1);
      verify(mockItemCache.loadChecklistItemsForChecklist(checklist)).called(1);
    });
    test('createChecklist creates and stores a new checklist', () async {
      // Arrange
      final worksite = MockWorksite();
      when(worksite.id).thenReturn(ID_WorksitePrefix + '123');
      when(worksite.checklistIds).thenReturn([]);

      when(mockChecklistCache.store(any, any)).thenAnswer((_) async {
        return _.positionalArguments[1] as Checklist;
      });

      // Act
      final result = await changeManager.createChecklist(worksite);

      // Assert
      expect(result, isNotNull);
      expect(result.id, startsWith(ID_TempIDPrefix + ID_ChecklistPrefix));

      verify(mockChecklistCache.store(result.id, result)).called(1);
    });
    test('updateChecklist updates a checklist with a temporary ID', () async {
      // Arrange
      final tempChecklistId = 'temp_checklist_123456789';
      final checklist = MockChecklist();
      when(checklist.id).thenReturn(tempChecklistId);
      when(checklist.worksiteId).thenReturn(ID_WorksitePrefix + '123');
      when(checklist.checklistIdsByDate).thenReturn({
        '2022-01-01': 'temp_checklistDay_987654321'
      } as HashMap<String, String>);

      final updatedChecklistJson = {
        'id': ID_ChecklistPrefix + '123',
        'worksiteId': ID_WorksitePrefix + '123'
      };
      final updatedChecklist = MockChecklist();
      when(mockChecklistFactory.fromJson(updatedChecklistJson))
          .thenReturn(updatedChecklist);

      when(mockChecklistDataConnectionService.post(
              API_ChecklistPath, checklist))
          .thenAnswer((_) async => jsonEncode(updatedChecklistJson));

      when(mockChecklistDayCache.getById(any))
          .thenAnswer((_) async => MockChecklistDay());

      when(mockChecklistFileIOService
              .deleteFromDataFile(Dir_ChecklistFileString, [checklist.id]))
          .thenAnswer((_) async => true);

      when(mockChecklistCache.store(checklist.id, updatedChecklist))
          .thenAnswer((_) async => updatedChecklist);

      // Act
      final result = await changeManager.updateChecklist(checklist);

      // Assert
      expect(result, equals(updatedChecklist));

      verify(mockChecklistDataConnectionService.post(
              API_ChecklistPath, checklist))
          .called(1);
      verify(mockChecklistFileIOService.deleteFromDataFile(
          Dir_ChecklistFileString, [checklist.id])).called(1);
      verify(mockChecklistCache.store(checklist.id, updatedChecklist))
          .called(1);
    });

    test('deleteChecklist deletes a checklist successfully', () async {
      // Arrange
      final worksite = MockWorksite();
      when(worksite.id).thenReturn(ID_WorksitePrefix + '123');
      when(worksite.checklistIds).thenReturn([ID_ChecklistPrefix + '123']);

      final checklist = MockChecklist();
      when(checklist.id).thenReturn(ID_ChecklistPrefix + '123');
      when(checklist.checklistIdsByDate).thenReturn({
        '2022-01-01': ID_ChecklistDayPrefix + '1'
      } as HashMap<String, String>);

      when(mockChecklistDataConnectionService.delete(
          API_ChecklistPath, [checklist.id])).thenAnswer((_) async => null);

      when(mockChecklistDayCache.getById(any)).thenAnswer((invocation) async {
        final checklistDayId = invocation.positionalArguments[0];
        final checklistDay = MockChecklistDay();
        when(checklistDay.id).thenReturn(checklistDayId);
        when(checklistDay.itemsByCatagory).thenReturn({
          'category1': [ID_ItemPrefix + '1', ID_ItemPrefix + '2']
        } as HashMap<String, List<String>>);
        return checklistDay;
      });

      when(mockItemCache.getById(any)).thenAnswer((_) async => MockItem());

      // Act
      final result = await changeManager.deleteChecklist(worksite, checklist);

      // Assert
      expect(result, equals(worksite));

      verify(mockChecklistDataConnectionService
          .delete(API_ChecklistPath, [checklist.id])).called(1);
      verify(mockChecklistFileIOService.deleteFromDataFile(
          Dir_ChecklistFileString, [checklist.id])).called(1);
      verify(mockChecklistCache.delete(checklist.id)).called(1);
      verify(worksite.checklistIds?.remove(checklist.id));
    });

    test('createChecklistDay creates and stores a new checklist day', () async {
      // Arrange
      final checklist = MockChecklist();
      when(checklist.id).thenReturn(ID_ChecklistPrefix + '123');
      when(checklist.checklistIdsByDate)
          .thenReturn({} as HashMap<String, String>);

      final date = DateTime(2022, 1, 1);

      when(mockChecklistDayCache.store(any, any)).thenAnswer((_) async {
        return _.positionalArguments[1] as ChecklistDay;
      });

      // Act
      final result =
          await changeManager.createChecklistDay(checklist, null, date);

      // Assert
      expect(result, isNotNull);
      expect(result.id, equals(ID_DefaultBlankChecklistDayID));
      expect(result.date, equals(date));

      verify(mockChecklistDayCache.store(result.id, result)).called(1);
    });

    test('GetChecklistDayByDate returns existing checklist day', () async {
      // Arrange
      final checklist = MockChecklist();
      when(checklist.id).thenReturn(ID_ChecklistPrefix + '123');

      final date = DateTime(2022, 1, 1);
      final checklistDayId = ID_ChecklistDayPrefix + '123';

      when(checklist.getChecklistDayID(date))
          .thenReturn((true, checklistDayId));

      final checklistDay = MockChecklistDay();
      when(mockChecklistDayCache.getById(checklistDayId))
          .thenAnswer((_) async => checklistDay);

      // Act
      final result = await changeManager.GetChecklistDayByDate(date, checklist);

      // Assert
      expect(result, equals(checklistDay));

      verify(mockChecklistDayCache.getById(checklistDayId)).called(1);
    });

    test(
        'GetChecklistDayByDate creates a new checklist day when it does not exist',
        () async {
      // Arrange
      final checklist = MockChecklist();
      when(checklist.id).thenReturn(ID_ChecklistPrefix + '123');

      final date = DateTime(2022, 1, 2);

      when(checklist.getChecklistDayID(date)).thenReturn((false, null));

      when(mockChecklistDayCache.store(any, any)).thenAnswer((_) async {
        return _.positionalArguments[1] as ChecklistDay;
      });

      // Act
      final result = await changeManager.GetChecklistDayByDate(date, checklist);

      // Assert
      expect(result, isNotNull);
      expect(result.id, equals(ID_DefaultBlankChecklistDayID));
      expect(result.date, equals(date));

      verify(mockChecklistDayCache.store(result.id, result)).called(1);
    });

    test('updateChecklistDay updates a checklist day with a temporary ID',
        () async {
      // Arrange
      final tempChecklistDayId =
          ID_TempIDPrefix + ID_ChecklistDayPrefix + '123456789';
      final checklistDay = MockChecklistDay();
      when(checklistDay.id).thenReturn(tempChecklistDayId);
      when(checklistDay.checklistId).thenReturn(ID_ChecklistPrefix + '123');
      when(checklistDay.date).thenReturn(DateTime(2022, 1, 1));
      when(checklistDay.itemsByCatagory).thenReturn({
        'category1': [ID_TempIDPrefix + ID_ItemPrefix + '987654321']
      } as HashMap<String, List<String>>);

      final checklist = MockChecklist();
      when(mockChecklistCache.getById(ID_ChecklistPrefix + '123'))
          .thenAnswer((_) async => checklist);
      when(checklist.id).thenReturn(ID_ChecklistPrefix + '123');
      when(checklist.id.startsWith(ID_TempIDPrefix)).thenReturn(false);

      final updatedChecklistDayJson = {
        'id': ID_ChecklistDayPrefix + '123',
        'checklistId': ID_ChecklistPrefix + '123'
      };
      final updatedChecklistDay = MockChecklistDay();
      when(mockChecklistDayFactory.fromJson(updatedChecklistDayJson))
          .thenReturn(updatedChecklistDay);

      when(mockChecklistDayDataConnectionService.post(
              API_ChecklistDayPath, checklistDay))
          .thenAnswer((_) async => jsonEncode(updatedChecklistDayJson));

      when(mockItemCache.getById(any)).thenAnswer((_) async => MockItem());

      when(mockChecklistDayCache.store(checklistDay.id, updatedChecklistDay))
          .thenAnswer((_) async => updatedChecklistDay);

      // Act
      final result = await changeManager.updateChecklistDay(
          checklistDay, checklistDay.date);

      // Assert
      expect(result, equals(updatedChecklistDay));

      verify(mockChecklistDayDataConnectionService.post(
              API_ChecklistDayPath, checklistDay))
          .called(1);
      verify(mockChecklistDayCache.store(checklistDay.id, updatedChecklistDay))
          .called(1);
    });

    test('createItem creates and stores a new item', () async {
      // Arrange
      final checklistDay = MockChecklistDay();
      when(checklistDay.id).thenReturn(ID_ChecklistDayPrefix + '123');
      when(checklistDay.checklistId).thenReturn(ID_ChecklistPrefix + '123');

      final category = 'category1';

      when(mockItemCache.store(any, any)).thenAnswer((_) async {
        return _.positionalArguments[1] as Item;
      });

      // Act
      final result = await changeManager.createItem(checklistDay, category);

      // Assert
      expect(result, isNotNull);
      expect(result.id, startsWith(ID_TempIDPrefix + ID_ItemPrefix));
      expect(result.checklistDayId, equals(ID_ChecklistPrefix + '123'));

      verify(mockItemCache.store(result.id, result)).called(1);
    });

    test('updateItem updates an item with a temporary ID', () async {
      // Arrange
      final tempItemId = ID_TempIDPrefix + ID_ItemPrefix + '123456789';
      final item = MockItem();
      when(item.id).thenReturn(tempItemId);
      when(item.checklistDayId).thenReturn(ID_ChecklistDayPrefix + '123');
      when(item.desc).thenReturn('Item Description');
      when(item.unit).thenReturn('Unit');
      when(item.getChecksum()).thenReturn('checksum1');

      final checklistDay = MockChecklistDay();
      when(checklistDay.id).thenReturn(ID_ChecklistDayPrefix + '123');
      when(checklistDay.date).thenReturn(DateTime(2022, 1, 1));
      when(checklistDay.itemsByCatagory).thenReturn({
        'category1': [tempItemId]
      } as HashMap<String, List<String>>);
      when(checklistDay.id.startsWith(ID_TempIDPrefix)).thenReturn(false);

      final updatedItemJson = {
        'id': ID_ItemPrefix + '123',
        'checklistDayId': ID_ChecklistDayPrefix + '123'
      };
      final updatedItem = MockItem();
      when(mockItemFactory.fromJson(updatedItemJson)).thenReturn(updatedItem);

      when(mockItemDataConnectionService.post(API_ItemPath, item))
          .thenAnswer((_) async => jsonEncode(updatedItemJson));

      when(mockItemCache.store(item.id, updatedItem))
          .thenAnswer((_) async => updatedItem);

      // Act
      final result =
          await changeManager.updateItem(item, checklistDay, checklistDay.date);

      // Assert
      expect(result, equals(updatedItem));

      verify(mockItemDataConnectionService.post(API_ItemPath, item)).called(1);
      verify(mockItemCache.store(item.id, updatedItem)).called(1);
    });

    test('deleteItem deletes an item successfully', () async {
      // Arrange
      final item = MockItem();
      when(item.id).thenReturn(ID_ItemPrefix + '123');
      when(item.checklistDayId).thenReturn(ID_ChecklistDayPrefix + '123');

      final checklistDay = MockChecklistDay();
      when(checklistDay.id).thenReturn(ID_ChecklistDayPrefix + '123');
      when(checklistDay.date).thenReturn(DateTime(2022, 1, 1));
      when(checklistDay.itemsByCatagory).thenReturn({
        'category1': [ID_ItemPrefix + '123']
      } as HashMap<String, List<String>>);
      when(checklistDay.getCategoryForItem(item)).thenReturn('category1');

      when(mockItemDataConnectionService.delete(API_ItemPath, [item.id]))
          .thenAnswer((_) async => null);

      when(mockItemFileIOService.deleteFromDataFile(
          Dir_ItemFileString, [item.id])).thenAnswer((_) async => true);

      // Act
      final result = await changeManager.deleteItem(checklistDay, item);

      // Assert
      expect(result, equals(checklistDay));

      verify(mockItemDataConnectionService.delete(API_ItemPath, [item.id]))
          .called(1);
      verify(mockItemCache.delete(item.id)).called(1);
      verify(mockItemFileIOService
          .deleteFromDataFile(Dir_ItemFileString, [item.id])).called(1);
      verify(checklistDay.removeItem('category1', item)).called(1);
    });

    test('getItemById returns the correct item', () async {
      // Arrange
      final itemId = ID_ItemPrefix + '123';
      final item = MockItem();
      when(item.id).thenReturn(itemId);

      when(mockItemCache.getById(itemId)).thenAnswer((_) async => item);

      // Act
      final result = await changeManager.getItemById(itemId);

      // Assert
      expect(result, equals(item));
      verify(mockItemCache.getById(itemId)).called(1);
    });
    test('createItemFromItem creates a new item based on an existing item',
        () async {
      // Arrange
      final existingItem = MockItem();
      when(existingItem.checklistDayId)
          .thenReturn(ID_ChecklistDayPrefix + '123');
      when(existingItem.unit).thenReturn('Unit');
      when(existingItem.desc).thenReturn('Description');
      when(existingItem.result).thenReturn('Result');
      when(existingItem.comment).thenReturn('Comment');
      when(existingItem.creatorId).thenReturn('creator123');
      when(existingItem.verified).thenReturn(true);

      // Act
      final result = await changeManager.createItemFromItem(existingItem);

      // Assert
      expect(result, isNotNull);
      expect(result.id, startsWith(ID_TempIDPrefix + ID_ItemPrefix));
      expect(result.checklistDayId, equals(ID_ChecklistDayPrefix + '123'));
      expect(result.unit, equals('Unit'));
      expect(result.desc, equals('Description'));
      expect(result.result, equals('Result'));
      expect(result.comment, equals('Comment'));
      expect(result.creatorId, equals(ID_UserPrefix + '123'));
      expect(result.verified, equals(true));
    });
    test('addCategory adds a new category to the checklist day', () async {
      // Arrange
      final checklistDay = MockChecklistDay();
      when(checklistDay.id).thenReturn(ID_ChecklistDayPrefix + '123');
      when(checklistDay.addCategory(any)).thenReturn(null);

      // Act
      await changeManager.addCategory(checklistDay, 'New Category');

      // Assert
      verify(checklistDay.addCategory('New Category')).called(1);
      verify(mockChecklistDayCache.store(checklistDay.id, checklistDay))
          .called(1);
    });
    test('editCategory renames a category in the checklist day', () async {
      // Arrange
      final checklistDay = MockChecklistDay();
      when(checklistDay.id).thenReturn(ID_ChecklistDayPrefix + '123');
      when(checklistDay.itemsByCatagory).thenReturn({
        'Old Category': [MockItem().id],
      } as HashMap<String, List<String>>);
      when(checklistDay.addCategory(any)).thenReturn(null);
      when(checklistDay.removeCategory(any)).thenReturn(null);
      when(checklistDay.getItemsByCategory('Old Category'))
          .thenReturn([MockItem()]);

      final date = DateTime(2022, 1, 1);

      // Act
      await changeManager.editCategory(
          checklistDay, date, 'Old Category', 'New Category');

      // Assert
      verify(checklistDay.addCategory('New Category')).called(1);
      verify(checklistDay.getItemsByCategory('Old Category')).called(1);
      verify(checklistDay.removeCategory('Old Category')).called(1);

      if (checklistDay.id.startsWith(ID_TempIDPrefix)) {
        verify(mockChecklistDayCache.store(checklistDay.id, checklistDay))
            .called(1);
      } else {
        verify(mockChecklistDayDataConnectionService.put(
                API_ChecklistDayPath, checklistDay))
            .called(1);
      }
    });
    test('removeCategory removes a category from the checklist day', () async {
      // Arrange
      final checklistDay = MockChecklistDay();
      when(checklistDay.id).thenReturn(ID_ChecklistDayPrefix + '123');
      when(checklistDay.removeCategory(any)).thenReturn(null);

      final date = DateTime(2022, 1, 1);

      // Act
      await changeManager.removeCategory(
          checklistDay, date, 'Category To Remove');

      // Assert
      verify(checklistDay.removeCategory('Category To Remove')).called(1);

      if (checklistDay.id.startsWith(ID_TempIDPrefix)) {
        verify(mockChecklistDayCache.store(checklistDay.id, checklistDay))
            .called(1);
      } else {
        verify(mockChecklistDayDataConnectionService.put(
                API_ChecklistDayPath, checklistDay))
            .called(1);
      }
    });
  });
}
