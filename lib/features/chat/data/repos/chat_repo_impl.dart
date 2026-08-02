import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dartz/dartz.dart';

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

      // Reset unread count
      batch.update(
        roomRef,
        {
          'unreadCounts.$currentUserId': 0,
        },
      );

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
        }
      }

      await batch.commit();

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

      await firestore.runTransaction((transaction) async {
        final messageSnapshot = await transaction.get(messageRef);

        if (!messageSnapshot.exists) {
          throw Exception('Message not found');
        }

        transaction.update(
          messageRef,
          {
            'content': newContent,
            'isEdited': true,
          },
        );

        final roomSnapshot = await transaction.get(roomRef);

        if (roomSnapshot.exists) {
          final room = ChatRoomModel.fromJson(
            roomSnapshot.data()!,
            roomSnapshot.id,
          );

          if (room.lastMessage == messageSnapshot['content']) {
            transaction.update(
              roomRef,
              {
                'lastMessage': newContent,
              },
            );
          }
        }
      });

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

      final messageRef = roomRef
          .collection('messages')
          .doc(messageId);

      await firestore.runTransaction((transaction) async {
        final messageSnapshot = await transaction.get(messageRef);

        if (!messageSnapshot.exists) {
          throw Exception('Message not found.');
        }

        final messageData = messageSnapshot.data()!;

        final deletedContent = 'تم حذف هذه الرسالة';

        // Soft delete message
        transaction.update(
          messageRef,
          {
            'content': deletedContent,
            'isDeleted': true,
            'isEdited': false,
          },
        );

        // Update last message if this was the latest one
        final roomSnapshot = await transaction.get(roomRef);

        if (roomSnapshot.exists) {
          final roomData = roomSnapshot.data()!;

          if (roomData['lastMessage'] == messageData['content']) {
            transaction.update(
              roomRef,
              {
                'lastMessage': deletedContent,
              },
            );
          }
        }
      });

      return const Right(unit);
    } on FirebaseException catch (e) {
      return Left(
        ServerFailure(
         message:  e.message ?? 'Failed to delete message.',
        ),
      );
    } catch (e) {
      return Left(
        ServerFailure(message: e.toString()),
      );
    }
  }



}
