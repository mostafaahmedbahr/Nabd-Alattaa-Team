import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/utils/log_util.dart';
import '../models/user_model.dart';
import 'users_repo.dart';

class UsersRepoImpl implements UsersRepo {
  final FirebaseFirestore _firestore;

  UsersRepoImpl({
    FirebaseFirestore? firestore,
  }) : _firestore = firestore ?? FirebaseFirestore.instance;

  CollectionReference<Map<String, dynamic>> get _usersCollection =>
      _firestore.collection('users');

  @override
  Future<Either<Failure, List<UserModel>>> getAllUsers() async {
    try {
      final QuerySnapshot<Map<String, dynamic>> snapshot =
      await _usersCollection.get();

      logSuccess(
        '📦 [UsersRepoImpl] getAllUsers() - '
            'Got ${snapshot.docs.length} documents',
      );

      final List<UserModel> users = snapshot.docs.map((doc) {
        final data = doc.data();

        logSuccess(
          '📦 [UsersRepoImpl] Processing doc: ${doc.id} => $data',
        );

        return UserModel.fromJson({
          ...data,
          'id': doc.id,
        });
      }).toList();

      // الأحدث أولاً
      users.sort((a, b) {
        if (a.createdAt == null) return 1;
        if (b.createdAt == null) return -1;

        return b.createdAt!.compareTo(a.createdAt!);
      });

      logSuccess(
        '📦 [UsersRepoImpl] getAllUsers() - '
            'Fetched ${users.length} users',
      );

      return Right(users);
    } catch (e, stackTrace) {
      logError(
        '❌ [UsersRepoImpl] getAllUsers() ERROR: $e',
      );

      logError(
        '❌ [UsersRepoImpl] Stack trace: $stackTrace',
      );

      return Left(
        ServerFailure(
          message: 'حدث خطأ في جلب المستخدمين: $e',
        ),
      );
    }
  }

  @override
  Future<Either<Failure, List<UserModel>>> searchUsers(
      String query,
      ) async {
    try {
      final String searchQuery = query.trim();

      if (searchQuery.isEmpty) {
        return getAllUsers();
      }

      final QuerySnapshot<Map<String, dynamic>> snapshot =
      await _usersCollection
          .where(
        'name',
        isGreaterThanOrEqualTo: searchQuery,
      )
          .where(
        'name',
        isLessThanOrEqualTo: '$searchQuery\uf8ff',
      )
          .get();

      final List<UserModel> users = snapshot.docs.map((doc) {
        final data = doc.data();

        return UserModel.fromJson({
          ...data,
          'id': doc.id,
        });
      }).toList();

      // الأحدث أولاً
      users.sort((a, b) {
        if (a.createdAt == null) return 1;
        if (b.createdAt == null) return -1;

        return b.createdAt!.compareTo(a.createdAt!);
      });

      logSuccess(
        '🔎 [UsersRepoImpl] searchUsers("$searchQuery") - '
            'Found ${users.length} users',
      );

      return Right(users);
    } catch (e, stackTrace) {
      logError(
        '❌ [UsersRepoImpl] searchUsers ERROR: $e',
      );

      logError(
        '❌ [UsersRepoImpl] Stack trace: $stackTrace',
      );

      return Left(
        ServerFailure(
          message: 'حدث خطأ في البحث عن المستخدمين: $e',
        ),
      );
    }
  }
}