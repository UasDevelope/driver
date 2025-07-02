/// Base API exception with a customizable message.
class ApiException implements Exception {
  final String message;

  ApiException({required this.message});

  @override
  String toString() => 'ApiException: $message';
}

/// Exception for unauthorized access (401).
class UnauthorizedException extends ApiException {
  UnauthorizedException()
      : super(message: "Unauthorized access. Please login again.");
}

/// Exception for 404 Not Found.
class NotFoundException extends ApiException {
  NotFoundException()
      : super(message: "Requested resource was not found.");
}

/// Exception for 400 Bad Request, usually with a dynamic message.
class BadRequestException extends ApiException {
  BadRequestException(String msg)
      : super(message: msg);
}

/// Exception for 500 Internal Server Error.
class InternalServerError extends ApiException {
  InternalServerError()
      : super(message: "Internal server error. Please try again later.");
}

/// Generic fallback exception when the type is unknown.
class UnknownApiException extends ApiException {
  UnknownApiException(String msg)
      : super(message: msg);
}
