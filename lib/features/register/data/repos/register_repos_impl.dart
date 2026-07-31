import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dartz/dartz.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:nabd_alattaa_team/features/register/data/repos/register_repos.dart';
import '../../../../core/constants/firestore_constants.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/services/fcm_service.dart';
import '../models/register_model.dart';


class RegisterRepoImpl implements RegisterRepo {
  final FirebaseAuth firebaseAuth;
  final FirebaseFirestore firestore;

  RegisterRepoImpl({
    required this.firebaseAuth,
    required this.firestore,
  });

  @override
  Future<Either<Failure, RegisterModel>> register({
    required RegisterModel registerData,
  }) async {
    try {
      // 1. Create user in Firebase Auth
      final credential = await firebaseAuth.createUserWithEmailAndPassword(
        email: registerData.email,
        password: registerData.password.toString(),
      );

      final user = credential.user;
      if (user == null) {
        return const Left(
          AuthFailure(message: 'فشل في إنشاء الحساب'),
        );
      }

      // 2. Get FCM token


      // 3. Create user data for Firestore
      final registerModel = RegisterModel(
        id: user.uid,
        name: registerData.name,
        email: registerData.email,
        phone: registerData.phone,
        role: 'employee',
        department: registerData.department,
        gender: registerData.gender,
        birthDate: registerData.birthDate,
        age: registerData.age,
        createdAt: DateTime.now(),
        isActive: false,
        points: 0,
        fcmToken: FCMService.token,
      );

      // 4. Save to Firestore
      await firestore
          .collection(FirestoreConstants.users)
          .doc(user.uid)
          .set(registerModel.toMap());

      // 5. Sign out so user goes to login screen
      await firebaseAuth.signOut();

      // 6. Return the created model
      return Right(registerModel);

    } on FirebaseAuthException catch (e) {
      return Left(
        AuthFailure(message: _getErrorMessage(e.code)),
      );
    } catch (e) {
      return Left(
        AuthFailure(message: 'حدث خطأ غير متوقع: ${e.toString()}'),
      );
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
      case 'network-request-failed':
        return 'يرجى التحقق من الاتصال بالإنترنت';
      default:
        return 'حدث خطأ أثناء إنشاء الحساب';
    }
  }
}