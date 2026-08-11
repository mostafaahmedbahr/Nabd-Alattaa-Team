import 'dart:ui';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

import '../../../../core/constants/firestore_constants.dart';
import '../../../../core/utils/log_util.dart';
import '../../../profile/presentation/view_model/profile_cubit.dart';
import 'home_states.dart';

class HomeCubit extends Cubit<HomeStates> {
  final FirebaseFirestore _firestore;

  HomeCubit({FirebaseFirestore? firestore})
      : _firestore = firestore ?? FirebaseFirestore.instance,
        super(HomeInitial());




  String getGreeting() {
    final hour = DateTime.now().hour;
    if (hour < 12) return 'صباح الخير';
    if (hour < 17) return 'مساء الخير';
    return 'مساء الخير';
  }

  bool _hasLoaded = false;

  void reset() {
    _hasLoaded = false;
    emit(HomeInitial());
  }

  Future<void> loadHomeData(String userId,
      {bool forceRefresh = false, bool showLoading = true})
  async {
    if (_hasLoaded && !forceRefresh) return;

    if (showLoading) {
      emit(HomeLoading());
    }
    try {
      final userDoc = await _firestore
          .collection(FirestoreConstants.users)
          .doc(userId)
          .get();

      String userName = 'مستخدم';
      if (userDoc.exists) {
        userName = userDoc.data()?[FirestoreConstants.userName] ?? 'مستخدم';
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
          'time': _formatDate(data[FirestoreConstants.announcementCreatedAt]),
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
        final status = data[FirestoreConstants.taskStatus] ?? 'not_started';
        return {
          'id': doc.id,
          'title': data[FirestoreConstants.taskTitle] ?? '',
          'subtitle': data[FirestoreConstants.taskDescription] ?? '',
          'status': _translateStatus(status),
          'statusColor': _statusColor(status),
        };
      }).toList();

      final goodDeedsSnap = await _firestore
          .collection(FirestoreConstants.goodDeeds)
          .where(FirestoreConstants.goodDeedCreatorId, isEqualTo: userId)
          .get();

      final complaintsSnap = await _firestore
          .collection(FirestoreConstants.complaints)
          .where(FirestoreConstants.complaintCreatorId, isEqualTo: userId)
          .get();

      final reportsSnap = await _firestore
          .collection(FirestoreConstants.reports)
          .where(FirestoreConstants.reportCreatorId, isEqualTo: userId)
          .get();

      final ideasSnap = await _firestore
          .collection(FirestoreConstants.ideas)
          .where(FirestoreConstants.ideaCreatorId, isEqualTo: userId)
          .get();

      emit(HomeLoaded(
        userName: userName,
        greeting: getGreeting(),
        announcements: announcements,
        tasks: tasks,
        totalTasksCount: allTasksSnap.docs.length,
        goodDeedsCount: goodDeedsSnap.docs.length,
        complaintsCount: complaintsSnap.docs.length,
        reportsCount: reportsSnap.docs.length,
        ideasCount: ideasSnap.docs.length,
      ));
      _hasLoaded = true;
    } catch (e) {
      emit(HomeError(message: 'فشل في تحميل البيانات: ${e.toString()}'));
    }
  }

  String _formatDate(dynamic timestamp) {
    if (timestamp == null) return '';
    final date = (timestamp as Timestamp).toDate();
    final now = DateTime.now();
    final diff = now.difference(date);
    if (diff.inHours < 1) return 'منذ ${diff.inMinutes} دقيقة';
    if (diff.inHours < 24) return 'منذ ${diff.inHours} ساعات';
    if (diff.inDays < 7) return 'منذ ${diff.inDays} أيام';
    return DateFormat('dd/MM/yyyy').format(date);
  }

  String _translateStatus(String status) {
    switch (status) {
      case 'completed':
        return 'مكتملة';
      case 'in_progress':
        return 'قيد التنفيذ';
      case 'in_review':
        return 'قيد المراجعة';
      case 'late':
        return 'متأخرة';
      case 'not_started':
      default:
        return 'جديدة';
    }
  }

  Color _statusColor(String status) {
    switch (status) {
      case 'completed':
        return Color(0xFF4CAF50);
      case 'in_progress':
        return Color(0xFFFF9800);
      case 'in_review':
        return Color(0xFF2196F3);
      case 'late':
        return Color(0xFFF44336);
      case 'not_started':
      default:
        return Color(0xFF9E9E9E);
    }
  }
}
