import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dartz/dartz.dart';
import '../../../../core/constants/firestore_constants.dart';
import '../../../../core/error/failures.dart';
import '../../../complaints/data/models/complaint_model.dart';
import '../../../ideas/data/models/idea_model.dart';
import '../../../users/data/models/user_model.dart';
import '../models/department_model.dart';
import '../models/employee_stats_model.dart';
import '../repos/admin_repo.dart';

class AdminRepoImpl implements AdminRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  Future<Either<Failure, List<UserModel>>> getEmployees() async {
    try {
      final snapshot = await _firestore
          .collection(FirestoreConstants.users)
          .orderBy(FirestoreConstants.userCreatedAt,
          descending: true)
          .get();

      final employees = snapshot.docs
          .map((doc) => UserModel.fromJson(doc.data(), doc.id))
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

  @override
  Future<Either<Failure, void>> updateUserActive(
      String userId, bool isActive) async {
    try {
      await _firestore
          .collection(FirestoreConstants.users)
          .doc(userId)
          .update({FirestoreConstants.userIsActive: isActive});

      return const Right(null);
    } catch (e) {
      return Left(FirestoreFailure(
        message: 'فشل في تحديث حالة التفعيل: ${e.toString()}',
      ));
    }
  }

  @override
  Future<Either<Failure, void>> addUserPoints(
      String userId, int amount) async {
    try {
      final doc = await _firestore
          .collection(FirestoreConstants.users)
          .doc(userId)
          .get();

      if (!doc.exists) {
        return Left(FirestoreFailure(message: 'المستخدم غير موجود'));
      }

      final currentPoints =
          (doc.data()?[FirestoreConstants.userPoints] as int?) ?? 0;
      final newPoints = currentPoints + amount;

      await _firestore
          .collection(FirestoreConstants.users)
          .doc(userId)
          .update({FirestoreConstants.userPoints: newPoints});

      return const Right(null);
    } catch (e) {
      return Left(FirestoreFailure(
        message: 'فشل في إضافة النقاط: ${e.toString()}',
      ));
    }
  }

  @override
  Future<Either<Failure, EmployeeStats>> getEmployeeStats(String userId) async {
    try {
      final tasksSnapshot = await _firestore
          .collection(FirestoreConstants.tasks)
          .where(FirestoreConstants.taskAssigneeId, isEqualTo: userId)
          .get();

      int totalTasks = tasksSnapshot.docs.length;
      int completedTasks = 0;
      int inProgressTasks = 0;
      int openTasks = 0;

      for (final doc in tasksSnapshot.docs) {
        final status = doc.data()[FirestoreConstants.taskStatus] as String? ?? '';
        if (status == TaskStatus.completed) {
          completedTasks++;
        } else if (status == TaskStatus.inProgress) {
          inProgressTasks++;
        } else if (status != TaskStatus.completed) {
          openTasks++;
        }
      }

      final complaintsSnapshot = await _firestore
          .collection(FirestoreConstants.complaints)
          .where(FirestoreConstants.complaintCreatorId, isEqualTo: userId)
          .get();

      final ideasSnapshot = await _firestore
          .collection(FirestoreConstants.ideas)
          .where(FirestoreConstants.ideaCreatorId, isEqualTo: userId)
          .get();

      final userDoc = await _firestore
          .collection(FirestoreConstants.users)
          .doc(userId)
          .get();

      final userData = userDoc.data();
      final points = (userData?[FirestoreConstants.userPoints] as int?) ?? 0;
      final isActive =
          (userData?[FirestoreConstants.userIsActive] as bool?) ?? true;

      return Right(EmployeeStats(
        userId: userId,
        totalTasks: totalTasks,
        completedTasks: completedTasks,
        inProgressTasks: inProgressTasks,
        openTasks: openTasks,
        totalComplaints: complaintsSnapshot.docs.length,
        totalIdeas: ideasSnapshot.docs.length,
        points: points,
        isActive: isActive,
      ));
    } catch (e) {
      return Left(FirestoreFailure(
        message: 'فشل في تحميل إحصائيات الموظف: ${e.toString()}',
      ));
    }
  }

  @override
  Future<Either<Failure, List<ComplaintModel>>> getComplaints() async {
    try {
      final snapshot = await _firestore
          .collection(FirestoreConstants.complaints)
          .orderBy(FirestoreConstants.complaintCreatedAt, descending: true)
          .get();

      final complaints = snapshot.docs
          .map((doc) =>
              ComplaintModel.fromMap(doc.data()..['complaint_id'] = doc.id))
          .toList();

      return Right(complaints);
    } catch (e) {
      return Left(FirestoreFailure(
        message: 'فشل في تحميل الشكاوى: ${e.toString()}',
      ));
    }
  }

  @override
  Future<Either<Failure, void>> updateComplaintStatus(
      String complaintId, String status) async {
    try {
      await _firestore
          .collection(FirestoreConstants.complaints)
          .doc(complaintId)
          .update({
        FirestoreConstants.complaintStatus: status,
        FirestoreConstants.complaintUpdatedAt: Timestamp.now(),
      });

      return const Right(null);
    } catch (e) {
      return Left(FirestoreFailure(
        message: 'فشل في تحديث حالة الشكوى: ${e.toString()}',
      ));
    }
  }

  @override
  Future<Either<Failure, List<IdeaModel>>> getIdeas() async {
    try {
      final snapshot = await _firestore
          .collection(FirestoreConstants.ideas)
          .orderBy(FirestoreConstants.ideaCreatedAt, descending: true)
          .get();

      final ideas = snapshot.docs
          .map((doc) => IdeaModel.fromMap(doc.data()..['idea_id'] = doc.id))
          .toList();

      return Right(ideas);
    } catch (e) {
      return Left(FirestoreFailure(
        message: 'فشل في تحميل الأفكار: ${e.toString()}',
      ));
    }
  }

  @override
  Future<Either<Failure, void>> updateIdeaStatus(
      String ideaId, String status, int rating) async {
    try {
      await _firestore
          .collection(FirestoreConstants.ideas)
          .doc(ideaId)
          .update({
        FirestoreConstants.ideaStatus: status,
        FirestoreConstants.ideaRating: rating,
        FirestoreConstants.ideaUpdatedAt: Timestamp.now(),
      });

      return const Right(null);
    } catch (e) {
      return Left(FirestoreFailure(
        message: 'فشل في تحديث حالة الفكرة: ${e.toString()}',
      ));
    }
  }
}
