import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:uuid/uuid.dart';

import '../../data/models/message_model.dart';
import '../../data/repos/chat_repo.dart';
import 'chat_state.dart';

class ChatCubit extends Cubit<ChatState> {
  final ChatRepository _repository;
  StreamSubscription? _chatRoomsSubscription;
  StreamSubscription? _messagesSubscription;

  ChatCubit({required ChatRepository repository})
      : _repository = repository,
        super(const ChatInitial());

  void loadChatRooms(String userId) {
    _chatRoomsSubscription?.cancel();
    emit(const ChatRoomsLoading());

    _chatRoomsSubscription = _repository.getChatRooms(userId).listen(
      (result) {
        result.fold(
          (failure) => emit(ChatRoomsError(message: failure.message)),
          (chatRooms) => emit(ChatRoomsLoaded(chatRooms: chatRooms)),
        );
      },
      onError: (error) {
        emit(ChatRoomsError(message: 'حدث خطأ غير متوقع'));
      },
    );
  }

  void loadMessages(String chatRoomId) {
    _messagesSubscription?.cancel();
    emit(const MessagesLoading());

    _messagesSubscription = _repository.getMessagesStream(chatRoomId).listen(
      (result) {
        result.fold(
          (failure) => emit(MessagesError(message: failure.message)),
          (messages) => emit(MessagesLoaded(messages: messages)),
        );
      },
      onError: (error) {
        emit(MessagesError(message: 'حدث خطأ غير متوقع'));
      },
    );
  }

  Future<void> sendMessage({
    required String chatRoomId,
    required String content,
    required String senderId,
    required String senderName,
  }) async {
    final message = MessageModel(
      id: const Uuid().v4(),
      content: content,
      senderId: senderId,
      senderName: senderName,
      timestamp: DateTime.now(),
    );

    final result = await _repository.sendMessage(chatRoomId, message);
    result.fold(
      (failure) => emit(MessageSendError(message: failure.message)),
      (_) {},
    );
  }

  Future<void> markAsRead(String chatRoomId, String userId) async {
    await _repository.markMessagesAsRead(chatRoomId, userId);
  }

  @override
  Future<void> close() {
    _chatRoomsSubscription?.cancel();
    _messagesSubscription?.cancel();
    return super.close();
  }
}
