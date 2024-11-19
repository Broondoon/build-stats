import 'dart:convert';

import 'package:Server/handlers/checklistDay_handler.dart';
import 'package:test/test.dart';
import 'package:mockito/mockito.dart';

import 'mocks.dart';

// Generate mocks for the dependencies
// @GenerateMocks([
//   ChecklistDayCache,
//   ChecklistDayFactory,
//   ChecklistDay,
// ])

void main() {
  group('ChecklistDayHandler', () {
    late MockChecklistDayCache mockChecklistDayCache;
    late MockChecklistDayFactory mockChecklistDayFactory;
    late ChecklistDayHandler checklistDayHandler;
    late MockRequest request;

    setUp(() {
      mockChecklistDayCache = MockChecklistDayCache();
      mockChecklistDayFactory = MockChecklistDayFactory();
      checklistDayHandler =
          ChecklistDayHandler(mockChecklistDayCache, mockChecklistDayFactory);
    });

    test('handleGetDaysOnChecklist returns checklist days when found',
        () async {
      // Arrange
      request = MockRequest();
      final checklistId = 'checklist123';

      final mockChecklistDay1 = MockChecklistDay();
      final mockChecklistDay2 = MockChecklistDay();

      when(mockChecklistDay1.checklistId).thenReturn(checklistId);
      when(mockChecklistDay1.toJsonTransfer()).thenReturn({'id': 'day1'});

      when(mockChecklistDay2.checklistId).thenReturn(checklistId);
      when(mockChecklistDay2.toJsonTransfer()).thenReturn({'id': 'day2'});

      // Simulate getAll returning a list of checklist days
      when(mockChecklistDayCache.getAll(any))
          .thenAnswer((_) async => [mockChecklistDay1, mockChecklistDay2]);

      // Act
      final response = await checklistDayHandler.handleGetDaysOnChecklist(
          request, checklistId);

      // Assert
      expect(response.statusCode, equals(200));
      expect(response.headers['content-type'], contains('application/json'));

      final body = await response.readAsString();
      final decodedBody = jsonDecode(body) as List<dynamic>;

      expect(decodedBody.length, equals(2));
      expect(
          decodedBody,
          containsAll([
            {'id': 'day1'},
            {'id': 'day2'}
          ]));
    });

    test('handleGetDaysOnChecklist returns 404 when no checklist days found',
        () async {
      // Arrange
      request = MockRequest();
      final checklistId = 'checklist123';

      // Simulate getAll returning an empty list
      when(mockChecklistDayCache.getAll(any)).thenAnswer((_) async => []);

      // Act
      final response = await checklistDayHandler.handleGetDaysOnChecklist(
          request, checklistId);

      // Assert
      expect(response.statusCode, equals(404));
      final body = await response.readAsString();
      expect(body, equals('No checklist days found'));
    });

    test('handleGetDaysOnChecklist handles exceptions gracefully', () async {
      // Arrange
      request = MockRequest();
      final checklistId = 'checklist123';

      // Simulate an exception thrown by getAll
      when(mockChecklistDayCache.getAll(any))
          .thenThrow(Exception('Test exception'));

      // Act
      final response = await checklistDayHandler.handleGetDaysOnChecklist(
          request, checklistId);

      // Assert
      expect(response.statusCode, equals(500));
      final body = await response.readAsString();
      expect(body, contains('Exception: Test exception'));
    });

    test('handleGetDaysOnChecklist filters checklist days by checklistId',
        () async {
      // Arrange
      request = MockRequest();
      final checklistId = 'checklist123';

      final mockChecklistDay1 = MockChecklistDay();
      final mockChecklistDay2 = MockChecklistDay();
      final mockChecklistDay3 = MockChecklistDay();

      when(mockChecklistDay1.checklistId).thenReturn(checklistId);
      when(mockChecklistDay1.toJsonTransfer()).thenReturn({'id': 'day1'});

      when(mockChecklistDay2.checklistId).thenReturn('otherChecklist');
      when(mockChecklistDay2.toJsonTransfer()).thenReturn({'id': 'day2'});

      when(mockChecklistDay3.checklistId).thenReturn(checklistId);
      when(mockChecklistDay3.toJsonTransfer()).thenReturn({'id': 'day3'});

      // Simulate getAll returning a list of checklist days
      when(mockChecklistDayCache.getAll(any)).thenAnswer((_) async =>
          [mockChecklistDay1, mockChecklistDay2, mockChecklistDay3]);

      // Act
      final response = await checklistDayHandler.handleGetDaysOnChecklist(
          request, checklistId);

      // Assert
      expect(response.statusCode, equals(200));

      final body = await response.readAsString();
      final decodedBody = jsonDecode(body) as List<dynamic>;

      expect(decodedBody.length, equals(2));
      expect(
          decodedBody,
          containsAll([
            {'id': 'day1'},
            {'id': 'day3'}
          ]));
      expect(decodedBody, isNot(contains({'id': 'day2'})));
    });
  });
}
