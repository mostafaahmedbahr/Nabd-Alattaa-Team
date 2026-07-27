import 'package:dartz/dartz.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../core/constants/firestore_constants.dart';
import '../../../../core/error/exceptions.dart';
import '../../../../core/error/failures.dart';
import '../repos/auth_repo.dart';

class AuthRepoImpl implements AuthRepository {
  final FirebaseAuth firebaseAuth;
  final FirebaseFirestore firestore;
  final SharedPreferences sharedPreferences;

  AuthRepoImpl({
    required this.firebaseAuth,
    required this.firestore,
    required this.sharedPreferences,
  });

  @override
  Future<Either<Failure, String>> login({
    required String email,
    required String password,
  }) async {
    try {
      final credential = await firebaseAuth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      if (credential.user != null) {
        final userId = credential.user!.uid;

        final userDoc = await firestore
            .collection(FirestoreConstants.users)
            .doc(userId)
            .get();

        if (userDoc.exists) {
          final userData = userDoc.data();
          if (userData != null && userData['is_active'] == true) {
            await sharedPreferences.setString('user_id', userId);
            return Right(userId);
          } else {
            await firebaseAuth.signOut();
            return const Left(AuthFailure(
              message: 'هذا الحساب غير نشط',
            ));
          }
        } else {
          return const Left(AuthFailure(
            message: 'لم يتم العثور على بيانات المستخدم',
          ));
        }
      }

      return const Left(AuthFailure(
        message: 'البريد الإلكتروني أو كلمة المرور غير صحيحة',
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

  @override
  Future<Either<Failure, void>> logout() async {
    try {
      await firebaseAuth.signOut();
      await sharedPreferences.remove('user_id');
      return const Right(null);
    } catch (e) {
      return Left(AuthFailure(
        message: 'حدث خطأ أثناء تسجيل الخروج',
      ));
    }
  }

  @override
  Future<Either<Failure, void>> resetPassword({required String email}) async {
    try {
      await firebaseAuth.sendPasswordResetEmail(email: email);
      return const Right(null);
    } on FirebaseAuthException catch (e) {
      return Left(AuthFailure(
        message: _getErrorMessage(e.code),
      ));
    } catch (e) {
      return Left(AuthFailure(
        message: 'حدث خطأ أثناء إرسال رابط إعادة التعيين',
      ));
    }
  }

  @override
  Future<Either<Failure, String>> getCurrentUserId() async {
    try {
      final user = firebaseAuth.currentUser;
      if (user != null) {
        return Right(user.uid);
      }
      return const Left(AuthFailure(
        message: 'لم يتم تسجيل الدخول',
      ));
    } catch (e) {
      return Left(AuthFailure(
        message: 'حدث خطأ',
      ));
    }
  }

  @override
  Future<bool> isLoggedIn() async {
    return firebaseAuth.currentUser != null;
  }

  String _getErrorMessage(String code) {
    switch (code) {
      case 'user-not-found':
        return 'لم يتم العثور على مستخدم بهذا البريد الإلكتروني';
      case 'wrong-password':
        return 'كلمة المرور غير صحيحة';
      case 'invalid-email':
        return 'البريد الإلكتروني غير صالح';
      case 'user-disabled':
        return 'تم تعطيل هذا الحساب';
      case 'too-many-requests':
        return 'تم تجاوز عدد المحاولات المسموح بها. حاول مرة أخرى لاحقاً';
      case 'operation-not-allowed':
        return 'طريقة تسجيل الدخول هذه غير مسموح بها';
      case 'invalid-credential':
        return 'البريد الإلكتروني أو كلمة المرور غير صحيحة';
      default:
        return 'حدث خطأ غير متوقع';
    }
  }
}
