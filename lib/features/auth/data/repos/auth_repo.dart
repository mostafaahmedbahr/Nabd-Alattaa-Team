import 'package:dartz/dartz.dart';

import '../../../../core/error/failures.dart';

abstract class AuthRepository {
  Future<Either<Failure, String>> login({
    required String email,
    required String password,
  });

  Future<Either<Failure, void>> logout();

  Future<Either<Failure, void>> resetPassword({required String email});

  Future<Either<Failure, String>> getCurrentUserId();

  Future<bool> isLoggedIn();
}
