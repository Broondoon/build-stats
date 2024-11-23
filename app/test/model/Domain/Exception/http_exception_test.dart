import 'package:build_stats_flutter/model/Domain/Exception/http_exception.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('HttpException', () {
    test('Constructor initializes correctly with valid status code', () {
      // Arrange
      const statusCode = 200;
      const body = 'Success';

      // Act
      final exception = HttpException(statusCode, body);

      // Assert
      expect(exception.statusCode, equals(statusCode));
      expect(exception.body, equals(body));
      expect(exception.message, equals('OK'));
      expect(exception.response.code, equals(statusCode));
      expect(exception.response.message, equals('OK'));
    });

    test('Constructor throws Exception with invalid status code', () {
      // Arrange
      const statusCode = 999;
      const body = 'Unknown Status';

      // Act & Assert
      expect(
        () => HttpException(statusCode, body),
        throwsA(isA<Exception>().having(
            (e) => e.toString(), 'message', contains('Invalid status code'))),
      );
    });

    test('toString method returns correct string', () {
      // Arrange
      const statusCode = 404;
      const body = 'Not Found';

      // Act
      final exception = HttpException(statusCode, body);
      final exceptionString = exception.toString();

      // Assert
      expect(
        exceptionString,
        equals(
            'HttpException: ${exception.response}, statusCode: $statusCode, body: $body'),
      );
    });

    test('compareTo method compares based on status code', () {
      // Arrange
      const statusCode1 = 400;
      const statusCode2 = 404;

      final exception1 = HttpException(statusCode1, 'Bad Request');
      final exception2 = HttpException(statusCode2, 'Not Found');

      // Act
      final comparisonResult = exception1.compareTo(exception2);

      // Assert
      expect(comparisonResult, lessThan(0)); // Since 400 < 404
    });
  });
}
