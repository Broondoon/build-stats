import 'package:build_stats_flutter/resources/app_enums.dart';

abstract class HttpException implements Exception {
  late final HttpResponse response;
  final String? body;
  String get message => response.message;
  int get statusCode => response.code;

  HttpException(statusCode, this.body) {
    response = HttpResponse.values.firstWhere(
        (element) => element.code == statusCode,
        orElse: () => throw Exception("Invalid status code"));
  }

  @override
  String toString() {
    return 'HttpException: $response, statusCode: $statusCode, body: $body';
  }

  @override
  int compareTo(HttpException other) => statusCode.compareTo(other.statusCode);
}
