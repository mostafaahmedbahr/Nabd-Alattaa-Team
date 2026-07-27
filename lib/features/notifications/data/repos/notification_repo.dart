import 'package:dartz/dartz.dart';

import '../../../../core/error/failures.dart';
import '../models/notification_model.dart';

abstract class NotificationRepository {
  Stream<Either<Failure, List<NotificationModel>>> getNotifications(String userId);
  Future<Either<Failure, void>> markAsRead(String notificationId);
  Future<Either<Failure, void>> markAllAsRead(String userId);
  Future<Either<Failure, int>> getUnreadCount(String userId);
}
