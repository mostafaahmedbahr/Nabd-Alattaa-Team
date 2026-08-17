import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dartz/dartz.dart';
import '../../../../core/constants/firestore_constants.dart';
import '../../../../core/error/failures.dart';
import '../models/home_data_model.dart';
import 'home_repo.dart';

class HomeRepoImpl implements HomeRepository {
  final FirebaseFirestore _firestore;

  HomeRepoImpl({FirebaseFirestore? firestore})
      : _firestore = firestore ?? FirebaseFirestore.instance;

  @override
  Future<Either<Failure, HomeData>> getHomeData(String userId) async {
    try {
      final userDoc = await _firestore
          .collection(FirestoreConstants.users)
          .doc(userId)
          .get();

      String userName = 'مستخدم';
      if (userDoc.exists) {
        userName =
            userDoc.data()?[FirestoreConstants.userName] ?? 'مستخدم';
      }

      final announcementsSnap = await _firestore
          .collection(FirestoreConstants.announcements)
          .orderBy(FirestoreConstants.announcementCreatedAt, descending: true)
          .limit(3)
          .get();

      final announcements = announcementsSnap.docs.map((doc) {
        final data = doc.data();
        return {
          'id': doc.id,
          'title': data[FirestoreConstants.announcementTitle] ?? '',
          'subtitle': data[FirestoreConstants.announcementContent] ?? '',
          'createdAt': data[FirestoreConstants.announcementCreatedAt],
        };
      }).toList();

      final tasksSnap = await _firestore
          .collection(FirestoreConstants.tasks)
          .where(FirestoreConstants.taskAssigneeId, isEqualTo: userId)
          .orderBy(FirestoreConstants.taskCreatedAt, descending: true)
          .limit(3)
          .get();

      final allTasksSnap = await _firestore
          .collection(FirestoreConstants.tasks)
          .where(FirestoreConstants.taskAssigneeId, isEqualTo: userId)
          .get();

      final tasks = tasksSnap.docs.map((doc) {
        final data = doc.data();
        return {
          'id': doc.id,
          'title': data[FirestoreConstants.taskTitle] ?? '',
          'subtitle': data[FirestoreConstants.taskDescription] ?? '',
          'status': data[FirestoreConstants.taskStatus] ?? 'not_started',
        };
      }).toList();

      return Right(HomeData(
        userName: userName,
        announcements: announcements,
        tasks: tasks,
        totalTasksCount: allTasksSnap.docs.length,
      ));
    } catch (e) {
      return Left(FirestoreFailure(
        message: 'فشل في تحميل بيانات الرئيسية: ${e.toString()}',
      ));
    }
  }

  @override
  Stream<int> getGoodDeedsCount(String userId) =>
      _countStream(FirestoreConstants.goodDeeds, FirestoreConstants.goodDeedCreatorId, userId);

  @override
  Stream<int> getComplaintsCount(String userId) => _countStream(
      FirestoreConstants.complaints, FirestoreConstants.complaintCreatorId, userId);

  @override
  Stream<int> getIdeasCount(String userId) =>
      _countStream(FirestoreConstants.ideas, FirestoreConstants.ideaCreatorId, userId);

  Stream<int> _countStream(String collection, String creatorField, String userId) {
    try {
      return _firestore
          .collection(collection)
          .where(creatorField, isEqualTo: userId)
          .snapshots()
          .map((snapshot) => snapshot.docs.length);
    } catch (e) {
      return Stream.value(0);
    }
  }
}
