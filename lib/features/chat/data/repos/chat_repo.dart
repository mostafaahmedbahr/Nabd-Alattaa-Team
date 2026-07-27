import 'package:dartz/dartz.dart';

import '../../../../core/error/failures.dart';
import '../models/chat_room_model.dart';
import '../models/message_model.dart';

abstract class ChatRepository {
  Stream<Either<Failure, List<ChatRoomModel>>> getChatRooms(String userId);
  Future<Either<Failure, List<MessageModel>>> getMessages(String chatRoomId);
  Future<Either<Failure, void>> sendMessage(String chatRoomId, MessageModel message);
  Future<Either<Failure, ChatRoomModel>> createChatRoom(ChatRoomModel chatRoom);
  Future<Either<Failure, void>> markMessagesAsRead(String chatRoomId, String userId);
  Stream<Either<Failure, List<MessageModel>>> getMessagesStream(String chatRoomId);
}
