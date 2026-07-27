import 'package:equatable/equatable.dart';

import '../../data/models/notification_model.dart';

abstract class NotificationState extends Equatable {
  const NotificationState();

  @override
  List<Object?> get props => [];
}

class NotificationInitial extends NotificationState {
  const NotificationInitial();
}

class NotificationLoading extends NotificationState {
  const NotificationLoading();
}

class NotificationLoaded extends NotificationState {
  final List<NotificationModel> notifications;
  final int unreadCount;

  const NotificationLoaded({
    required this.notifications,
    this.unreadCount = 0,
  });

  @override
  List<Object?> get props => [notifications, unreadCount];
}

class NotificationError extends NotificationState {
  final String message;

  const NotificationError({required this.message});

  @override
  List<Object?> get props => [message];
}
