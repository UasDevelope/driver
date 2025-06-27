class ApiException implements Exception {
  final String message;
  ApiException({required this.message});
}

class UnauthorizedException extends ApiException {
  UnauthorizedException() : super(message: "Unauthorized");
}

class NotFoundException extends ApiException {
  NotFoundException() : super(message: "Resource not found");
}

class BadRequestException extends ApiException {
  BadRequestException(String msg) : super(message: msg);
}

class InternalServerError extends ApiException {
  InternalServerError() : super(message: "Internal Server Error");
}
