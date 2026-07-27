import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dartz/dartz.dart';

import '../../../../core/constants/firestore_constants.dart';
import '../../../../core/error/failures.dart';
import '../models/user_profile_model.dart';
import '../repos/profile_repo.dart';

class ProfileRepoImpl implements ProfileRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  Future<Either<Failure, UserProfileModel>> getProfile(String userId) async {
    try {
      final doc = await _firestore
          .collection(FirestoreConstants.users)
          .doc(userId)
          .get();

      if (!doc.exists) {
        return const Left(FirestoreFailure(
          message: 'لم يتم العثور على بيانات المستخدم',
        ));
      }

      final data = doc.data()!;
      final profile = UserProfileModel.fromMap(data);
      return Right(profile);
    } catch (e) {
      return Left(FirestoreFailure(
        message: 'فشل في تحميل الملف الشخصي: ${e.toString()}',
      ));
    }
  }

  @override
  Future<Either<Failure, void>> updateProfile(
      String userId, Map<String, dynamic> data) async {
    try {
      await _firestore
          .collection(FirestoreConstants.users)
          .doc(userId)
          .update(data);

      return const Right(null);
    } catch (e) {
      return Left(FirestoreFailure(
        message: 'فشل في تحديث الملف الشخصي: ${e.toString()}',
      ));
    }
  }
}
