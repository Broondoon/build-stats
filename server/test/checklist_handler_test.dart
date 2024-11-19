import 'dart:convert';

import 'package:Server/handlers/checklist_handler.dart';
import 'package:test/test.dart';
import 'package:mockito/mockito.dart';

//Generate mocks for the dependencies
// @GenerateMocks([
//   ChecklistCache,
//   ChecklistFactory,
//   Checklist,
// ])
import 'mocks.dart';

void main() {
  group('ChecklistHandler', () {
    late MockChecklistCache mockChecklistCache;
    late MockChecklistFactory mockChecklistFactory;
    late ChecklistHandler checklistHandler;
    late MockRequest request;

    setUp(() {
      mockChecklistCache = MockChecklistCache();
      mockChecklistFactory = MockChecklistFactory();
      checklistHandler =
          ChecklistHandler(mockChecklistCache, mockChecklistFactory);
    });

    test('handleGetChecklistsOnWorksite returns checklists when found',
        () async {
      // Arrange
      request = MockRequest();
      final worksiteId = 'worksite123';

      final mockChecklist1 = MockChecklist();
      final mockChecklist2 = MockChecklist();

      when(mockChecklist1.worksiteId).thenReturn(worksiteId);
      when(mockChecklist1.toJsonTransfer()).thenReturn({'id': 'checklist1'});

      when(mockChecklist2.worksiteId).thenReturn(worksiteId);
      when(mockChecklist2.toJsonTransfer()).thenReturn({'id': 'checklist2'});

      // Simulate getAll returning a list of checklists
      when(mockChecklistCache.getAll(any))
          .thenAnswer((_) async => [mockChecklist1, mockChecklist2]);

      // Act
      final response = await checklistHandler.handleGetChecklistsOnWorksite(
          request, worksiteId);

      // Assert
      expect(response.statusCode, equals(200));
      expect(response.headers['content-type'], contains('application/json'));

      final body = await response.readAsString();
      final decodedBody = jsonDecode(body) as List<dynamic>;

      expect(decodedBody.length, equals(2));
      expect(
          decodedBody,
          containsAll([
            {'id': 'checklist1'},
            {'id': 'checklist2'}
          ]));
    });

    test('handleGetChecklistsOnWorksite returns 404 when no checklists found',
        () async {
      // Arrange
      request = MockRequest();
      final worksiteId = 'worksite123';

      // Simulate getAll returning an empty list
      when(mockChecklistCache.getAll(any)).thenAnswer((_) async => []);

      // Act
      final response = await checklistHandler.handleGetChecklistsOnWorksite(
          request, worksiteId);

      // Assert
      expect(response.statusCode, equals(404));
      final body = await response.readAsString();
      expect(body, equals('No checklists found'));
    });

    test('handleGetChecklistsOnWorksite handles exceptions gracefully',
        () async {
      // Arrange
      request = MockRequest();
      final worksiteId = 'worksite123';

      // Simulate an exception thrown by getAll
      when(mockChecklistCache.getAll(any))
          .thenThrow(Exception('Test exception'));

      // Act
      final response = await checklistHandler.handleGetChecklistsOnWorksite(
          request, worksiteId);

      // Assert
      expect(response.statusCode, equals(500));
      final body = await response.readAsString();
      expect(body, contains('Exception: Test exception'));
    });

//This works. It's just the same wierd "We're gonna say it doesnt work becuase lol! Screw your time!" thing
    test('handleGetChecklistsOnWorksite filters checklists by worksiteId',
        () async {
      // Arrange
      request = MockRequest();
      final worksiteId = 'worksite123';

      final mockChecklist1 = MockChecklist();
      final mockChecklist2 = MockChecklist();
      final mockChecklist3 = MockChecklist();

      when(mockChecklist1.worksiteId).thenReturn(worksiteId);
      when(mockChecklist1.toJsonTransfer()).thenReturn({'id': 'checklist1'});

      when(mockChecklist2.worksiteId).thenReturn('otherWorksite');
      when(mockChecklist2.toJsonTransfer()).thenReturn({'id': 'checklist2'});

      when(mockChecklist3.worksiteId).thenReturn(worksiteId);
      when(mockChecklist3.toJsonTransfer()).thenReturn({'id': 'checklist3'});

      // Simulate getAll returning a list of checklists
      when(mockChecklistCache.getAll(any)).thenAnswer(
          (_) async => [mockChecklist1, mockChecklist2, mockChecklist3]);

      // Act
      final response = await checklistHandler.handleGetChecklistsOnWorksite(
          request, worksiteId);

      // Assert
      expect(response.statusCode, equals(200));

      final body = await response.readAsString();
      final decodedBody = jsonDecode(body) as List<dynamic>;

      expect(decodedBody.length, equals(2));
      expect(
          decodedBody,
          containsAll([
            {'id': 'checklist1'},
            {'id': 'checklist3'}
          ]));
      expect(decodedBody, isNot(contains({'id': 'checklist2'})));
    });
  });
}
