import 'package:equatable/equatable.dart';

import '../../data/models/chat_room_model.dart';
import '../../data/models/message_model.dart';
import '../../../users/data/models/user_model.dart';

abstract class ChatState extends Equatable {
  const ChatState();

  @override
  List<Object?> get props => [];
}

class ChatInitial extends ChatState {
  const ChatInitial();
}

class ChatLoading extends ChatState {
  const ChatLoading();
}

class ChatRoomsLoaded extends ChatState {
  final List<ChatRoomModel> chatRooms;

  const ChatRoomsLoaded({required this.chatRooms});

  @override
  List<Object?> get props => [chatRooms];
}

class MessagesLoaded extends ChatState {
  final List<MessageModel> messages;

  const MessagesLoaded({required this.messages});

  @override
  List<Object?> get props => [messages];
}

class UsersLoaded extends ChatState {
  final List<UserModel> users;

  const UsersLoaded({required this.users});

  @override
  List<Object?> get props => [users];
}

class ChatRoomCreated extends ChatState {
  final ChatRoomModel chatRoom;

  const ChatRoomCreated({required this.chatRoom});

  @override
  List<Object?> get props => [chatRoom];
}

class ChatActionSuccess extends ChatState {
  const ChatActionSuccess();
}

class ChatError extends ChatState {
  final String message;

  const ChatError({required this.message});

  @override
  List<Object?> get props => [message];
}
