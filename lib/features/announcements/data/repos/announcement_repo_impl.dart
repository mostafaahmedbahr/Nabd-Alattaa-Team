import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dartz/dartz.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../../../../core/constants/firestore_constants.dart';
import '../../../../core/error/failures.dart';
import '../models/announcement_model.dart';
import 'announcement_repo.dart';

class AnnouncementRepoImpl implements AnnouncementRepository {
  final FirebaseFirestore _firestore;

  AnnouncementRepoImpl({FirebaseFirestore? firestore})
      : _firestore = firestore ?? FirebaseFirestore.instance;

  @override
  Stream<Either<Failure, List<AnnouncementModel>>> getAnnouncements() {
    try {
      return _firestore
          .collection(FirestoreConstants.announcements)
          .orderBy(FirestoreConstants.announcementCreatedAt, descending: true)
          .snapshots()
          .map(
            (snapshot) {
              final announcements = snapshot.docs
                  .map(
                    (doc) => AnnouncementModel.fromMap(
                      doc.data(),
                      doc.id,
                    ),
                  )
                  .toList();

              return Right<Failure, List<AnnouncementModel>>(announcements);
            },
          );
    } catch (e) {
      return Stream.value(
        Left(
          FirestoreFailure(message: 'فشل في تحميل الإعلانات: ${e.toString()}'),
        ),
      );
    }
  }

  @override
  Future<Either<Failure, void>> createAnnouncement(
    AnnouncementModel announcement,
  ) async {
    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user == null) {
        return const Left(AuthFailure(message: 'يجب تسجيل الدخول أولاً'));
      }

      final userDoc = await _firestore
          .collection(FirestoreConstants.users)
          .doc(user.uid)
          .get();
      final creatorName =
          userDoc.data()?[FirestoreConstants.userName] ?? 'مستخدم';

      final docRef = await _firestore
          .collection(FirestoreConstants.announcements)
          .add({
        ...announcement.toMap(),
        FirestoreConstants.announcementCreatorId: user.uid,
        FirestoreConstants.announcementCreatorName: creatorName,
        FirestoreConstants.announcementCreatedAt: Timestamp.now(),
      });

      await _sendNotificationsToAllUsers(
        title: announcement.title,
        body: announcement.content,
        announcementId: docRef.id,
      );

      return const Right(null);
    } catch (e) {
      return Left(
        FirestoreFailure(message: 'فشل في إنشاء الإعلان: ${e.toString()}'),
      );
    }
  }

  Future<void> _sendNotificationsToAllUsers({
    required String title,
    required String body,
    required String announcementId,
  }) async {
    try {
      final usersSnapshot =
          await _firestore.collection(FirestoreConstants.users).get();

      final batch = _firestore.batch();

      for (final userDoc in usersSnapshot.docs) {
        final notificationRef =
            _firestore.collection(FirestoreConstants.notifications).doc();

        batch.set(notificationRef, {
          FirestoreConstants.userId: userDoc.id,
          FirestoreConstants.notificationTitle: title,
          FirestoreConstants.notificationBody: body,
          FirestoreConstants.notificationType: 'new_announcement',
          FirestoreConstants.notificationReferenceId: announcementId,
          FirestoreConstants.notificationIsRead: false,
          FirestoreConstants.notificationCreatedAt: Timestamp.now(),
        });
      }

      await batch.commit();
    } catch (e) {
      // Notification delivery is best-effort; it must not block creation.
    }
  }
}