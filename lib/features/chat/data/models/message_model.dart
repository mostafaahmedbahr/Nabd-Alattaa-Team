import 'package:equatable/equatable.dart';

import '../../../../core/constants/firestore_constants.dart';

class MessageModel extends Equatable {
  final String id;
  final String content;
  final String senderId;
  final String senderName;
  final DateTime timestamp;
  final bool isRead;

  const MessageModel({
    required this.id,
    required this.content,
    required this.senderId,
    required this.senderName,
    required this.timestamp,
    this.isRead = false,
  });

  factory MessageModel.fromMap(Map<String, dynamic> map) {
    return MessageModel(
      id: map['id'] ?? '',
      content: map[FirestoreConstants.messageContent] ?? '',
      senderId: map[FirestoreConstants.messageSenderId] ?? '',
      senderName: map[FirestoreConstants.messageSenderName] ?? '',
      timestamp: map[FirestoreConstants.messageTimestamp]?.toDate() ?? DateTime.now(),
      isRead: map[FirestoreConstants.messageIsRead] ?? false,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      FirestoreConstants.messageContent: content,
      FirestoreConstants.messageSenderId: senderId,
      FirestoreConstants.messageSenderName: senderName,
      FirestoreConstants.messageTimestamp: timestamp,
      FirestoreConstants.messageIsRead: isRead,
    };
  }

  MessageModel copyWith({
    String? id,
    String? content,
    String? senderId,
    String? senderName,
    DateTime? timestamp,
    bool? isRead,
  }) {
    return MessageModel(
      id: id ?? this.id,
      content: content ?? this.content,
      senderId: senderId ?? this.senderId,
      senderName: senderName ?? this.senderName,
      timestamp: timestamp ?? this.timestamp,
      isRead: isRead ?? this.isRead,
    );
  }

  @override
  List<Object?> get props => [id, content, senderId, senderName, timestamp, isRead];
}
