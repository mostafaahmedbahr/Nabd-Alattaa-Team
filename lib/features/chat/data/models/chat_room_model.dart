import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';

class ChatRoomModel extends Equatable {
  final String id;

  /// Users inside this chat
  final List<String> participants;

  /// User names
  final List<String> participantNames;

  /// Last message preview
  final String lastMessage;

  /// Last sender
  final String lastSenderId;

  /// Last message time
  final DateTime lastMessageTime;

  /// Number of unread messages for each user
  final Map<String, int> unreadCounts;

  /// Room creation date
  final DateTime createdAt;

  const ChatRoomModel({
    required this.id,
    required this.participants,
    required this.participantNames,
    required this.lastMessage,
    required this.lastSenderId,
    required this.lastMessageTime,
    required this.unreadCounts,
    required this.createdAt,
  });

  /// Returns the other user's id in a private chat.
  String otherUserId(String currentUserId) {
    return participants.firstWhere(
          (id) => id != currentUserId,
      orElse: () => '',
    );
  }

  /// Returns the other user's name.
  String otherUserName(String currentUserId) {
    final index = participants.indexWhere(
          (id) => id != currentUserId,
    );

    if (index == -1) return '';

    return participantNames[index];
  }

  /// Current user's unread count.
  int unreadCount(String currentUserId) {
    return unreadCounts[currentUserId] ?? 0;
  }

  ChatRoomModel copyWith({
    String? id,
    List<String>? participants,
    List<String>? participantNames,
    String? lastMessage,
    String? lastSenderId,
    DateTime? lastMessageTime,
    Map<String, int>? unreadCounts,
    DateTime? createdAt,
  }) {
    return ChatRoomModel(
      id: id ?? this.id,
      participants: participants ?? this.participants,
      participantNames: participantNames ?? this.participantNames,
      lastMessage: lastMessage ?? this.lastMessage,
      lastSenderId: lastSenderId ?? this.lastSenderId,
      lastMessageTime: lastMessageTime ?? this.lastMessageTime,
      unreadCounts: unreadCounts ?? this.unreadCounts,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  factory ChatRoomModel.fromJson(
      Map<String, dynamic> json,
      String documentId,
      ) {
    final unread = <String, int>{};

    if (json['unreadCounts'] != null) {
      (json['unreadCounts'] as Map<String, dynamic>).forEach(
            (key, value) {
          unread[key] = value as int;
        },
      );
    }

    return ChatRoomModel(
      id: documentId,
      participants: List<String>.from(
        json['participants'] ?? const [],
      ),
      participantNames: List<String>.from(
        json['participantNames'] ?? const [],
      ),
      lastMessage: json['lastMessage'] ?? '',
      lastSenderId: json['lastSenderId'] ?? '',
      lastMessageTime: json['lastMessageTime'] is Timestamp
          ? (json['lastMessageTime'] as Timestamp).toDate()
          : DateTime.now(),
      unreadCounts: unread,
      createdAt: json['createdAt'] is Timestamp
          ? (json['createdAt'] as Timestamp).toDate()
          : DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'participants': participants,
      'participantNames': participantNames,
      'lastMessage': lastMessage,
      'lastSenderId': lastSenderId,
      'lastMessageTime': Timestamp.fromDate(lastMessageTime),
      'unreadCounts': unreadCounts,
      'createdAt': Timestamp.fromDate(createdAt),
    };
  }

  @override
  List<Object?> get props => [
    id,
    participants,
    participantNames,
    lastMessage,
    lastSenderId,
    lastMessageTime,
    unreadCounts,
    createdAt,
  ];
}