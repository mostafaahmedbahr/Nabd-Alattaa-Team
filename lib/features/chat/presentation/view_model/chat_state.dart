import 'package:equatable/equatable.dart';

import '../../data/models/chat_room_model.dart';
import '../../data/models/message_model.dart';

abstract class ChatState extends Equatable {
  const ChatState();

  @override
  List<Object?> get props => [];
}

class ChatInitial extends ChatState {
  const ChatInitial();
}

class ChatRoomsLoading extends ChatState {
  const ChatRoomsLoading();
}

class ChatRoomsLoaded extends ChatState {
  final List<ChatRoomModel> chatRooms;

  const ChatRoomsLoaded({required this.chatRooms});

  @override
  List<Object?> get props => [chatRooms];
}

class ChatRoomsError extends ChatState {
  final String message;

  const ChatRoomsError({required this.message});

  @override
  List<Object?> get props => [message];
}

class MessagesLoading extends ChatState {
  const MessagesLoading();
}

class MessagesLoaded extends ChatState {
  final List<MessageModel> messages;

  const MessagesLoaded({required this.messages});

  @override
  List<Object?> get props => [messages];
}

class MessagesError extends ChatState {
  final String message;

  const MessagesError({required this.message});

  @override
  List<Object?> get props => [message];
}

class MessageSending extends ChatState {
  const MessageSending();
}

class MessageSent extends ChatState {
  const MessageSent();
}

class MessageSendError extends ChatState {
  final String message;

  const MessageSendError({required this.message});

  @override
  List<Object?> get props => [message];
}

class ChatRoomCreated extends ChatState {
  final ChatRoomModel chatRoom;

  const ChatRoomCreated({required this.chatRoom});

  @override
  List<Object?> get props => [chatRoom];
}
