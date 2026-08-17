import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';

import '../../data/repos/notification_repo.dart';
import 'notification_state.dart';

class NotificationCubit extends Cubit<NotificationState> {
  final NotificationRepository _repository;
  StreamSubscription? _subscription;
  String? _loadedUserId;

  NotificationCubit({required NotificationRepository repository})
      : _repository = repository,
        super(const NotificationInitial());

  void loadNotifications(String userId) {
    if (_loadedUserId == userId && _subscription != null) return;
    _subscription?.cancel();
    _loadedUserId = userId;
    emit(const NotificationLoading());

    _subscription = _repository.getNotifications(userId).listen(
      (result) {
        result.fold(
          (failure) => emit(NotificationError(message: failure.message)),
          (notifications) {
            final unreadCount = notifications.where((n) => !n.isRead).length;
            emit(NotificationLoaded(
              notifications: notifications,
              unreadCount: unreadCount,
            ));
          },
        );
      },
      onError: (error) {
        emit(NotificationError(message: 'حدث خطأ غير متوقع'));
      },
    );
  }

  Future<void> markAsRead(String notificationId) async {
    final result = await _repository.markAsRead(notificationId);
    result.fold(
      (failure) => emit(NotificationError(message: failure.message)),
      (_) {},
    );
  }

  Future<void> markAllAsRead(String userId) async {
    final result = await _repository.markAllAsRead(userId);
    result.fold(
      (failure) => emit(NotificationError(message: failure.message)),
      (_) {},
    );
  }

  @override
  Future<void> close() {
    _subscription?.cancel();
    return super.close();
  }
}
