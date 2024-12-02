// ignore_for_file: camel_case_types, constant_identifier_names

enum HttpResponse implements Comparable<HttpResponse> {
  NotFound(code: 404, message: 'Not Found'),
  BadRequest(code: 400, message: 'Bad Request'),
  ServiceUnavailable(code: 503, message: 'Service Unavailable'),
  InternalServerError(code: 500, message: 'Internal Server Error'),
  Success(code: 200, message: 'OK'),
  ;

  const HttpResponse({required this.code, required this.message});
  final int code;
  final String message;
  @override
  int compareTo(HttpResponse other) => code.compareTo(other.code);
}

enum overlayChoice {
  comments,
  newcategory,
  category,
  worksite,
  projinfo,
  contacts,
}

enum topBarChoice {
  worksitelist,
  checklist,
}