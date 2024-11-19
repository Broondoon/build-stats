import 'dart:convert';

import 'package:Server/handlers/worksite_handler.dart';
import 'package:test/test.dart';
import 'package:mockito/mockito.dart';
import 'mocks.dart';

// Generate mocks for the dependencies
// @GenerateMocks([
//   WorksiteCache,
//   WorksiteFactory,
//   Worksite,
// ])
void main() {
  group('WorksiteHandler', () {
    late MockWorksiteCache mockWorksiteCache;
    late MockWorksiteFactory mockWorksiteFactory;
    late WorksiteHandler worksiteHandler;
    late MockRequest request;

    setUp(() {
      mockWorksiteCache = MockWorksiteCache();
      mockWorksiteFactory = MockWorksiteFactory();
      worksiteHandler = WorksiteHandler(mockWorksiteCache, mockWorksiteFactory);
    });

    test('handleGetUserVisibleWorksites returns worksites when found',
        () async {
      // Arrange
      final companyId = 'company123';
      final userId = 'user456';
      request = MockRequest();

      final mockWorksite1 = MockWorksite();
      final mockWorksite2 = MockWorksite();

      when(mockWorksite1.ownerId).thenReturn(userId);
      when(mockWorksite1.companyId).thenReturn(companyId);
      when(mockWorksite1.toJsonTransfer()).thenReturn({'id': 'ws1'});

      when(mockWorksite2.ownerId).thenReturn(userId);
      when(mockWorksite2.companyId).thenReturn(companyId);
      when(mockWorksite2.toJsonTransfer()).thenReturn({'id': 'ws2'});

      // Simulate getAll returning a list of worksites
      when(mockWorksiteCache.getAll(any))
          .thenAnswer((_) async => [mockWorksite1, mockWorksite2]);

      // Act
      final response = await worksiteHandler.handleGetUserVisibleWorksites(
          request, companyId, userId);

      // Assert
      expect(response.statusCode, equals(200));
      expect(response.headers['content-type'], contains('application/json'));

      final body = await response.readAsString();
      final decodedBody = jsonDecode(body) as List<dynamic>;

      expect(decodedBody.length, equals(2));
      expect(
          decodedBody,
          containsAll([
            {'id': 'ws1'},
            {'id': 'ws2'}
          ]));
    });

    test('handleGetUserVisibleWorksites returns 404 when no worksites found',
        () async {
      // Arrange
      final companyId = 'company123';
      final userId = 'user456';
      request = MockRequest();

      // Simulate getAll returning an empty list
      when(mockWorksiteCache.getAll(any)).thenAnswer((_) async => []);

      // Act
      final response = await worksiteHandler.handleGetUserVisibleWorksites(
          request, companyId, userId);

      // Assert
      expect(response.statusCode, equals(404));
      final body = await response.readAsString();
      expect(body, equals('No worksites found'));
    });

    test('handleGetUserVisibleWorksites handles exceptions gracefully',
        () async {
      // Arrange
      final companyId = 'company123';
      final userId = 'user456';
      request = MockRequest();

      // Simulate an exception thrown by getAll
      when(mockWorksiteCache.getAll(any))
          .thenThrow(Exception('Test exception'));

      // Act
      final response = await worksiteHandler.handleGetUserVisibleWorksites(
          request, companyId, userId);

      // Assert
      expect(response.statusCode, equals(500));
      final body = await response.readAsString();
      expect(body, contains('Exception: Test exception'));
    });

    test(
        'handleGetUserVisibleWorksites filters worksites by userId and companyId',
        () async {
      // Arrange
      final companyId = 'company123';
      final userId = 'user456';
      request = MockRequest();

      final mockWorksite1 = MockWorksite();
      final mockWorksite2 = MockWorksite();
      final mockWorksite3 = MockWorksite();

      when(mockWorksite1.ownerId).thenReturn(userId);
      when(mockWorksite1.companyId).thenReturn(companyId);
      when(mockWorksite1.toJsonTransfer()).thenReturn({'id': 'ws1'});

      when(mockWorksite2.ownerId).thenReturn('otherUser');
      when(mockWorksite2.companyId).thenReturn(companyId);
      when(mockWorksite2.toJsonTransfer()).thenReturn({'id': 'ws2'});

      when(mockWorksite3.ownerId).thenReturn(userId);
      when(mockWorksite3.companyId).thenReturn('otherCompany');
      when(mockWorksite3.toJsonTransfer()).thenReturn({'id': 'ws3'});

      // Simulate getAll returning a list of worksites
      when(mockWorksiteCache.getAll(any)).thenAnswer(
          (_) async => [mockWorksite1, mockWorksite2, mockWorksite3]);

      // Act
      final response = await worksiteHandler.handleGetUserVisibleWorksites(
          request, companyId, userId);

      // Assert
      expect(response.statusCode, equals(200));

      final body = await response.readAsString();
      final decodedBody = jsonDecode(body) as List<dynamic>;

      expect(decodedBody.length, equals(1));
      expect(
          decodedBody,
          containsAll([
            {'id': 'ws1'}
          ]));
    });
  });
}
