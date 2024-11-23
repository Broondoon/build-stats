import 'dart:collection';

import 'package:build_stats_flutter/model/entity/checklist.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared/app_strings.dart';

void main() {
  group('Checklist', () {
    late Checklist checklist;

    setUp(() {
      checklist = Checklist(
        id: 'checklist1',
        worksiteId: 'worksite1',
        name: 'Test Checklist',
        dateCreated: DateTime.now(),
        dateUpdated: DateTime.now(),
        flagForDeletion: false,
      );
    });

    test('getChecklistDayID returns default when checklistIdsByDate is empty',
        () {
      // Arrange
      final date = DateTime(2022, 1, 1);
      checklist.checklistIdsByDate = HashMap.from({});

      // Act
      final result = checklist.getChecklistDayID(date);

      // Assert
      expect(result, equals((false, ID_DefaultBlankChecklistDayID)));
    });

    test(
        'getChecklistDayID returns true and correct ID when date is in checklistIdsByDate',
        () {
      // Arrange
      final date = DateTime(2022, 1, 1);
      final dateKey =
          '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
      final checklistDayId = 'checklistDay1';

      checklist.checklistIdsByDate = HashMap.from({
        dateKey: checklistDayId,
      });

      // Act
      final result = checklist.getChecklistDayID(date);

      // Assert
      expect(result, equals((true, checklistDayId)));
    });

    test('getChecklistDayID returns correct ID for the closest earlier date',
        () {
      // Arrange
      final date = DateTime(2022, 1, 3);
      final earlierDate1 = DateTime(2022, 1, 1).toUtc();
      final earlierDate2 = DateTime(2022, 1, 2).toUtc();
      final dateKey1 =
          '${earlierDate1.year}-${earlierDate1.month.toString().padLeft(2, '0')}-${earlierDate1.day.toString().padLeft(2, '0')}';
      final dateKey2 =
          '${earlierDate2.year}-${earlierDate2.month.toString().padLeft(2, '0')}-${earlierDate2.day.toString().padLeft(2, '0')}';
      final checklistDayId1 = 'checklistDay1';
      final checklistDayId2 = 'checklistDay2';

      checklist.checklistIdsByDate = HashMap.from({
        dateKey1: checklistDayId1,
        dateKey2: checklistDayId2,
      });

      // Act
      final result = checklist.getChecklistDayID(date);

      // Assert
      expect(
          result,
          equals((
            checklistDayId2 == ID_DefaultBlankChecklistDayID,
            checklistDayId2
          )));
    });

    test('getChecklistDayID returns last date when no earlier dates are found',
        () {
      // Arrange
      final date = DateTime(2022, 1, 1);
      final futureDate = DateTime(2022, 1, 5).toUtc();
      final String futureDateKey =
          '${futureDate.year}-${futureDate.month.toString().padLeft(2, '0')}-${futureDate.day.toString().padLeft(2, '0')}';
      const checklistDayId = 'checklistDayFuture';

      checklist.checklistIdsByDate = HashMap.from({
        futureDateKey: checklistDayId,
      });

      // Act
      final result = checklist.getChecklistDayID(date);

      // Assert
      expect(
          result,
          equals((
            checklistDayId == ID_DefaultBlankChecklistDayID,
            checklistDayId
          )));
    });

    test('getChecklistDayID handles multiple dates correctly', () {
      // Arrange
      final date = DateTime(2022, 1, 4);
      final dates = [
        DateTime(2022, 1, 1).toUtc(),
        DateTime(2022, 1, 2).toUtc(),
        DateTime(2022, 1, 3).toUtc(),
        DateTime(2022, 1, 5).toUtc(),
      ];
      final dateKeys = dates
          .map((d) =>
              '${d.year}-${d.month.toString().padLeft(2, '0')}-${d.day.toString().padLeft(2, '0')}')
          .toList();
      final checklistDayIds = ['day1', 'day2', 'day3', 'day5'];

      checklist.checklistIdsByDate = HashMap.from({
        dateKeys[0]: checklistDayIds[0],
        dateKeys[1]: checklistDayIds[1],
        dateKeys[2]: checklistDayIds[2],
        dateKeys[3]: checklistDayIds[3],
      });

      // Act
      final result = checklist.getChecklistDayID(date);

      // Assert
      expect(
          result,
          equals((
            checklistDayIds[2] == ID_DefaultBlankChecklistDayID,
            checklistDayIds[2]
          )));
    });
  });
}
