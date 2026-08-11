import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dartz/dartz.dart';
import 'package:nabd_alattaa_team/core/error/failures.dart';
import 'package:nabd_alattaa_team/core/utils/log_util.dart';
import '../models/user_model.dart';


class UsersRepo {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final CollectionReference _usersCollection =
  FirebaseFirestore.instance.collection('users');

  // جلب جميع المستخدمين
  Future<Either<Failure, List<UserModel>>> getAllUsers() async {
    try {
      final QuerySnapshot snapshot = await _usersCollection.get();
      logSuccess('📦 [UsersRepo] getAllUsers() - Got ${snapshot.docs.length} documents');
      final List<UserModel> users = snapshot.docs.map((doc) {
        final data = doc.data() as Map<String, dynamic>;
        logSuccess('📦 [UsersRepo] Processing doc: ${doc.id} => $data');
        return UserModel.fromJson({...data, 'id': doc.id});
      }).toList();
      logSuccess('📦 [UsersRepo] getAllUsers() - Fetched ${users.length} users from Firestore');
      // ترتيب المستخدمين حسب التاريخ (الأحدث أولاً)
      users.sort((a, b) {
        if (a.createdAt == null) return 1;
        if (b.createdAt == null) return -1;
        return b.createdAt!.compareTo(a.createdAt!);
      });

      return Right(users);
    } catch (e, stackTrace) {
      logError('❌ [UsersRepo] getAllUsers() ERROR: $e');
      logError('❌ [UsersRepo] Stack trace: $stackTrace');
      return Left(ServerFailure(message: 'حدث خطأ في جلب المستخدمين: $e'));
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