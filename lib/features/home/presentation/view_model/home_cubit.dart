import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/utils/helpers.dart';
import '../../data/repos/home_repo.dart';
import 'home_states.dart';

class HomeCubit extends Cubit<HomeStates> {
  final HomeRepository _homeRepo;

  HomeCubit({required HomeRepository homeRepository})
      : _homeRepo = homeRepository,
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
      final result = await _homeRepo.getHomeData(userId);

      String userName = 'مستخدم';
      List<Map<String, dynamic>> announcements = const [];
      List<Map<String, dynamic>> tasks = const [];
      int totalTasksCount = 0;

      result.fold(
        (failure) => emit(HomeError(message: failure.message)),
        (data) {
          userName = data.userName;
          announcements = data.announcements.map((a) {
            return {
              'id': a['id'],
              'title': a['title'],
              'subtitle': a['subtitle'],
              'time': Helpers.formatDate2(a['createdAt']),
            };
          }).toList();
          tasks = data.tasks.map((t) {
            final status = t['status'] ?? 'not_started';
            return {
              'id': t['id'],
              'title': t['title'],
              'subtitle': t['subtitle'],
              'status':  Helpers.translateStatus(status),
              'statusColor': Helpers.statusColor(status),
            };
          }).toList();
          totalTasksCount = data.totalTasksCount;
        },
      );

      if (state is HomeError) return;

      _userName = userName;
      _greeting = getGreeting();
      _announcements = announcements;
      _tasks = tasks;
      _totalTasksCount = totalTasksCount;
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
      _homeRepo.getGoodDeedsCount(userId).listen((value) {
        _goodDeedsCount = value;
        _emitCurrent();
      }),
    );
    _countSubs.add(
      _homeRepo.getComplaintsCount(userId).listen((value) {
        _complaintsCount = value;
        _emitCurrent();
      }),
    );
    _countSubs.add(
      _homeRepo.getIdeasCount(userId).listen((value) {
        _ideasCount = value;
        _emitCurrent();
      }),
    );
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





  @override
  Future<void> close() {
    _cancelCountStreams();
    return super.close();
  }

  void  loadData({bool forceRefresh = false}) {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
       loadHomeData(user.uid, forceRefresh: forceRefresh);
    }
  }


}
