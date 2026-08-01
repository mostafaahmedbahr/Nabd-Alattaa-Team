import 'dart:ui';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

import '../../../../core/constants/firestore_constants.dart';
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

  Future<void> loadHomeData(String userId) async {
    emit(HomeLoading());
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

      emit(HomeLoaded(
        userName: userName,
        greeting: getGreeting(),
        announcements: announcements,
        tasks: tasks,
      ));
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
