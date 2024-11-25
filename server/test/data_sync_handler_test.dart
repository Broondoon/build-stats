import 'dart:collection';
import 'dart:convert';

import 'package:Server/handlers/data_sync_handler.dart';
import 'package:Server/storage/unit_cache.dart';
import 'package:mockito/annotations.dart';
import 'package:shared/app_strings.dart';
import 'package:test/test.dart';
import 'package:mockito/mockito.dart';
import 'data_sync_handler_test.mocks.dart';
import 'mocks.dart';

// Constants from app_strings.dart
const String API_DataObject_ChecklistStateList = 'checklistStates';
const String API_DataObject_ChecklistDayStateList = 'checklistDayStates';
const String API_DataObject_ItemStateList = 'itemStates';
const String API_DataObject_WorksiteStateList = 'worksiteStates';
const String API_DataObject_UserId = 'userId';
const String API_DataObject_CompanyId = 'companyId';

const Map<String, String> jsonHeaders = {
  'content-type': 'application/json',
};

// // Generate mocks for the dependencies
@GenerateMocks([
  UnitCache,
])
void main() {
  group('DataSync', () {
    provideDummy<HashMap<String, String>>(HashMap<String, String>());
    provideDummy<HashMap<String, List<String>>>(
        HashMap<String, List<String>>());

    late MockWorksiteCache mockWorksiteCache;
    late MockChecklistCache mockChecklistCache;
    late MockChecklistDayCache mockChecklistDayCache;
    late MockItemCache mockItemCache;
    late MockUnitCache mockUnitCache;
    late DataSync dataSync;
    late MockRequest request;

    setUp(() {
      mockWorksiteCache = MockWorksiteCache();
      mockChecklistCache = MockChecklistCache();
      mockChecklistDayCache = MockChecklistDayCache();
      mockItemCache = MockItemCache();
      mockUnitCache = MockUnitCache();
      dataSync = DataSync(mockWorksiteCache, mockChecklistCache,
          mockChecklistDayCache, mockItemCache, mockUnitCache);
    });

    test('handleCheckCacheSync returns correct response when given valid input',
        () async {
      // Arrange
      final requestBody = jsonEncode({
        API_DataObject_WorksiteStateList: ['worksite1', 'worksite3'],
        API_DataObject_ChecklistStateList: ['checklist1', 'checklist2'],
        API_DataObject_ChecklistDayStateList: ['day1', 'day2'],
        API_DataObject_ItemStateList: ['item1', 'item2'],
        API_DataObject_UnitStateList: ['unit1', 'unit2'],
        API_DataObject_UserId: 'user123',
        API_DataObject_CompanyId: 'company456',
      });

      request = MockRequest();
      when(request.readAsString()).thenAnswer((_) async => requestBody);

      // Mock the getCacheCheckStates() methods
      when(mockWorksiteCache.getCacheCheckStates()).thenAnswer((_) async =>
          HashMap.from({'worksite1': 'checksum1', 'worksite2': 'checksum2'}));
      when(mockChecklistCache.getCacheCheckStates()).thenAnswer((_) async =>
          HashMap.from({'checklist1': 'checksum3', 'checklist3': 'checksum4'}));
      when(mockChecklistDayCache.getCacheCheckStates()).thenAnswer((_) async =>
          HashMap.from({'day1': 'checksum5', 'day3': 'checksum6'}));
      when(mockItemCache.getCacheCheckStates()).thenAnswer((_) async =>
          HashMap.from({'item2': 'checksum7', 'item3': 'checksum8'}));
      when(mockUnitCache.getCacheCheckStates()).thenAnswer((_) async =>
          HashMap.from({'unit1': 'checksum9', 'unit3': 'checksum10'}));

      // Act
      final result = await dataSync.handleCheckCacheSync(request);

      // Assert
      expect(result.statusCode, equals(200));
      expect(result.headers['content-type'], equals('application/json'));

      final responseContent = await result.readAsString();
      final responseData = jsonDecode(responseContent);

      expect(
          responseData[API_DataObject_WorksiteStateList],
          equals({
            'worksite1': 'checksum1',
          }));
      expect(
          responseData[API_DataObject_ChecklistStateList],
          equals({
            'checklist1': 'checksum3',
          }));
      expect(
          responseData[API_DataObject_ChecklistDayStateList],
          equals({
            'day1': 'checksum5',
          }));
      expect(
          responseData[API_DataObject_ItemStateList],
          equals({
            'item2': 'checksum7',
          }));
      expect(
          responseData[API_DataObject_UnitStateList],
          equals({
            'unit1': 'checksum9',
          }));
    });

    test('handleCheckCacheSync returns empty maps when no matching IDs',
        () async {
      // Arrange
      final requestBody = jsonEncode({
        API_DataObject_WorksiteStateList: ['unknownWorksite'],
        API_DataObject_ChecklistStateList: ['unknownChecklist'],
        API_DataObject_ChecklistDayStateList: ['unknownDay'],
        API_DataObject_ItemStateList: ['unknownItem'],
        API_DataObject_UnitStateList: ['unknownUnit'],
        API_DataObject_UserId: 'user123',
        API_DataObject_CompanyId: 'company456',
      });

      request = MockRequest();
      when(request.readAsString()).thenAnswer((_) async => requestBody);

      // Mock the getCacheCheckStates() methods
      when(mockWorksiteCache.getCacheCheckStates())
          .thenAnswer((_) async => HashMap.from({'worksite1': 'checksum1'}));
      when(mockChecklistCache.getCacheCheckStates())
          .thenAnswer((_) async => HashMap.from({'checklist1': 'checksum3'}));
      when(mockChecklistDayCache.getCacheCheckStates())
          .thenAnswer((_) async => HashMap.from({'day1': 'checksum5'}));
      when(mockItemCache.getCacheCheckStates())
          .thenAnswer((_) async => HashMap.from({'item1': 'checksum7'}));
      when(mockUnitCache.getCacheCheckStates())
          .thenAnswer((_) async => HashMap.from({'unit1': 'checksum9'}));

      // Act
      final result = await dataSync.handleCheckCacheSync(request);

      // Assert
      expect(result.statusCode, equals(200));
      final responseContent = await result.readAsString();
      final responseData = jsonDecode(responseContent);

      expect(responseData[API_DataObject_WorksiteStateList], isEmpty);
      expect(responseData[API_DataObject_ChecklistStateList], isEmpty);
      expect(responseData[API_DataObject_ChecklistDayStateList], isEmpty);
      expect(responseData[API_DataObject_ItemStateList], isEmpty);
    });

    test('handleCheckCacheSync handles exceptions gracefully', () async {
      // Arrange
      final requestBody = jsonEncode({
        API_DataObject_WorksiteStateList: ['worksite1'],
        API_DataObject_ChecklistStateList: ['checklist1'],
        API_DataObject_ChecklistDayStateList: ['day1'],
        API_DataObject_ItemStateList: ['item1'],
        API_DataObject_UnitStateList: ['unit1'],
        API_DataObject_UserId: 'user123',
        API_DataObject_CompanyId: 'company456',
      });

      request = MockRequest();
      when(request.readAsString()).thenAnswer((_) async => requestBody);

      // Simulate an exception thrown by getCacheCheckStates
      when(mockWorksiteCache.getCacheCheckStates())
          .thenThrow(Exception('Test exception'));

      // Act
      final result = await dataSync.handleCheckCacheSync(request);

      // Assert
      expect(result.statusCode, equals(500));
      final body = await result.readAsString();
      expect(body, contains('Exception: Test exception'));
    });

    test('handleCheckCacheSync handles missing fields in input JSON', () async {
      // Arrange
      final requestBody = jsonEncode({
        // Missing some fields intentionally
        API_DataObject_UserId: 'user123',
        API_DataObject_CompanyId: 'company456',
      });

      request = MockRequest();
      when(request.readAsString()).thenAnswer((_) async => requestBody);

      // Mock the getCacheCheckStates() methods to return empty maps
      when(mockWorksiteCache.getCacheCheckStates())
          .thenAnswer((_) async => HashMap());
      when(mockChecklistCache.getCacheCheckStates())
          .thenAnswer((_) async => HashMap());
      when(mockChecklistDayCache.getCacheCheckStates())
          .thenAnswer((_) async => HashMap());
      when(mockItemCache.getCacheCheckStates())
          .thenAnswer((_) async => HashMap());
      when(mockUnitCache.getCacheCheckStates())
          .thenAnswer((_) async => HashMap());

      // Act
      final result = await dataSync.handleCheckCacheSync(request);

      // Assert
      expect(result.statusCode, equals(200));
      final responseContent = await result.readAsString();
      final responseData = jsonDecode(responseContent);

      expect(responseData[API_DataObject_WorksiteStateList], isEmpty);
      expect(responseData[API_DataObject_ChecklistStateList], isEmpty);
      expect(responseData[API_DataObject_ChecklistDayStateList], isEmpty);
      expect(responseData[API_DataObject_ItemStateList], isEmpty);
    });
  });
}
