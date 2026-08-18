import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dartz/dartz.dart';

import '../../../../core/constants/app_strings.dart';
import '../../../../core/error/failures.dart';
import '../../../users/data/models/user_model.dart';
import '../models/chat_room_model.dart';
import '../models/message_model.dart';
import 'chat_repo.dart';

class ChatRepositoryImpl implements ChatRepository {
  final FirebaseFirestore firestore;

  ChatRepositoryImpl({
    required this.firestore,
  });


  @override
  Future<Either<Failure, List<UserModel>>> getUsers({
    required String currentUserId,
  })
  async {
    try {
      final snapshot = await firestore
          .collection('users')
          .orderBy('user_name')
          .get();

      final users = snapshot.docs
          .where((doc) => doc.id != currentUserId)
          .map(
            (doc) => UserModel.fromJson(
          doc.data(),
          doc.id,
        ),
      )
          .toList();

      return Right(users);
    } on FirebaseException catch (e) {
      return Left(
        ServerFailure(
         message:  e.message ?? 'Failed to load users.',
        ),
      );
    } catch (e) {
      return Left(
        ServerFailure(message: e.toString()),
      );
    }
  }


  @override
  Stream<Either<Failure, List<ChatRoomModel>>> getChatRooms({
    required String currentUserId,
  })
  {
    try {
      return firestore
          .collection('chat_rooms')
          .where(
        'participants',
        arrayContains: currentUserId,
      )
          .orderBy(
        'lastMessageTime',
        descending: true,
      )
          .snapshots()
          .map(
            (snapshot) {
          final rooms = snapshot.docs
              .map(
                (doc) => ChatRoomModel.fromJson(
              doc.data(),
              doc.id,
            ),
          )
              .toList();

          return Right<Failure, List<ChatRoomModel>>(rooms);
        },
      );
    } catch (e) {
      return Stream.value(
        Left(
          ServerFailure(
            message: e.toString(),
          ),
        ),
      );
    }
  }

  @override
  Future<Either<Failure, ChatRoomModel>> getOrCreatePrivateChat({
    required String currentUserId,
    required String currentUserName,
    required String otherUserId,
    required String otherUserName,
  })
  async {
    try {
      final query = await firestore
          .collection('chat_rooms')
          .where(
        'participants',
        arrayContains: currentUserId,
      )
          .get();

      for (final doc in query.docs) {
        final room = ChatRoomModel.fromJson(
          doc.data(),
          doc.id,
        );

        if (room.participants.contains(otherUserId)) {
          return Right(room);
        }
      }

      final roomRef = firestore.collection('chat_rooms').doc();

      final room = ChatRoomModel(
        id: roomRef.id,
        participants: [
          currentUserId,
          otherUserId,
        ],
        participantNames: [
          currentUserName,
          otherUserName,
        ],
        lastMessage: '',
        lastSenderId: '',
        lastMessageTime: DateTime.now(),
        unreadCounts: {
          currentUserId: 0,
          otherUserId: 0,
        },
        createdAt: DateTime.now(),
      );

      await roomRef.set(room.toJson());

      return Right(room);
    } on FirebaseException catch (e) {
      return Left(
        ServerFailure(
        message:   e.message ?? 'Failed to create chat room.',
        ),
      );
    } catch (e) {
      return Left(
        ServerFailure(message: e.toString()),
      );
    }
  }


  @override
  Stream<Either<Failure, List<MessageModel>>> getMessages({
    required String roomId,
  })
  {
    try {
      return firestore
          .collection('chat_rooms')
          .doc(roomId)
          .collection('messages')
          .orderBy(
        'timestamp',
        descending: false,
      )
          .snapshots()
          .map(
            (snapshot) {
          final messages = snapshot.docs
              .map(
                (doc) => MessageModel.fromJson(
              doc.data(),
            ),
          )
              .toList();

          return Right<Failure, List<MessageModel>>(messages);
        },
      );
    } catch (e) {
      return Stream.value(
        Left(
          ServerFailure(
           message:  e.toString(),
          ),
        ),
      );
    }
  }


  @override
  Future<Either<Failure, Unit>> sendMessage({
    required String roomId,
    required MessageModel message,
  })
  async {
    try {
      final roomRef = firestore.collection('chat_rooms').doc(roomId);

      final messageRef = roomRef
          .collection('messages')
          .doc();

      await firestore.runTransaction((transaction) async {
        final roomSnapshot = await transaction.get(roomRef);

        if (!roomSnapshot.exists) {
          throw Exception('Chat room not found.');
        }

        final room = ChatRoomModel.fromJson(
          roomSnapshot.data()!,
          roomSnapshot.id,
        );

        final unreadCounts = Map<String, int>.from(room.unreadCounts);

        // Increase unread count for everyone except sender
        for (final participant in room.participants) {
          if (participant == message.senderId) {
            unreadCounts[participant] = 0;
          } else {
            unreadCounts[participant] =
                (unreadCounts[participant] ?? 0) + 1;
          }
        }

        transaction.set(
          messageRef,
          {
            ...message.toJson(),
            'id': messageRef.id,
          },
        );

        transaction.update(
          roomRef,
          {
            'lastMessage': message.content,
            'lastSenderId': message.senderId,
            'lastMessageTime': Timestamp.fromDate(message.timestamp),
            'unreadCounts': unreadCounts,
          },
        );
      });

      return const Right(unit);
    } on FirebaseException catch (e) {
      return Left(
        ServerFailure(
        message:   e.message ?? 'Failed to send message.',
        ),
      );
    } catch (e) {
      return Left(
        ServerFailure(
        message:   e.toString(),
        ),
      );
    }
  }


