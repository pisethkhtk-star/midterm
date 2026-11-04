class AppException implements Exception {
  final String message;
  final String? code;
  final int? statusCode;

  AppException(this.message, {this.code, this.statusCode});

  @override
  String toString() => message;
}

class NetworkException extends AppException {
  NetworkException([super.message = 'Cannot connect to server. Please check your network.'])
      : super(statusCode: 0);
}

class UnauthorizedException extends AppException {
  UnauthorizedException([super.message = 'Session expired. Please log in again.'])
      : super(statusCode: 401);
}

class ForbiddenException extends AppException {
  ForbiddenException([super.message = 'You do not have permission to perform this action.'])
      : super(statusCode: 403);
}

class NotFoundException extends AppException {
  NotFoundException([super.message = 'Requested resource not found.'])
      : super(statusCode: 404);
}

class ValidationException extends AppException {
  ValidationException(super.message, {super.code})
      : super(statusCode: 400);
}

class ServerException extends AppException {
  ServerException([super.message = 'Server error occurred. Please try again later.'])
      : super(statusCode: 500);
}

