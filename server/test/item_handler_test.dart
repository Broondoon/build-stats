import 'dart:convert';

import 'package:Server/handlers/item_handler.dart';
import 'package:Server/storage/checklist_cache.dart';
import 'package:injector/injector.dart';
import 'package:test/test.dart';
import 'package:mockito/mockito.dart';

//Generate mocks for the dependencies
// @GenerateMocks([
//   ItemCache,
//   ItemFactory,
//   Item,
// ])
import 'mocks.dart';

void main() {
  group('ItemHandler', () {
    late MockItemCache mockItemCache;
    late MockItemFactory mockItemFactory;
    late MockChecklistDayCache mockChecklistDayCache;
    late ItemHandler itemHandler;
    late MockRequest request;

    setUp(() {
      mockItemCache = MockItemCache();
      mockItemFactory = MockItemFactory();
      mockChecklistDayCache = MockChecklistDayCache();

      // Set up the Injector to return our mock ChecklistDayCache
      final injector = Injector.appInstance;
      injector
          .registerSingleton<ChecklistDayCache>(() => mockChecklistDayCache);

      itemHandler = ItemHandler(mockItemCache, mockItemFactory);
    });

    tearDown(() {
      // Clear mappings in the Injector after each test
      Injector.appInstance.clearAll();
    });

    test('handleGetItemsOnChecklistDay returns items when found', () async {
      // Arrange
      request = MockRequest();
      final checklistDayId = 'checklistDay123';

      final mockItem1 = MockItem();
      final mockItem2 = MockItem();

      when(mockItem1.checklistDayId).thenReturn(checklistDayId);
      when(mockItem1.toJsonTransfer()).thenReturn({'id': 'item1'});

      when(mockItem2.checklistDayId).thenReturn(checklistDayId);
      when(mockItem2.toJsonTransfer()).thenReturn({'id': 'item2'});

      // Simulate getAll returning a list of items
      when(mockItemCache.getAll(any))
          .thenAnswer((_) async => [mockItem1, mockItem2]);

      // Act
      final response = await itemHandler.handleGetItemsOnChecklistDay(
          request, checklistDayId);

      // Assert
      expect(response.statusCode, equals(200));
      expect(response.headers['content-type'], contains('application/json'));

      final body = await response.readAsString();
      final decodedBody = jsonDecode(body) as List<dynamic>;

      expect(decodedBody.length, equals(2));
      expect(
          decodedBody,
          containsAll([
            {'id': 'item1'},
            {'id': 'item2'}
          ]));
    });

    test('handleGetItemsOnChecklistDay returns 404 when no items found',
        () async {
      // Arrange
      request = MockRequest();
      final checklistDayId = 'checklistDay123';

      // Simulate getAll returning an empty list
      when(mockItemCache.getAll(any)).thenAnswer((_) async => []);

      // Act
      final response = await itemHandler.handleGetItemsOnChecklistDay(
          request, checklistDayId);

      // Assert
      expect(response.statusCode, equals(404));
      final body = await response.readAsString();
      expect(body, equals('No items found'));
    });

    test('handleGetItemsOnChecklistDay handles exceptions gracefully',
        () async {
      // Arrange
      request = MockRequest();
      final checklistDayId = 'checklistDay123';

      // Simulate an exception thrown by getAll
      when(mockItemCache.getAll(any)).thenThrow(Exception('Test exception'));

      // Act
      final response = await itemHandler.handleGetItemsOnChecklistDay(
          request, checklistDayId);

      // Assert
      expect(response.statusCode, equals(500));
      final body = await response.readAsString();
      expect(body, contains('Exception: Test exception'));
    });

    test('handleGetItemsOnChecklist returns items when found', () async {
      // Arrange
      request = MockRequest();
      final checklistId = 'checklist123';

      final mockChecklistDay1 = MockChecklistDay();
      final mockChecklistDay2 = MockChecklistDay();

      when(mockChecklistDay1.id).thenReturn('checklistDay1');
      when(mockChecklistDay1.checklistId).thenReturn(checklistId);

      when(mockChecklistDay2.id).thenReturn('checklistDay2');
      when(mockChecklistDay2.checklistId).thenReturn(checklistId);

      // Simulate getAll returning a list of checklist days
      when(mockChecklistDayCache.getAll(any))
          .thenAnswer((_) async => [mockChecklistDay1, mockChecklistDay2]);

      final mockItem1 = MockItem();
      final mockItem2 = MockItem();
      final mockItem3 = MockItem();

      when(mockItem1.checklistDayId).thenReturn('checklistDay1');
      when(mockItem1.toJsonTransfer()).thenReturn({'id': 'item1'});

      when(mockItem2.checklistDayId).thenReturn('checklistDay2');
      when(mockItem2.toJsonTransfer()).thenReturn({'id': 'item2'});

      when(mockItem3.checklistDayId).thenReturn('otherChecklistDay');
      when(mockItem3.toJsonTransfer()).thenReturn({'id': 'item3'});

      // Simulate getAll returning a list of items
      when(mockItemCache.getAll(any))
          .thenAnswer((_) async => [mockItem1, mockItem2, mockItem3]);

      // Act
      final response =
          await itemHandler.handleGetItemsOnChecklist(request, checklistId);

      // Assert
      expect(response.statusCode, equals(200));
      expect(response.headers['content-type'], contains('application/json'));

      final body = await response.readAsString();
      final decodedBody = jsonDecode(body) as List<dynamic>;

      expect(decodedBody.length, equals(2));
      expect(
          decodedBody,
          containsAll([
            {'id': 'item1'},
            {'id': 'item2'}
          ]));
      expect(decodedBody, isNot(contains({'id': 'item3'})));
    });

    test('handleGetItemsOnChecklist returns 404 when no items found', () async {
      // Arrange
      request = MockRequest();
      final checklistId = 'checklist123';

      // Simulate getAll returning empty lists
      when(mockChecklistDayCache.getAll(any)).thenAnswer((_) async => []);
      when(mockItemCache.getAll(any)).thenAnswer((_) async => []);

      // Act
      final response =
          await itemHandler.handleGetItemsOnChecklist(request, checklistId);

      // Assert
      expect(response.statusCode, equals(404));
      final body = await response.readAsString();
      expect(body, equals('No items found'));
    });

    test('handleGetItemsOnChecklist handles exceptions gracefully', () async {
      // Arrange
      request = MockRequest();
      final checklistId = 'checklist123';

      // Simulate an exception thrown by getAll
      when(mockChecklistDayCache.getAll(any))
          .thenThrow(Exception('Test exception'));

      // Act
      final response =
          await itemHandler.handleGetItemsOnChecklist(request, checklistId);

      // Assert
      expect(response.statusCode, equals(500));
      final body = await response.readAsString();
      expect(body, contains('Exception: Test exception'));
    });
  });
}
