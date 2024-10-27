abstract class HttpException implements Exception {
  final String message;
  final int statusCode;
  final String? body;

  HttpException(this.message, this.statusCode, this.body);

  @override
  String toString() {
    return 'HttpException: $message, statusCode: $statusCode, body: $body';
  }
}

class NotFoundException extends HttpException {
  NotFoundException(String? body) : super("Not Found", 404, body);
}
