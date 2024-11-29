import 'dart:convert';

import 'package:Server/handlers/handler.dart';
import 'package:Server/services/cache_service.dart';
import 'package:shared/entity.dart';
import 'package:test/test.dart';
import 'package:mockito/mockito.dart';
import 'mocks.dart';

void main() {
  group('RequestHandler', () {
    late CacheService mockCacheService;
    late EntityFactory mockEntityFactory;
    late RequestHandler<Entity> requestHandler;
    late MockRequest request;

    setUp(() {
      mockCacheService = MockCacheService();
      mockEntityFactory = MockEntityFactory();
      requestHandler =
          RequestHandler<Entity>(mockCacheService, mockEntityFactory);
    });

    test('handleGet returns entity when found', () async {
      // Arrange
      final id = 'test-id';
      final testData = {'id': id, 'data': 'data1'};
      final entity = MockEntity();
      when(entity.id).thenReturn(id);
      when(entity.getChecksum()).thenReturn('checksum1');
      when(entity.toJson()).thenReturn(testData);
      when(entity.toJsonTransfer()).thenReturn(testData);
      when(mockEntityFactory.fromJson({'id': id, 'data': 'data1'}))
          .thenReturn(entity);
      when(mockCacheService.getById(id)).thenAnswer((_) async => entity);
      request = MockRequest();
      when(request.readAsString())
          .thenAnswer((_) async => jsonEncode(entity.toJsonTransfer()));
      // Act
      final response = await requestHandler.handleGet(request, id);

      // Assert
      expect(response.statusCode, equals(200));
      expect(response.headers['content-type'], equals('application/json'));
      final body = await response.readAsString();
      expect(body, equals(jsonEncode(testData)));
    });

    test('handleGet returns null when entity not found', () async {
      // Arrange
      final id = 'test-id';
      when(mockCacheService.getById(id)).thenAnswer((_) async => null);
      request = MockRequest();
      // Act
      final response = await requestHandler.handleGet(request, id);

      // Assert
      expect(response.statusCode, equals(200));
      expect(response.headers['content-type'], equals('application/json'));
      final body = await response.readAsString();
      expect(body, equals('null'));
    });

    test('handleGet returns 500 when an exception occurs', () async {
      // Arrange
      final id = 'test-id';
      when(mockCacheService.getById(id)).thenThrow(Exception('Test exception'));
      request = MockRequest();
      // Act
      final response = await requestHandler.handleGet(request, id);

      // Assert
      expect(response.statusCode, equals(500));
      final body = await response.readAsString();
      expect(body, contains('Exception: Test exception'));
    });

    test('handlePost stores entity and returns it', () async {
      // Arrange
      Entity entity = Entity(
          id: 'temp_test-id',
          name: 'test-name',
          dateCreated: DateTime.now().toUtc(),
          dateUpdated: DateTime.now().toUtc());

      final requestBody = jsonEncode(entity.toJson());
      when(mockEntityFactory.fromJson(entity.toJson())).thenReturn(entity);
      request = MockRequest();
      when(request.readAsString()).thenAnswer((_) async => requestBody);

      // Simulate the cache store operation
      when(mockCacheService.store('test-id', entity)).thenAnswer((_) async {
        entity.id = 'test-id';
        return entity;
      });

      // Act
      final response = await requestHandler.handlePost(request);

      // Assert
      expect(response.statusCode, equals(200));
      expect(response.headers['content-type'], equals('application/json'));
      final body = await response.readAsString();
      expect(
          body,
          equals(jsonEncode({
            'id': 'test-id',
            'name': 'test-name',
            'dateCreated': entity.dateCreated.toIso8601String(),
            'dateUpdated': entity.dateUpdated.toIso8601String(),
            "flagForDeletion": 'false'
          })));
    });

    test('handlePost returns 500 when an exception occurs', () async {
      // Arrange
      request = MockRequest();
      when(request.readAsString()).thenThrow(Exception('Invalid JSON'));

      // Act
      final response = await requestHandler.handlePost(request);

      // Assert
      expect(response.statusCode, equals(500));
      final body = await response.readAsString();
      expect(body, contains('Exception: Invalid JSON'));
    });

    test('handlePut updates entity and returns it', () async {
      // Arrange
      final entityJson = {
        'id': 'test-id',
        'data': 'updated-data',
      };
      final requestBody = jsonEncode(entityJson);
      request = MockRequest();
      when(request.readAsString()).thenAnswer((_) async => requestBody);

      final parsedEntity = MockEntity();
      when(parsedEntity.id).thenReturn('test-id');
      when(parsedEntity.getChecksum()).thenReturn('checksum1');
      when(parsedEntity.toJson()).thenReturn(entityJson);
      when(parsedEntity.toJsonTransfer()).thenReturn(entityJson);
      when(mockEntityFactory.fromJson(entityJson)).thenReturn(parsedEntity);

      when(mockEntityFactory.fromJson(entityJson)).thenReturn(parsedEntity);

      // Simulate the cache store operation
      when(mockCacheService.store('test-id', parsedEntity))
          .thenAnswer((_) async => parsedEntity);

      // Act
      final response = await requestHandler.handlePut(request);

      // Assert
      expect(response.statusCode, equals(200));
      expect(response.headers['content-type'], equals('application/json'));
      final body = await response.readAsString();
      expect(
          body, equals(jsonEncode({'id': 'test-id', 'data': 'updated-data'})));
    });

    test('handlePut returns 500 when an exception occurs', () async {
      // Arrange
      request = MockRequest();
      when(request.readAsString()).thenThrow(Exception('Invalid JSON'));

      // Act
      final response = await requestHandler.handlePut(request);

      // Assert
      expect(response.statusCode, equals(500));
      final body = await response.readAsString();
      expect(body, contains('Exception: Invalid JSON'));
    });

    test('handleDelete deletes entities and returns message', () async {
      // Arrange
      final ids = ['id1', 'id2'];
      final requestBody = jsonEncode(ids);
      request = MockRequest();
      when(request.readAsString()).thenAnswer((_) async => requestBody);
      // Simulate cache delete operations
      when(mockCacheService.delete(ids[0])).thenAnswer((_) async {});
      when(mockCacheService.delete(ids[1])).thenAnswer((_) async {});

      // Act
      final response = await requestHandler.handleDelete(request);

      // Assert
      expect(response.statusCode, equals(200));
      expect(response.headers['content-type'], equals('application/json'));
      final body = await response.readAsString();
      expect(body, equals(jsonEncode({'message': 'Deleted'})));

      // Verify that delete was called for each id
      verify(mockCacheService.delete('id1')).called(1);
      verify(mockCacheService.delete('id2')).called(1);
    });

    test('handleDelete returns 500 when an exception occurs', () async {
      // Arrange
      request = MockRequest();
      when(request.readAsString()).thenThrow(Exception('Invalid JSON'));

      // Act
      final response = await requestHandler.handleDelete(request);

      // Assert
      expect(response.statusCode, equals(500));
      final body = await response.readAsString();
      expect(body, contains('Invalid JSON'));
    });
  });
}
