import 'dart:async';
import 'dart:ui';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
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

  bool _hasLoaded = false;

  String _userName = 'مستخدم';
  String _greeting = '';
  List<Map<String, dynamic>> _announcements = const [];
  List<Map<String, dynamic>> _tasks = const [];
  int _totalTasksCount = 0;

  int _goodDeedsCount = 0;
  int _complaintsCount = 0;
  int _ideasCount = 0;

  final List<StreamSubscription> _countSubs = [];

  void reset() {
    _hasLoaded = false;
    _cancelCountStreams();
    emit(HomeInitial());
  }

  Future<void> loadHomeData(String userId,
      {bool forceRefresh = false, bool showLoading = true}) async {
    if (_hasLoaded && !forceRefresh) {
      _startCountStreams(userId);
      return;
    }

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

      _userName = userName;
      _greeting = getGreeting();
      _announcements = announcements;
      _tasks = tasks;
      _totalTasksCount = allTasksSnap.docs.length;
      _hasLoaded = true;

      _startCountStreams(userId);
      _emitCurrent();
    } catch (e) {
      emit(HomeError(message: 'فشل في تحميل البيانات: ${e.toString()}'));
    }
  }

  void _startCountStreams(String userId) {
    _cancelCountStreams();
    _countSubs.add(
      _countStream(
        FirestoreConstants.goodDeeds,
        FirestoreConstants.goodDeedCreatorId,
        userId,
      ).listen((value) {
        _goodDeedsCount = value;
        _emitCurrent();
      }),
    );
    _countSubs.add(
      _countStream(
        FirestoreConstants.complaints,
        FirestoreConstants.complaintCreatorId,
        userId,
      ).listen((value) {
        _complaintsCount = value;
        _emitCurrent();
      }),
    );
    _countSubs.add(
      _countStream(
        FirestoreConstants.ideas,
        FirestoreConstants.ideaCreatorId,
        userId,
      ).listen((value) {
        _ideasCount = value;
        _emitCurrent();
      }),
    );
  }

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

  void _emitCurrent() {
    if (!_hasLoaded) return;
    emit(HomeLoaded(
      userName: _userName,
      greeting: _greeting,
      announcements: _announcements,
      tasks: _tasks,
      totalTasksCount: _totalTasksCount,
      goodDeedsCount: _goodDeedsCount,
      complaintsCount: _complaintsCount,
      ideasCount: _ideasCount,
    ));
  }

  void _cancelCountStreams() {
    for (final sub in _countSubs) {
      sub.cancel();
    }
    _countSubs.clear();
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
        return const Color(0xFF4CAF50);
      case 'in_progress':
        return const Color(0xFFFF9800);
      case 'in_review':
        return const Color(0xFF2196F3);
      case 'late':
        return const Color(0xFFF44336);
      case 'not_started':
      default:
        return const Color(0xFF9E9E9E);
    }
  }

  @override
  Future<void> close() {
    _cancelCountStreams();
    return super.close();
  }
}
