import 'package:dartz/dartz.dart';

import '../../../../core/error/failures.dart';
import '../../../users/data/models/user_model.dart';
import '../models/chat_room_model.dart';
import '../models/message_model.dart';

abstract class ChatRepository {
  // =========================================================
  // Users
  // =========================================================

  /// Returns all users except the current user.
  Future<Either<Failure, List<UserModel>>> getUsers({
    required String currentUserId,
  });

  // =========================================================
  // Chat Rooms
  // =========================================================

  /// Returns all chat rooms of the current user in real time.
  Stream<Either<Failure, List<ChatRoomModel>>> getChatRooms({
    required String currentUserId,
  });

  /// Returns an existing private chat or creates a new one.
  Future<Either<Failure, ChatRoomModel>> getOrCreatePrivateChat({
    required String currentUserId,
    required String currentUserName,
    required String otherUserId,
    required String otherUserName,
  });

  /// Deletes the entire chat room.
  Future<Either<Failure, Unit>> deleteChatRoom({
    required String roomId,
  });

  // =========================================================
  // Messages
  // =========================================================

  /// Returns all messages of a chat room in real time.
  Stream<Either<Failure, List<MessageModel>>> getMessages({
    required String roomId,
  });

  /// Sends a text message.
  Future<Either<Failure, Unit>> sendMessage({
    required String roomId,
    required MessageModel message,
  });

  /// Updates the content of a message.
  Future<Either<Failure, Unit>> editMessage({
    required String roomId,
    required String messageId,
    required String newContent,
  });

  /// Soft deletes a message.
  Future<Either<Failure, Unit>> deleteMessage({
    required String roomId,
    required String messageId,
  });

  /// Marks all unread messages as read.
  Future<Either<Failure, Unit>> markMessagesAsRead({
    required String roomId,
    required String currentUserId,
  });

  /// Returns the unread messages count of the current user.
  Future<Either<Failure, int>> getUnreadCount({
    required String roomId,
    required String currentUserId,
  });
}