import 'package:dartz/dartz.dart';

import '../../../../core/error/failures.dart';
import '../models/user_profile_model.dart';

abstract class ProfileRepository {
  Future<Either<Failure, UserProfileModel>> getProfile(String userId);
  Future<Either<Failure, void>> updateProfile(
      String userId, Map<String, dynamic> data);
}