  @override
  Future<Either<Failure, Unit>> markMessagesAsRead({
    required String roomId,
    required String currentUserId,
  })
  async {
    try {
      final roomRef = firestore.collection('chat_rooms').doc(roomId);

      final messagesQuery = await roomRef
          .collection('messages')
          .where(
        'senderId',
        isNotEqualTo: currentUserId,
      )
          .get();

      final batch = firestore.batch();
      var hasChanges = false;

      // Reset unread count only if it isn't already zero
      final roomSnapshot = await roomRef.get();
      final roomUnreadCounts =
      Map<String, dynamic>.from(roomSnapshot.data()?['unreadCounts'] ?? {});

      if ((roomUnreadCounts[currentUserId] ?? 0) != 0) {
        batch.update(
          roomRef,
          {
            'unreadCounts.$currentUserId': 0,
          },
        );
        hasChanges = true;
      }

      // Mark every unread message as read
      for (final doc in messagesQuery.docs) {
        final data = doc.data();

        final List<dynamic> readBy =
        List<dynamic>.from(data['readBy'] ?? []);

        if (!readBy.contains(currentUserId)) {
          batch.update(
            doc.reference,
            {
              'readBy': FieldValue.arrayUnion(
                [currentUserId],
              ),
            },
          );
          hasChanges = true;
        }
      }

      if (hasChanges) {
        await batch.commit();
      }

      return const Right(unit);
    } on FirebaseException catch (e) {
      return Left(
        ServerFailure(
        message:   e.message ?? 'Failed to mark messages as read.',
        ),
      );
    } catch (e) {
      return Left(
        ServerFailure(message: e.toString()),
      );
    }
  }


  @override
  Future<Either<Failure, Unit>> editMessage({
    required String roomId,
    required String messageId,
    required String newContent,
  })
  async {
    try {
      final roomRef = firestore.collection('chat_rooms').doc(roomId);

      final messageRef = roomRef
          .collection('messages')
          .doc(messageId);

      final messageSnapshot = await messageRef.get();

      if (!messageSnapshot.exists) {
        throw Exception('Message not found');
      }

      final oldContent = messageSnapshot.data()?['content']?.toString() ?? '';

      // Update the message itself. This is the critical write and is done
      // without a transaction to avoid conflicts with read-marking writes.
      await messageRef.update(
        {
          'content': newContent,
          'isEdited': true,
        },
      );

      // Best-effort refresh of the room's last-message preview (cosmetic).
      // A failure here must not fail the whole edit.
      try {
        final roomSnapshot = await roomRef.get();
        if (roomSnapshot.exists &&
            roomSnapshot.data()?['lastMessage'] == oldContent) {
          await roomRef.update(
            {
              'lastMessage': newContent,
            },
          );
        }
      } catch (_) {}

      return const Right(unit);
    } on FirebaseException catch (e) {
      return Left(
        ServerFailure(
        message:   e.message ?? 'Failed to edit message.',
        ),
      );
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, Unit>> deleteChatRoom({
    required String roomId,
  })
  async {
    try {
      final roomRef = firestore.collection('chat_rooms').doc(roomId);

      // Get all messages
      final messagesSnapshot = await roomRef
          .collection('messages')
          .get();

      final batch = firestore.batch();

      // Delete all messages
      for (final doc in messagesSnapshot.docs) {
        batch.delete(doc.reference);
      }

      // Delete chat room
      batch.delete(roomRef);

      await batch.commit();

      return const Right(unit);
    } on FirebaseException catch (e) {
      return Left(
        ServerFailure(
        message:   e.message ?? 'Failed to delete chat room.',
        ),
      );
    } catch (e) {
      return Left(
        ServerFailure(
         message:  e.toString(),
        ),
      );
    }
  }

  @override
  Future<Either<Failure, int>> getUnreadCount({
    required String roomId,
    required String currentUserId,
  })
  async {
    try {
      final roomDoc = await firestore
          .collection('chat_rooms')
          .doc(roomId)
          .get();

      if (!roomDoc.exists) {
        return const Right(0);
      }

      final data = roomDoc.data()!;

      final unreadCounts = Map<String, dynamic>.from(
        data['unreadCounts'] ?? {},
      );

      final unread = unreadCounts[currentUserId] ?? 0;

      return Right(unread);
    } on FirebaseException catch (e) {
      return Left(
        ServerFailure(
         message:  e.message ?? 'Failed to get unread count.',
        ),
      );
    } catch (e) {
      return Left(
        ServerFailure(message: e.toString()),
      );
    }
  }

@override
  Future<Either<Failure, Unit>> deleteMessage({
    required String roomId,
    required String messageId,
  })
  async {
    try {
      final roomRef = firestore.collection('chat_rooms').doc(roomId);
      final messageRef = roomRef.collection('messages').doc(messageId);

      await messageRef.update({
        'content': AppStrings.deletedMessageLabel,
        'isDeleted': true,
        'isEdited': false,
      });

      // Fire-and-forget: update lastMessage preview
      roomRef.get().then((roomSnapshot) {
        if (roomSnapshot.exists) {
          final lastMsg = roomSnapshot.data()?['lastMessage']?.toString() ?? '';
          if (lastMsg != AppStrings.deletedMessageLabel) {
            roomRef.update({'lastMessage': AppStrings.deletedMessageLabel});
          }
        }
      }).catchError((_) {});

      return const Right(unit);
    } on FirebaseException catch (e) {
      return Left(
        ServerFailure(
        message:   e.message ?? 'Failed to delete message.',
        ),
      );
    } catch (e) {
      return Left(
        ServerFailure(message: e.toString()),
      );
    }
  }



}
