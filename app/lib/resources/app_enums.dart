enum HttpResponse implements Comparable<HttpResponse> {
  NotFound(code: 404, message: 'Not Found'),
  ServiceUnavailable(code: 503, message: 'Service Unavailable'),
  ;

  const HttpResponse({required this.code, required this.message});
  final int code;
  final String message;
  @override
  int compareTo(HttpResponse other) => code.compareTo(other.code);
}
