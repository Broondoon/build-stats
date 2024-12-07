// json_file_access_test.dart

import 'dart:convert';
//import 'dart:io';
import 'package:universal_io/io.dart';
import 'package:build_stats_flutter/model/storage/local_storage/file_access.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:path/path.dart' as p;
import '../../../mocks.dart';

// Import the classes under test and their dependencies
import 'package:shared/entity.dart';

/// A concrete implementation of Entity for testing purposes.
class TestEntity extends Entity {
  final String id;
  final String name;
  final DateTime dateUpdated;
  final DateTime dateCreated;

  TestEntity({
    required this.id,
    required this.name,
    required this.dateUpdated,
    required this.dateCreated,
  }) : super(id: '', dateCreated: dateCreated, dateUpdated: dateUpdated);

  @override
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'dateUpdated': dateUpdated.toIso8601String(),
      'dateCreated': dateCreated.toIso8601String(),
    };
  }

  static TestEntity fromJson(Map<String, dynamic> json) {
    return TestEntity(
      id: json['id'] as String,
      name: json['name'] as String,
      dateUpdated: DateTime.parse(json['dateUpdated'] as String),
      dateCreated: DateTime.parse(json['dateCreated'] as String),
    );
  }
}

void main() {
  group('JsonFileAccess', () {
    late JsonFileAccess<TestEntity> jsonFileAccess;
    late MockEntityFactory<TestEntity> mockParser;
    late Directory tempDir;
    late String filePath;

    setUp(() async {
      mockParser = MockEntityFactory<TestEntity>();
      jsonFileAccess = JsonFileAccess<TestEntity>(mockParser);

      // Create a temporary directory for file operations
      tempDir = await Directory.systemTemp.createTemp('json_file_access_test');
      filePath = p.join(tempDir.path, 'test_data.json');
    });

    tearDown(() async {
      // Clean up the temporary directory
      if (await tempDir.exists()) {
        await tempDir.delete(recursive: true);
      }
    });

    test('readDataFile returns null when file does not exist', () async {
      // Act
      final result = await jsonFileAccess.readDataFile(filePath);

      // Assert
      expect(result, isNull);
    });

    test('readDataFile returns parsed data when file exists', () async {
      // Arrange
      final jsonData = [
        {
          'id': '1',
          'name': 'Entity One',
          'dateUpdated': '2022-01-01T00:00:00Z',
          'dateCreated': '2022-01-01T00:00:00Z',
        },
        {
          'id': '2',
          'name': 'Entity Two',
          'dateUpdated': '2022-01-02T00:00:00Z',
          'dateCreated': '2022-01-02T00:00:00Z',
        },
      ];
      final jsonString = jsonEncode(jsonData);
      final file = File(filePath);
      await file.writeAsString(jsonString);

      // Mock the parser to return TestEntity instances
      when(mockParser.fromJson(any)).thenAnswer((invocation) {
        final json = invocation.positionalArguments[0] as Map<String, dynamic>;
        return TestEntity.fromJson(json);
      });

      // Act
      final result = await jsonFileAccess.readDataFile(filePath);

      // Assert
      expect(result, isNotNull);
      expect(result!.length, equals(2));
      expect(result[0].id, equals('1'));
      expect(result[0].name, equals('Entity One'));
      expect(result[1].id, equals('2'));
      expect(result[1].name, equals('Entity Two'));
    });

    test('saveDataFile saves data correctly', () async {
      // Arrange
      final entities = [
        TestEntity(
          id: '1',
          name: 'Entity One',
          dateUpdated: DateTime.parse('2022-01-01T00:00:00Z'),
          dateCreated: DateTime.parse('2022-01-01T00:00:00Z'),
        ),
        TestEntity(
          id: '2',
          name: 'Entity Two',
          dateUpdated: DateTime.parse('2022-01-02T00:00:00Z'),
          dateCreated: DateTime.parse('2022-01-02T00:00:00Z'),
        ),
      ];

      // Act
      final result = await jsonFileAccess.saveDataFile(filePath, entities);

      // Assert
      expect(result, isTrue);

      final file = File(filePath);
      expect(await file.exists(), isTrue);

      final content = await file.readAsString();
      final jsonData = jsonDecode(content) as List<dynamic>;

      expect(jsonData.length, equals(2));
      expect(jsonData[0]['id'], equals('1'));
      expect(jsonData[0]['name'], equals('Entity One'));
      expect(jsonData[1]['id'], equals('2'));
      expect(jsonData[1]['name'], equals('Entity Two'));
    });

    test('saveDataFile updates existing entities', () async {
      // Arrange
      // Initial data
      final initialEntities = [
        TestEntity(
          id: '1',
          name: 'Entity One',
          dateUpdated: DateTime.parse('2022-01-01T00:00:00Z'),
          dateCreated: DateTime.parse('2022-01-01T00:00:00Z'),
        ),
      ];
      when(mockParser.fromJson(any)).thenAnswer((invocation) {
        final json = invocation.positionalArguments[0] as Map<String, dynamic>;
        return TestEntity.fromJson(json);
      });

      // Save initial data
      await jsonFileAccess.saveDataFile(filePath, initialEntities);

      // New data with updated entity and new entity
      final newEntities = [
        TestEntity(
          id: '1',
          name: 'Entity One Updated',
          dateUpdated: DateTime.parse('2022-01-03T00:00:00Z'),
          dateCreated: DateTime.parse('2022-01-01T00:00:00Z'),
        ),
        TestEntity(
          id: '2',
          name: 'Entity Two',
          dateUpdated: DateTime.parse('2022-01-02T00:00:00Z'),
          dateCreated: DateTime.parse('2022-01-02T00:00:00Z'),
        ),
      ];

      // Act
      final result = await jsonFileAccess.saveDataFile(filePath, newEntities);

      // Assert
      expect(result, isTrue);

      final file = File(filePath);
      final content = await file.readAsString();
      final jsonData = jsonDecode(content) as List<dynamic>;

      expect(jsonData.length, equals(2));
      expect(jsonData[0]['id'], equals('1'));
      expect(jsonData[0]['name'], equals('Entity One Updated'));
      expect(jsonData[1]['id'], equals('2'));
      expect(jsonData[1]['name'], equals('Entity Two'));
    });

    test('deleteDataFile deletes the file', () async {
      // Arrange
      final file = File(filePath);
      await file.writeAsString('Test Content');
      expect(await file.exists(), isTrue);

      // Act
      final result = await jsonFileAccess.deleteDataFile(filePath);

      // Assert
      expect(result, isTrue);
      expect(await file.exists(), isFalse);
    });

    test('deleteFromDataFile deletes specified entities', () async {
      // Arrange
      final entities = [
        TestEntity(
          id: '1',
          name: 'Entity One',
          dateUpdated: DateTime.parse('2022-01-01T00:00:00Z'),
          dateCreated: DateTime.parse('2022-01-01T00:00:00Z'),
        ),
        TestEntity(
          id: '2',
          name: 'Entity Two',
          dateUpdated: DateTime.parse('2022-01-02T00:00:00Z'),
          dateCreated: DateTime.parse('2022-01-02T00:00:00Z'),
        ),
        TestEntity(
          id: '3',
          name: 'Entity Three',
          dateUpdated: DateTime.parse('2022-01-03T00:00:00Z'),
          dateCreated: DateTime.parse('2022-01-03T00:00:00Z'),
        ),
      ];
      // Mock the parser to return TestEntity instances
      when(mockParser.fromJson(any)).thenAnswer((invocation) {
        final json = invocation.positionalArguments[0] as Map<String, dynamic>;
        return TestEntity.fromJson(json);
      });

      // Save initial data
      await jsonFileAccess.saveDataFile(filePath, entities);

      // Act
      final result = await jsonFileAccess.deleteFromDataFile(filePath, ['2']);

      // Assert
      expect(result, isTrue);

      final file = File(filePath);
      final content = await file.readAsString();
      final jsonData = jsonDecode(content) as List<dynamic>;

      expect(jsonData.length, equals(2));
      expect(jsonData.any((json) => json['id'] == '2'), isFalse);
      expect(jsonData.any((json) => json['id'] == '1'), isTrue);
      expect(jsonData.any((json) => json['id'] == '3'), isTrue);
    });

    test('readDataFileByKey returns the correct entity', () async {
      // Arrange
      final entities = [
        TestEntity(
          id: '1',
          name: 'Entity One',
          dateUpdated: DateTime.parse('2022-01-01T00:00:00Z'),
          dateCreated: DateTime.parse('2022-01-01T00:00:00Z'),
        ),
        TestEntity(
          id: '2',
          name: 'Entity Two',
          dateUpdated: DateTime.parse('2022-01-02T00:00:00Z'),
          dateCreated: DateTime.parse('2022-01-02T00:00:00Z'),
        ),
      ];
      // Mock the parser to return TestEntity instances
      when(mockParser.fromJson(any)).thenAnswer((invocation) {
        final json = invocation.positionalArguments[0] as Map<String, dynamic>;
        return TestEntity.fromJson(json);
      });

      // Save data
      await jsonFileAccess.saveDataFile(filePath, entities);

      // Act
      final result = await jsonFileAccess.readDataFileByKey(filePath, '2');

      // Assert
      expect(result, isNotNull);
      expect(result!.id, equals('2'));
      expect(result.name, equals('Entity Two'));
    });

    test('readDataFileByKey returns null when entity not found', () async {
      // Arrange
      final entities = [
        TestEntity(
          id: '1',
          name: 'Entity One',
          dateUpdated: DateTime.parse('2022-01-01T00:00:00Z'),
          dateCreated: DateTime.parse('2022-01-01T00:00:00Z'),
        ),
      ];
      // Mock the parser to return TestEntity instances
      when(mockParser.fromJson(any)).thenAnswer((invocation) {
        final json = invocation.positionalArguments[0] as Map<String, dynamic>;
        return TestEntity.fromJson(json);
      });

      // Save data
      await jsonFileAccess.saveDataFile(filePath, entities);

      // Act
      final result = await jsonFileAccess.readDataFileByKey(filePath, '2');

      // Assert
      expect(result, isNull);
    });

    // test('saveDataFile handles exceptions and returns false', () async {
    //   // Arrange
    //   final entities = [
    //     TestEntity(
    //       id: '1',
    //       name: 'Entity One',
    //       dateUpdated: DateTime.parse('2022-01-01T00:00:00Z'),
    //       dateCreated: DateTime.parse('2022-01-01T00:00:00Z'),
    //     ),
    //   ];

    //   // Mock _getDataFile to throw an exception
    //   jsonFileAccess = JsonFileAccess<TestEntity>(mockParser);
    //   when(mockParser.fromJson(any)).thenThrow(Exception('Test exception'));

    //   // Act
    //   final result = await jsonFileAccess.saveDataFile(filePath, entities);

    //   // Assert
    //   expect(result, isFalse);
    // });
  });
}
