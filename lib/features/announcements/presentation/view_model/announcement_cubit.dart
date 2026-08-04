import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

import '../../../../core/constants/firestore_constants.dart';
import 'announcement_state.dart';

class AnnouncementCubit extends Cubit<AnnouncementState> {
  final FirebaseFirestore _firestore;

  AnnouncementCubit({FirebaseFirestore? firestore})
      : _firestore = firestore ?? FirebaseFirestore.instance,
        super(AnnouncementInitial());

  Future<void> loadAnnouncements() async {
    emit(AnnouncementLoading());
    try {
      final snapshot = await _firestore
          .collection(FirestoreConstants.announcements)
          .orderBy(FirestoreConstants.announcementCreatedAt, descending: true)
          .get();

      final announcements = snapshot.docs.map((doc) {
        final data = doc.data();
        return {
          'id': doc.id,
          'title': data[FirestoreConstants.announcementTitle] ?? '',
          'content': data[FirestoreConstants.announcementContent] ?? '',
          'type': data[FirestoreConstants.announcementType] ?? 'news',
          'creatorName': data[FirestoreConstants.announcementCreatorName] ?? '',
          'isPinned': data[FirestoreConstants.announcementIsPinned] ?? false,
          'createdAt': data[FirestoreConstants.announcementCreatedAt],
        };
      }).toList();

      emit(AnnouncementLoaded(announcements: announcements));
    } catch (e) {
      emit(AnnouncementError(message: 'فشل في تحميل الإعلانات: ${e.toString()}'));
    }
  }

  Future<void> createAnnouncement({
    required String title,
    required String content,
    required String type,
  }) async {
    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user == null) {
        emit(AnnouncementError(message: 'يجب تسجيل الدخول أولاً'));
        return;
      }

      final userDoc = await _firestore.collection(FirestoreConstants.users).doc(user.uid).get();
      final creatorName = userDoc.data()?[FirestoreConstants.userName] ?? 'مستخدم';

      final docRef = await _firestore.collection(FirestoreConstants.announcements).add({
        FirestoreConstants.announcementTitle: title,
        FirestoreConstants.announcementContent: content,
        FirestoreConstants.announcementType: type,
        FirestoreConstants.announcementCreatorId: user.uid,
        FirestoreConstants.announcementCreatorName: creatorName,
        FirestoreConstants.announcementIsPinned: false,
        FirestoreConstants.announcementCreatedAt: Timestamp.now(),
      });

      await _sendNotificationsToAllUsers(
        title: title,
        body: content,
        announcementId: docRef.id,
      );

      emit(AnnouncementCreated());
      await loadAnnouncements();
    } catch (e) {
      emit(AnnouncementError(message: 'فشل في إنشاء الإعلان: ${e.toString()}'));
    }
  }

  Future<void> _sendNotificationsToAllUsers({
    required String title,
    required String body,
    required String announcementId,
  }) async {
    try {
      final usersSnapshot = await _firestore.collection(FirestoreConstants.users).get();

      final batch = _firestore.batch();

      for (final userDoc in usersSnapshot.docs) {
        final notificationRef = _firestore.collection(FirestoreConstants.notifications).doc();

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
      print('Error sending notifications: $e');
    }
  }

  String formatDate(dynamic timestamp) {
    if (timestamp == null) return '';
    final date = (timestamp as Timestamp).toDate();
    final now = DateTime.now();
    final diff = now.difference(date);
    if (diff.inHours < 1) return 'منذ ${diff.inMinutes} دقيقة';
    if (diff.inHours < 24) return 'منذ ${diff.inHours} ساعات';
    if (diff.inDays < 7) return 'منذ ${diff.inDays} أيام';
    return DateFormat('dd/MM/yyyy').format(date);
  }

  String getAnnouncementTypeName(String type) {
    switch (type) {
      case 'meeting':
        return 'اجتماع';
      case 'holiday':
        return 'عطلة';
      case 'decision':
        return 'قرار';
      case 'news':
        return 'أخبار';
      case 'alert':
        return 'تنبيه';
      default:
        return 'إعلان';
    }
  }
}
