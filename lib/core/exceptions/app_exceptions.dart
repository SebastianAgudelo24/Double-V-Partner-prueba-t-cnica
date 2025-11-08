class AppException implements Exception {
  final String message;
  final String? code;

  const AppException(this.message, {this.code});

  @override
  String toString() => 'AppException: $message ${code != null ? '($code)' : ''}';
}

class ValidationException extends AppException {
  const ValidationException(super.message, {super.code});

  @override
  String toString() => 'ValidationException: $message';
}

class NetworkException extends AppException {
  const NetworkException(super.message, {super.code});

  @override
  String toString() => 'NetworkException: $message';
}

class AuthException extends AppException {
  const AuthException(super.message, {super.code});

  @override
  String toString() => 'AuthException: $message';
}

class ServerException extends AppException {
  const ServerException(super.message, {super.code});

  @override
  String toString() => 'ServerException: $message';
}

class UnexpectedException extends AppException {
  const UnexpectedException(super.message, {super.code});

  @override
  String toString() => 'UnexpectedException: $message';
}
