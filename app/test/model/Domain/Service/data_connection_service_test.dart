import 'dart:convert';

import 'package:build_stats_flutter/model/Domain/Service/data_connection_service.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:http/http.dart' as http;
import 'package:build_stats_flutter/model/Domain/Exception/http_exception.dart';
import 'package:shared/entity.dart';

import '../../../mocks.dart';
@GenerateMocks([http.Client])
import 'data_connection_service_test.mocks.dart';

void main() {
  group('DataConnection', () {
    late DataConnection<Entity> dataConnection;
    late MockClient mockClient;
    late MockEntity mockEntity;

    setUp(() {
      mockClient = MockClient();
      mockEntity = MockEntity();
      dataConnection = DataConnection<Entity>(client: mockClient);
    });

    test('get returns response body when status code is 200', () async {
      // Arrange
      const path = 'https://example.com/api/resource';
      when(mockClient.get(Uri.parse(path)))
          .thenAnswer((_) async => http.Response('{"key": "value"}', 200));

      // Act
      final result = await dataConnection.get(path);

      // Assert
      expect(result, equals('{"key": "value"}'));
      verify(mockClient.get(Uri.parse(path))).called(1);
    });

    test('get throws HttpException when status code is not 200', () async {
      // Arrange
      final path = 'https://example.com/api/resource';
      when(mockClient.get(Uri.parse(path)))
          .thenAnswer((_) async => http.Response('Not Found', 404));

      // Act & Assert
      expect(
          () => dataConnection.get(path),
          throwsA(isA<HttpException>()
              .having((e) => e.statusCode, 'statusCode', equals(404))));
      verify(mockClient.get(Uri.parse(path))).called(1);
    });

    test('post returns response body when status code is 200', () async {
      // Arrange
      final path = 'https://example.com/api/resource';
      when(mockEntity.toJson())
          .thenReturn({'id': '123', 'name': 'Test Entity'});

      when(mockClient.post(Uri.parse(path),
              body: {'id': '123', 'name': 'Test Entity'}))
          .thenAnswer((_) async => http.Response('{"success": true}', 200));

      // Act
      final result = await dataConnection.post(path, mockEntity);

      // Assert
      expect(result, equals('{"success": true}'));
      verify(mockClient.post(Uri.parse(path),
          body: {'id': '123', 'name': 'Test Entity'})).called(1);
    });

    test('post throws HttpException when status code is not 200', () async {
      // Arrange
      final path = 'https://example.com/api/resource';
      when(mockEntity.toJson())
          .thenReturn({'id': '123', 'name': 'Test Entity'});

      when(mockClient.post(Uri.parse(path),
              body: {'id': '123', 'name': 'Test Entity'}))
          .thenAnswer((_) async => http.Response('Error', 500));

      // Act & Assert
      expect(
          () => dataConnection.post(path, mockEntity),
          throwsA(isA<HttpException>()
              .having((e) => e.statusCode, 'statusCode', equals(500))));
      verify(mockClient.post(Uri.parse(path),
          body: {'id': '123', 'name': 'Test Entity'})).called(1);
    });

    test('put returns response body when status code is 200', () async {
      // Arrange
      final path = 'https://example.com/api/resource';
      when(mockEntity.toJson())
          .thenReturn({'id': '123', 'name': 'Updated Entity'});

      when(mockClient.put(Uri.parse(path),
              body: {'id': '123', 'name': 'Updated Entity'}))
          .thenAnswer((_) async => http.Response('{"updated": true}', 200));

      // Act
      final result = await dataConnection.put(path, mockEntity);

      // Assert
      expect(result, equals('{"updated": true}'));
      verify(mockClient.put(Uri.parse(path),
          body: {'id': '123', 'name': 'Updated Entity'})).called(1);
    });

    test('put throws HttpException when status code is not 200', () async {
      // Arrange
      final path = 'https://example.com/api/resource';
      when(mockEntity.toJson())
          .thenReturn({'id': '123', 'name': 'Updated Entity'});

      when(mockClient.put(Uri.parse(path),
              body: {'id': '123', 'name': 'Updated Entity'}))
          .thenAnswer((_) async => http.Response('Error', 400));

      // Act & Assert
      expect(
          () => dataConnection.put(path, mockEntity),
          throwsA(isA<HttpException>()
              .having((e) => e.statusCode, 'statusCode', equals(400))));
      verify(mockClient.put(Uri.parse(path),
          body: {'id': '123', 'name': 'Updated Entity'})).called(1);
    });

    test('delete completes when status code is 200', () async {
      // Arrange
      final path = 'https://example.com/api/resource';
      final keys = ['key1', 'key2'];
      final encodedKeys = jsonEncode(keys);

      when(mockClient.delete(Uri.parse(path), body: encodedKeys))
          .thenAnswer((_) async => http.Response('', 200));

      // Act
      await dataConnection.delete(path, keys);

      // Assert
      verify(mockClient.delete(Uri.parse(path), body: encodedKeys)).called(1);
    });

    test('delete throws HttpException when status code is not 200', () async {
      // Arrange
      final path = 'https://example.com/api/resource';
      final keys = ['key1', 'key2'];
      final encodedKeys = jsonEncode(keys);

      when(mockClient.delete(Uri.parse(path), body: encodedKeys))
          .thenAnswer((_) async => http.Response('Error', 500));

      // Act & Assert
      expect(
          () => dataConnection.delete(path, keys),
          throwsA(isA<HttpException>()
              .having((e) => e.statusCode, 'statusCode', equals(500))));
      verify(mockClient.delete(Uri.parse(path), body: encodedKeys)).called(1);
    });
  });
}
