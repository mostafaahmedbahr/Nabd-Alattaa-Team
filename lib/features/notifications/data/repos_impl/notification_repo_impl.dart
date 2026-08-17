import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dartz/dartz.dart';

import '../../../../core/constants/firestore_constants.dart';
import '../../../../core/error/failures.dart';
import '../models/notification_model.dart';
import '../repos/notification_repo.dart';

class NotificationRepoImpl implements NotificationRepository {
  final FirebaseFirestore _firestore;

  NotificationRepoImpl({FirebaseFirestore? firestore})
      : _firestore = firestore ?? FirebaseFirestore.instance;

  @override
  Stream<Either<Failure, List<NotificationModel>>> getNotifications(String userId) {
    try {
      final stream = _firestore
          .collection(FirestoreConstants.notifications)
          .where(FirestoreConstants.userId, isEqualTo: userId)
          .orderBy(FirestoreConstants.notificationCreatedAt, descending: true)
          .snapshots();

      return stream.map((snapshot) {
        final notifications = snapshot.docs
            .map((doc) => NotificationModel.fromMap(doc.data()..['id'] = doc.id))
            .toList();

        notifications.sort((a, b) => b.createdAt.compareTo(a.createdAt));

        return Right(notifications);
      });
    } catch (e) {
      return Stream.value(
        Left(FirestoreFailure(message: 'فشل في تحميل التنبيهات: ${e.toString()}')),
      );
    }
  }

  @override
  Future<Either<Failure, void>> markAsRead(String notificationId) async {
    try {
      await _firestore
          .collection(FirestoreConstants.notifications)
          .doc(notificationId)
          .update({FirestoreConstants.notificationIsRead: true});

      return const Right(null);
    } catch (e) {
      return Left(FirestoreFailure(
        message: 'فشل في تحديث التنبيه: ${e.toString()}',
      ));
    }
  }

  @override
  Future<Either<Failure, void>> markAllAsRead(String userId) async {
    try {
      final snapshot = await _firestore
          .collection(FirestoreConstants.notifications)
          .where(FirestoreConstants.userId, isEqualTo: userId)
          .where(FirestoreConstants.notificationIsRead, isEqualTo: false)
          .get();

      final batch = _firestore.batch();
      for (final doc in snapshot.docs) {
        batch.update(doc.reference, {FirestoreConstants.notificationIsRead: true});
      }
      await batch.commit();

      return const Right(null);
    } catch (e) {
      return Left(FirestoreFailure(
        message: 'فشل في تحديث التنبيهات: ${e.toString()}',
      ));
    }
  }

  @override
  Future<Either<Failure, int>> getUnreadCount(String userId) async {
    try {
      final snapshot = await _firestore
          .collection(FirestoreConstants.notifications)
          .where(FirestoreConstants.userId, isEqualTo: userId)
          .where(FirestoreConstants.notificationIsRead, isEqualTo: false)
          .get();

      return Right(snapshot.docs.length);
    } catch (e) {
      return Left(FirestoreFailure(
        message: 'فشل في جلب عدد التنبيهات: ${e.toString()}',
      ));
    }
  }
}
