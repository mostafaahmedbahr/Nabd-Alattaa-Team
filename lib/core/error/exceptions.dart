class AppException implements Exception {
  final String message;
  final int? statusCode;

  const AppException({required this.message, this.statusCode});

  @override
  String toString() => message;
}

class ServerException extends AppException {
  const ServerException({required super.message, super.statusCode});
}

class CacheException extends AppException {
  const CacheException({required super.message});
}

class AuthException extends AppException {
  const AuthException({required super.message, super.statusCode});
}

class FirestoreException extends AppException {
  const FirestoreException({required super.message, super.statusCode});
}

class ValidationException extends AppException {
  const ValidationException({required super.message});
}

class UnknownException extends AppException {
  const UnknownException({required super.message});
}
