import 'package:dartz/dartz.dart';

import '../../../../core/error/failures.dart';
import '../models/register_model.dart';

abstract class RegisterRepo {
  Future<Either<Failure, RegisterModel>> register({
    required RegisterModel registerData,
  });
}