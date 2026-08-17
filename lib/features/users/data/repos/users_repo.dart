import 'package:dartz/dartz.dart';

import '../../../../core/error/failures.dart';
import '../models/user_model.dart';

abstract class UsersRepo {
  Future<Either<Failure, List<UserModel>>> getAllUsers();

  Future<Either<Failure, List<UserModel>>> searchUsers(String query);
}