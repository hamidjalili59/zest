import 'package:equatable/equatable.dart';

abstract class Failure extends Equatable {
  final String message;
  final int? statusCode;

  const Failure({required this.message, this.statusCode});

  @override
  List<Object?> get props => [message, statusCode];
}

class ServerFailure extends Failure {
  const ServerFailure({required super.message, super.statusCode});
}

class CacheFailure extends Failure {
  const CacheFailure({required super.message});
}

class NetworkFailure extends Failure {
  const NetworkFailure({required super.message});
}

class ValidationFailure extends Failure {
  final Map<String, List<String>>? errors;

  const ValidationFailure({required super.message, this.errors});

  @override
  List<Object?> get props => [message, statusCode, errors];
}

class AuthFailure extends Failure {
  const AuthFailure({required super.message, super.statusCode});
}

class PermissionFailure extends Failure {
  const PermissionFailure({required super.message, super.statusCode});
}

class DatabaseFailure extends Failure {
  const DatabaseFailure({required super.message});
}

class UnexpectedFailure extends Failure {
  const UnexpectedFailure({required super.message});
}

class NotFoundFailure extends Failure {
  const NotFoundFailure({required super.message, super.statusCode});
}
