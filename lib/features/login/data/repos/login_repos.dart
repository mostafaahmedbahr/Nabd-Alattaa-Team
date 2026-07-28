import 'package:dartz/dartz.dart';

import '../../../../core/error/failures.dart';

abstract class LoginRepository {
  Future<Either<Failure, String>> login({
    required String email,
    required String password,
  });

  Future<Either<Failure, void>> resetPassword({required String email});
}
