import 'package:equatable/equatable.dart';

import '../../../../core/constants/firestore_constants.dart';

class NotificationModel extends Equatable {
  final String id;
  final String title;
  final String body;
  final String type;
  final String? referenceId;
  final bool isRead;
  final DateTime createdAt;

  const NotificationModel({
    required this.id,
    required this.title,
    required this.body,
    required this.type,
    this.referenceId,
    this.isRead = false,
    required this.createdAt,
  });

  factory NotificationModel.fromMap(Map<String, dynamic> map) {
    return NotificationModel(
      id: map['id'] ?? '',
      title: map[FirestoreConstants.notificationTitle] ?? '',
      body: map[FirestoreConstants.notificationBody] ?? '',
      type: map[FirestoreConstants.notificationType] ?? '',
      referenceId: map[FirestoreConstants.notificationReferenceId],
      isRead: map[FirestoreConstants.notificationIsRead] ?? false,
      createdAt: map[FirestoreConstants.notificationCreatedAt]?.toDate() ?? DateTime.now(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      FirestoreConstants.notificationTitle: title,
      FirestoreConstants.notificationBody: body,
      FirestoreConstants.notificationType: type,
      FirestoreConstants.notificationReferenceId: referenceId,
      FirestoreConstants.notificationIsRead: isRead,
      FirestoreConstants.notificationCreatedAt: createdAt,
    };
  }

  NotificationModel copyWith({
    String? id,
    String? title,
    String? body,
    String? type,
    String? referenceId,
    bool? isRead,
    DateTime? createdAt,
  }) {
    return NotificationModel(
      id: id ?? this.id,
      title: title ?? this.title,
      body: body ?? this.body,
      type: type ?? this.type,
      referenceId: referenceId ?? this.referenceId,
      isRead: isRead ?? this.isRead,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  @override
  List<Object?> get props => [id, title, body, type, referenceId, isRead, createdAt];
}
