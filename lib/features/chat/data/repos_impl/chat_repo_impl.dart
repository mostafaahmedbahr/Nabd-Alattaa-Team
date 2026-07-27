import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dartz/dartz.dart';

import '../../../../core/constants/firestore_constants.dart';
import '../../../../core/error/failures.dart';
import '../models/chat_room_model.dart';
import '../models/message_model.dart';
import '../repos/chat_repo.dart';

class ChatRepoImpl implements ChatRepository {
  final FirebaseFirestore _firestore;

  ChatRepoImpl({FirebaseFirestore? firestore})
      : _firestore = firestore ?? FirebaseFirestore.instance;

  @override
  Stream<Either<Failure, List<ChatRoomModel>>> getChatRooms(String userId) {
    try {
      final stream = _firestore
          .collection(FirestoreConstants.chatRooms)
          .where(FirestoreConstants.chatRoomParticipants, arrayContains: userId)
          .snapshots();

      return stream.map((snapshot) {
        final rooms = snapshot.docs
            .map((doc) => ChatRoomModel.fromMap(doc.data()..['id'] = doc.id))
            .toList();

        rooms.sort((a, b) {
          if (a.lastMessageTime == null) return 1;
          if (b.lastMessageTime == null) return -1;
          return b.lastMessageTime!.compareTo(a.lastMessageTime!);
        });

        return Right(rooms);
      });
    } catch (e) {
      return Stream.value(
        Left(FirestoreFailure(message: 'فشل في تحميل غرف المحادثة: ${e.toString()}')),
      );
    }
  }

  @override
  Future<Either<Failure, List<MessageModel>>> getMessages(String chatRoomId) async {
    try {
      final snapshot = await _firestore
          .collection(FirestoreConstants.chatRooms)
          .doc(chatRoomId)
          .collection(FirestoreConstants.messages)
          .orderBy(FirestoreConstants.messageTimestamp, descending: true)
          .limit(50)
          .get();

      final messages = snapshot.docs
          .map((doc) => MessageModel.fromMap(doc.data()..['id'] = doc.id))
          .toList();

      return Right(messages);
    } catch (e) {
      return Left(FirestoreFailure(
        message: 'فشل في تحميل الرسائل: ${e.toString()}',
      ));
    }
  }

  @override
  Stream<Either<Failure, List<MessageModel>>> getMessagesStream(String chatRoomId) {
    try {
      final stream = _firestore
          .collection(FirestoreConstants.chatRooms)
          .doc(chatRoomId)
          .collection(FirestoreConstants.messages)
          .orderBy(FirestoreConstants.messageTimestamp, descending: true)
          .limit(50)
          .snapshots();

      return stream.map((snapshot) {
        final messages = snapshot.docs
            .map((doc) => MessageModel.fromMap(doc.data()..['id'] = doc.id))
            .toList();

        return Right(messages);
      });
    } catch (e) {
      return Stream.value(
        Left(FirestoreFailure(message: 'فشل في تحميل الرسائل: ${e.toString()}')),
      );
    }
  }

  @override
  Future<Either<Failure, void>> sendMessage(String chatRoomId, MessageModel message) async {
    try {
      await _firestore
          .collection(FirestoreConstants.chatRooms)
          .doc(chatRoomId)
          .collection(FirestoreConstants.messages)
          .doc(message.id)
          .set(message.toMap());

      await _firestore
          .collection(FirestoreConstants.chatRooms)
          .doc(chatRoomId)
          .update({
        FirestoreConstants.chatRoomLastMessage: message.content,
        FirestoreConstants.chatRoomLastMessageTime: message.timestamp,
      });

      return const Right(null);
    } catch (e) {
      return Left(FirestoreFailure(
        message: 'فشل في إرسال الرسالة: ${e.toString()}',
      ));
    }
  }

  @override
  Future<Either<Failure, ChatRoomModel>> createChatRoom(ChatRoomModel chatRoom) async {
    try {
      final docRef = await _firestore
          .collection(FirestoreConstants.chatRooms)
          .add(chatRoom.toMap()..remove('id'));

      final createdRoom = chatRoom.copyWith(id: docRef.id);
      await docRef.update({'id': docRef.id});

      return Right(createdRoom);
    } catch (e) {
      return Left(FirestoreFailure(
        message: 'فشل في إنشاء غرفة المحادثة: ${e.toString()}',
      ));
    }
  }

  @override
  Future<Either<Failure, void>> markMessagesAsRead(String chatRoomId, String userId) async {
    try {
      final snapshot = await _firestore
          .collection(FirestoreConstants.chatRooms)
          .doc(chatRoomId)
          .collection(FirestoreConstants.messages)
          .where(FirestoreConstants.messageIsRead, isEqualTo: false)
          .where(FirestoreConstants.messageSenderId, isNotEqualTo: userId)
          .get();

      final batch = _firestore.batch();
      for (final doc in snapshot.docs) {
        batch.update(doc.reference, {FirestoreConstants.messageIsRead: true});
      }
      await batch.commit();

      return const Right(null);
    } catch (e) {
      return Left(FirestoreFailure(
        message: 'فشل في تحديث حالة القراءة: ${e.toString()}',
      ));
    }
  }
}
