import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';

class MessageModel extends Equatable {
  final String id;

  /// Message text
  final String content;

  /// Sender
  final String senderId;
  final String senderName;

  /// Timestamp
  final DateTime timestamp;

  /// Has this message been edited?
  final bool isEdited;

  /// Soft delete
  final bool isDeleted;

  /// Users who have read this message
  final List<String> readBy;

  const MessageModel({
    required this.id,
    required this.content,
    required this.senderId,
    required this.senderName,
    required this.timestamp,
    this.isEdited = false,
    this.isDeleted = false,
    this.readBy = const [],
  });

  bool isReadBy(String userId) => readBy.contains(userId);

  MessageModel copyWith({
    String? id,
    String? content,
    String? senderId,
    String? senderName,
    DateTime? timestamp,
    bool? isEdited,
    bool? isDeleted,
    List<String>? readBy,
  }) {
    return MessageModel(
      id: id ?? this.id,
      content: content ?? this.content,
      senderId: senderId ?? this.senderId,
      senderName: senderName ?? this.senderName,
      timestamp: timestamp ?? this.timestamp,
      isEdited: isEdited ?? this.isEdited,
      isDeleted: isDeleted ?? this.isDeleted,
      readBy: readBy ?? this.readBy,
    );
  }

  factory MessageModel.fromJson(Map<String, dynamic> json) {
    return MessageModel(
      id: json['id'] ?? '',
      content: json['content'] ?? '',
      senderId: json['senderId'] ?? '',
      senderName: json['senderName'] ?? '',
      timestamp: json['timestamp'] is Timestamp
          ? (json['timestamp'] as Timestamp).toDate()
          : DateTime.tryParse(json['timestamp'].toString()) ??
          DateTime.now(),
      isEdited: json['isEdited'] ?? false,
      isDeleted: json['isDeleted'] ?? false,
      readBy: List<String>.from(json['readBy'] ?? const []),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'content': content,
      'senderId': senderId,
      'senderName': senderName,
      'timestamp': Timestamp.fromDate(timestamp),
      'isEdited': isEdited,
      'isDeleted': isDeleted,
      'readBy': readBy,
    };
  }

  @override
  List<Object?> get props => [
    id,
    content,
    senderId,
    senderName,
    timestamp,
    isEdited,
    isDeleted,
    readBy,
  ];
}