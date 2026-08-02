import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';

import '../../data/models/chat_room_model.dart';
import '../../data/models/message_model.dart';
import '../../data/repos/chat_repo.dart';
import 'chat_state.dart';

class ChatCubit extends Cubit<ChatState> {
  final ChatRepository chatRepository;
  StreamSubscription? _chatRoomsSubscription;
  StreamSubscription? _messagesSubscription;

  ChatCubit({required this.chatRepository}) : super(const ChatInitial());

  // =========================================================
  // Chat Rooms (Stream) - WhatsApp style list
  // =========================================================

  void loadChatRooms({required String currentUserId}) {
    _chatRoomsSubscription?.cancel();
    emit(const ChatLoading());
    _chatRoomsSubscription = chatRepository
        .getChatRooms(currentUserId: currentUserId)
        .listen(
      (result) {
        result.fold(
          (failure) => emit(ChatError(message: failure.message)),
          (chatRooms) => emit(ChatRoomsLoaded(chatRooms: chatRooms)),
        );
      },
      onError: (error) =>
          emit(const ChatError(message: 'حدث خطأ غير متوقع')),
    );
  }

  // =========================================================
  // Create / Get Private Chat (no loading emit to avoid breaking list)
  // =========================================================

  Future<ChatRoomModel?> getOrCreatePrivateChat({
    required String currentUserId,
    required String currentUserName,
    required String otherUserId,
    required String otherUserName,
  }) async {
    final result = await chatRepository.getOrCreatePrivateChat(
      currentUserId: currentUserId,
      currentUserName: currentUserName,
      otherUserId: otherUserId,
      otherUserName: otherUserName,
    );
    return result.fold(
      (failure) {
        emit(ChatError(message: failure.message));
        return null;
      },
      (chatRoom) => chatRoom,
    );
  }

  // =========================================================
  // Delete Chat Room
  // =========================================================

  Future<void> deleteChatRoom({required String roomId}) async {
    final result = await chatRepository.deleteChatRoom(roomId: roomId);
    result.fold(
      (failure) => emit(ChatError(message: failure.message)),
      (_) {},
    );
  }

  // =========================================================
  // Messages (Stream)
  // =========================================================

  void loadMessages({required String roomId}) {
    _messagesSubscription?.cancel();
    emit(const ChatLoading());
    _messagesSubscription = chatRepository
        .getMessages(roomId: roomId)
        .listen(
      (result) {
        result.fold(
          (failure) => emit(ChatError(message: failure.message)),
          (messages) => emit(MessagesLoaded(messages: messages)),
        );
      },
      onError: (error) =>
          emit(const ChatError(message: 'حدث خطأ غير متوقع')),
    );
  }

  // =========================================================
  // Send Message
  // =========================================================

  Future<void> sendMessage({
    required String roomId,
    required MessageModel message,
  }) async {
    final result = await chatRepository.sendMessage(
      roomId: roomId,
      message: message,
    );
    result.fold(
      (failure) => emit(ChatError(message: failure.message)),
      (_) {},
    );
  }

  // =========================================================
  // Edit Message
  // =========================================================

  Future<void> editMessage({
    required String roomId,
    required String messageId,
    required String newContent,
  }) async {
    final result = await chatRepository.editMessage(
      roomId: roomId,
      messageId: messageId,
      newContent: newContent,
    );
    result.fold(
      (failure) => emit(ChatError(message: failure.message)),
      (_) {},
    );
  }

  // =========================================================
  // Delete Message
  // =========================================================

  Future<void> deleteMessage({
    required String roomId,
    required String messageId,
  }) async {
    final result = await chatRepository.deleteMessage(
      roomId: roomId,
      messageId: messageId,
    );
    result.fold(
      (failure) => emit(ChatError(message: failure.message)),
      (_) {},
    );
  }

  // =========================================================
  // Mark Messages As Read
  // =========================================================

  Future<void> markMessagesAsRead({
    required String roomId,
    required String currentUserId,
  }) async {
    final result = await chatRepository.markMessagesAsRead(
      roomId: roomId,
      currentUserId: currentUserId,
    );
    result.fold(
      (failure) => emit(ChatError(message: failure.message)),
      (_) {},
    );
  }

  // =========================================================
  // Stop messages stream (when leaving chat room)
  // =========================================================

  void stopMessagesStream() {
    _messagesSubscription?.cancel();
    _messagesSubscription = null;
  }

  @override
  Future<void> close() {
    _chatRoomsSubscription?.cancel();
    _messagesSubscription?.cancel();
    return super.close();
  }
}
