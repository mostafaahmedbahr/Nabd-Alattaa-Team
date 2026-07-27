import 'package:dartz/dartz.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../../../../core/constants/firestore_constants.dart';
import '../../../../core/error/failures.dart';
import '../models/register_model.dart';

class RegisterRepoImpl {
  final FirebaseAuth firebaseAuth;
  final FirebaseFirestore firestore;

  RegisterRepoImpl({
    required this.firebaseAuth,
    required this.firestore,
  });

  Future<Either<Failure, String>> register({
    required RegisterModel registerData,
  }) async {
    try {
      final credential = await firebaseAuth.createUserWithEmailAndPassword(
        email: registerData.email,
        password: registerData.password,
      );

      if (credential.user != null) {
        final userId = credential.user!.uid;

        final userData = registerData.toMap();
        userData['user_id'] = userId;

        await firestore
            .collection(FirestoreConstants.users)
            .doc(userId)
            .set(userData);

        return Right(userId);
      }

      return const Left(AuthFailure(
        message: 'فشل في إنشاء الحساب',
      ));
    } on FirebaseAuthException catch (e) {
      return Left(AuthFailure(
        message: _getErrorMessage(e.code),
      ));
    } catch (e) {
      return Left(AuthFailure(
        message: 'حدث خطأ غير متوقع: ${e.toString()}',
      ));
    }
  }

  String _getErrorMessage(String code) {
    switch (code) {
      case 'email-already-in-use':
        return 'البريد الإلكتروني مستخدم بالفعل';
      case 'invalid-email':
        return 'البريد الإلكتروني غير صالح';
      case 'operation-not-allowed':
        return 'تسجيل الحسابات غير مسموح بها';
      case 'weak-password':
        return 'كلمة المرور ضعيفة جداً';
      default:
        return 'حدث خطأ أثناء إنشاء الحساب';
    }
  }
}
