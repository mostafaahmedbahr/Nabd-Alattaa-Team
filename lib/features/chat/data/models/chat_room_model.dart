import 'package:equatable/equatable.dart';

import '../../../../core/constants/firestore_constants.dart';

class ChatRoomModel extends Equatable {
  final String id;
  final String name;
  final String type;
  final List<String> participants;
  final String? lastMessage;
  final DateTime? lastMessageTime;
  final String createdBy;
  final DateTime createdAt;

  const ChatRoomModel({
    required this.id,
    required this.name,
    required this.type,
    required this.participants,
    this.lastMessage,
    this.lastMessageTime,
    required this.createdBy,
    required this.createdAt,
  });

  factory ChatRoomModel.fromMap(Map<String, dynamic> map) {
    return ChatRoomModel(
      id: map['id'] ?? '',
      name: map[FirestoreConstants.chatRoomName] ?? '',
      type: map[FirestoreConstants.chatRoomType] ?? ChatRoomType.individual,
      participants: List<String>.from(map[FirestoreConstants.chatRoomParticipants] ?? []),
      lastMessage: map[FirestoreConstants.chatRoomLastMessage],
      lastMessageTime: map[FirestoreConstants.chatRoomLastMessageTime]?.toDate(),
      createdBy: map[FirestoreConstants.chatRoomCreatedBy] ?? '',
      createdAt: map[FirestoreConstants.chatRoomCreatedAt]?.toDate() ?? DateTime.now(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      FirestoreConstants.chatRoomName: name,
      FirestoreConstants.chatRoomType: type,
      FirestoreConstants.chatRoomParticipants: participants,
      FirestoreConstants.chatRoomLastMessage: lastMessage,
      FirestoreConstants.chatRoomLastMessageTime: lastMessageTime,
      FirestoreConstants.chatRoomCreatedBy: createdBy,
      FirestoreConstants.chatRoomCreatedAt: createdAt,
    };
  }

  ChatRoomModel copyWith({
    String? id,
    String? name,
    String? type,
    List<String>? participants,
    String? lastMessage,
    DateTime? lastMessageTime,
    String? createdBy,
    DateTime? createdAt,
  }) {
    return ChatRoomModel(
      id: id ?? this.id,
      name: name ?? this.name,
      type: type ?? this.type,
      participants: participants ?? this.participants,
      lastMessage: lastMessage ?? this.lastMessage,
      lastMessageTime: lastMessageTime ?? this.lastMessageTime,
      createdBy: createdBy ?? this.createdBy,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  @override
  List<Object?> get props => [id, name, type, participants, lastMessage, lastMessageTime, createdBy, createdAt];
}
