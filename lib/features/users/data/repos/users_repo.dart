// users_repo.dart
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dartz/dartz.dart';
import 'package:nabd_alattaa_team/core/error/failures.dart';

import '../models/user_model.dart';


class UsersRepo {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final CollectionReference _usersCollection =
  FirebaseFirestore.instance.collection('users');

  // جلب جميع المستخدمين
  Future<Either<Failure, List<UserModel>>> getAllUsers() async {
    try {
      print('📦 [UsersRepo] getAllUsers() - Fetching from Firestore...');
      final QuerySnapshot snapshot = await _usersCollection.get();
      print('📦 [UsersRepo] getAllUsers() - Got ${snapshot.docs.length} documents');

      final List<UserModel> users = snapshot.docs.map((doc) {
        final data = doc.data() as Map<String, dynamic>;
        print('📦 [UsersRepo] Processing doc: ${doc.id} => $data');
        return UserModel.fromJson({...data, 'id': doc.id});
      }).toList();
      print('📦 [UsersRepo] getAllUsers() - Fetched ${users.length} users from Firestore');
      // ترتيب المستخدمين حسب التاريخ (الأحدث أولاً)
      users.sort((a, b) {
        if (a.createdAt == null) return 1;
        if (b.createdAt == null) return -1;
        return b.createdAt!.compareTo(a.createdAt!);
      });

      return Right(users);
    } catch (e, stackTrace) {
      print('❌ [UsersRepo] getAllUsers() ERROR: $e');
      print('❌ [UsersRepo] Stack trace: $stackTrace');
      return Left(ServerFailure(message: 'حدث خطأ في جلب المستخدمين: $e'));
    }
  }

  // جلب المستخدمين حسب الدور
  Future<Either<Failure, List<UserModel>>> getUsersByRole(String role) async {
    try {
      final QuerySnapshot snapshot = await _usersCollection
          .where('role', isEqualTo: role)
          .get();

      final List<UserModel> users = snapshot.docs.map((doc) {
        final data = doc.data() as Map<String, dynamic>;
        return UserModel.fromJson({...data, 'id': doc.id});
      }).toList();

      return Right(users);
    } catch (e) {
      return Left(ServerFailure(message: 'حدث خطأ في جلب المستخدمين: $e'));
    }
  }

  // جلب المستخدمين حسب الحالة
  Future<Either<Failure, List<UserModel>>> getUsersByStatus(String status) async {
    try {
      final QuerySnapshot snapshot = await _usersCollection
          .where('status', isEqualTo: status)
          .get();

      final List<UserModel> users = snapshot.docs.map((doc) {
        final data = doc.data() as Map<String, dynamic>;
        return UserModel.fromJson({...data, 'id': doc.id});
      }).toList();

      return Right(users);
    } catch (e) {
      return Left(ServerFailure(message: 'حدث خطأ في جلب المستخدمين: $e'));
    }
  }

  // تحديث حالة المستخدم
  Future<Either<Failure, void>> updateUserStatus(
      String userId,
      String newStatus
      ) async {
    try {
      await _usersCollection.doc(userId).update({
        'status': newStatus,
        'updatedAt': FieldValue.serverTimestamp(),
      });
      return const Right(null);
    } catch (e) {
      return Left(ServerFailure(message: 'حدث خطأ في تحديث حالة المستخدم: $e'));
    }
  }

  // جلب مستخدم واحد حسب المعرف
  Future<Either<Failure, UserModel>> getUserById(String userId) async {
    try {
      final DocumentSnapshot doc = await _usersCollection.doc(userId).get();

      if (!doc.exists) {
        return Left(ServerFailure(message: 'المستخدم غير موجود'));
      }

      final data = doc.data() as Map<String, dynamic>;
      final user = UserModel.fromJson({...data, 'id': doc.id});

      return Right(user);
    } catch (e) {
      return Left(ServerFailure(message: 'حدث خطأ في جلب المستخدم: $e'));
    }
  }

  // البحث عن المستخدمين
  Future<Either<Failure, List<UserModel>>> searchUsers(String query) async {
    try {
      // بحث بالاسم أو البريد الإلكتروني
      final QuerySnapshot snapshot = await _usersCollection
          .where('name', isGreaterThanOrEqualTo: query)
          .where('name', isLessThanOrEqualTo: '$query\uf8ff')
          .get();

      final List<UserModel> users = snapshot.docs.map((doc) {
        final data = doc.data() as Map<String, dynamic>;
        return UserModel.fromJson({...data, 'id': doc.id});
      }).toList();

      return Right(users);
    } catch (e) {
      return Left(ServerFailure(message: 'حدث خطأ في البحث عن المستخدمين: $e'));
    }
  }
}