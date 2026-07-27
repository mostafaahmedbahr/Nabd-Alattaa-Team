import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dartz/dartz.dart';

import '../../../../core/constants/firestore_constants.dart';
import '../../../../core/error/failures.dart';
import '../../auth/data/models/user_model.dart';
import '../models/department_model.dart';
import '../repos/admin_repo.dart';

class AdminRepoImpl implements AdminRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  Future<Either<Failure, List<UserModel>>> getEmployees() async {
    try {
      final snapshot = await _firestore
          .collection(FirestoreConstants.users)
          .orderBy(FirestoreConstants.userCreatedAt, descending: true)
          .get();

      final employees = snapshot.docs
          .map((doc) => UserModel.fromMap(doc.data()))
          .toList();

      return Right(employees);
    } catch (e) {
      return Left(FirestoreFailure(
        message: 'فشل في تحميل الموظفين: ${e.toString()}',
      ));
    }
  }

  @override
  Future<Either<Failure, List<DepartmentModel>>> getDepartments() async {
    try {
      final snapshot =
          await _firestore.collection(FirestoreConstants.departments).get();

      final departments = snapshot.docs
          .map((doc) => DepartmentModel.fromMap(doc.data(), docId: doc.id))
          .toList();

      return Right(departments);
    } catch (e) {
      return Left(FirestoreFailure(
        message: 'فشل في تحميل الأقسام: ${e.toString()}',
      ));
    }
  }

  @override
  Future<Either<Failure, void>> updateEmployeeRole(
      String userId, String newRole) async {
    try {
      await _firestore
          .collection(FirestoreConstants.users)
          .doc(userId)
          .update({FirestoreConstants.userRole: newRole});

      return const Right(null);
    } catch (e) {
      return Left(FirestoreFailure(
        message: 'فشل في تحديث الصلاحية: ${e.toString()}',
      ));
    }
  }

  @override
  Future<Either<Failure, void>> createDepartment(
      DepartmentModel department) async {
    try {
      await _firestore
          .collection(FirestoreConstants.departments)
          .add(department.toMap());

      return const Right(null);
    } catch (e) {
      return Left(FirestoreFailure(
        message: 'فشل في إنشاء القسم: ${e.toString()}',
      ));
    }
  }

  @override
  Future<Either<Failure, Map<String, int>>> getStatistics() async {
    try {
      final usersSnapshot =
          await _firestore.collection(FirestoreConstants.users).get();
      final tasksSnapshot =
          await _firestore.collection(FirestoreConstants.tasks).get();
      final complaintsSnapshot =
          await _firestore.collection(FirestoreConstants.complaints).get();

      int openTasks = 0;
      int openComplaints = 0;

      for (final doc in tasksSnapshot.docs) {
        final status = doc.data()[FirestoreConstants.taskStatus];
        if (status != TaskStatus.completed) {
          openTasks++;
        }
      }

      for (final doc in complaintsSnapshot.docs) {
        final status = doc.data()[FirestoreConstants.complaintStatus];
        if (status == ComplaintStatus.pending ||
            status == ComplaintStatus.inProgress) {
          openComplaints++;
        }
      }

      final stats = {
        'totalEmployees': usersSnapshot.docs.length,
        'totalTasks': tasksSnapshot.docs.length,
        'openTasks': openTasks,
        'openComplaints': openComplaints,
      };

      return Right(stats);
    } catch (e) {
      return Left(FirestoreFailure(
        message: 'فشل في تحميل الإحصائيات: ${e.toString()}',
      ));
    }
  }
}
