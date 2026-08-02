import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dartz/dartz.dart';

import '../../../../core/constants/firestore_constants.dart';
import '../../../../core/error/failures.dart';
import '../models/good_deed_model.dart';
import 'good_deed_repo.dart';

class GoodDeedRepoImpl implements GoodDeedRepository {
  final FirebaseFirestore _firestore;

  GoodDeedRepoImpl({FirebaseFirestore? firestore})
      : _firestore = firestore ?? FirebaseFirestore.instance;

  @override
  Stream<Either<Failure, List<GoodDeedModel>>> getGoodDeeds() {
    try {
      final stream = _firestore
          .collection(FirestoreConstants.goodDeeds)
          .orderBy(FirestoreConstants.goodDeedCreatedAt, descending: true)
          .snapshots();

      return stream.map((snapshot) {
        final deeds = snapshot.docs
            .map((doc) => GoodDeedModel.fromMap(doc.data()..['id'] = doc.id))
            .toList();

        return Right(deeds);
      });
    } catch (e) {
      return Stream.value(
        Left(FirestoreFailure(message: 'فشل في تحميل أعمال الخير: ${e.toString()}')),
      );
    }
  }

  @override
  Future<Either<Failure, void>> addGoodDeed(GoodDeedModel deed) async {
    try {
      final docRef = await _firestore
          .collection(FirestoreConstants.goodDeeds)
          .add(deed.toMap()..remove('id'));

      await docRef.update({'id': docRef.id});

      return const Right(null);
    } catch (e) {
      return Left(FirestoreFailure(
        message: 'فشل في مشاركة عمل الخير: ${e.toString()}',
      ));
    }
  }

  @override
  Future<Either<Failure, void>> likeDeed(String deedId, String userId) async {
    try {
      final reactionRef = _firestore
          .collection(FirestoreConstants.goodDeeds)
          .doc(deedId)
          .collection(FirestoreConstants.goodDeedReactions)
          .doc(userId);

      final reactionDoc = await reactionRef.get();

      if (reactionDoc.exists) {
        await reactionRef.delete();
        await _firestore
            .collection(FirestoreConstants.goodDeeds)
            .doc(deedId)
            .update({
          FirestoreConstants.goodDeedLikesCount: FieldValue.increment(-1),
        });
      } else {
        await reactionRef.set({'type': 'like'});
        await _firestore
            .collection(FirestoreConstants.goodDeeds)
            .doc(deedId)
            .update({
          FirestoreConstants.goodDeedLikesCount: FieldValue.increment(1),
        });
      }

      return const Right(null);
    } catch (e) {
      return Left(FirestoreFailure(
        message: 'فشل في التفاعل: ${e.toString()}',
      ));
    }
  }

  @override
  Future<Either<Failure, void>> prayForDeed(String deedId, String userId) async {
    try {
      final reactionRef = _firestore
          .collection(FirestoreConstants.goodDeeds)
          .doc(deedId)
          .collection(FirestoreConstants.goodDeedReactions)
          .doc('${userId}_prayer');

      final reactionDoc = await reactionRef.get();

      if (reactionDoc.exists) {
        await reactionRef.delete();
        await _firestore
            .collection(FirestoreConstants.goodDeeds)
            .doc(deedId)
            .update({
          FirestoreConstants.goodDeedPrayersCount: FieldValue.increment(-1),
        });
      } else {
        await reactionRef.set({'type': 'prayer'});
        await _firestore
            .collection(FirestoreConstants.goodDeeds)
            .doc(deedId)
            .update({
          FirestoreConstants.goodDeedPrayersCount: FieldValue.increment(1),
        });
      }

      return const Right(null);
    } catch (e) {
      return Left(FirestoreFailure(
        message: 'فشل في الدعاء: ${e.toString()}',
      ));
    }
  }

  @override
  Future<Either<Failure, bool>> hasUserLiked(String deedId, String userId) async {
    try {
      final doc = await _firestore
          .collection(FirestoreConstants.goodDeeds)
          .doc(deedId)
          .collection(FirestoreConstants.goodDeedReactions)
          .doc(userId)
          .get();

      return Right(doc.exists);
    } catch (e) {
      return Left(FirestoreFailure(message: 'فشل في التحقق: ${e.toString()}'));
    }
  }

  @override
  Future<Either<Failure, bool>> hasUserPrayed(String deedId, String userId) async {
    try {
      final doc = await _firestore
          .collection(FirestoreConstants.goodDeeds)
          .doc(deedId)
          .collection(FirestoreConstants.goodDeedReactions)
          .doc('${userId}_prayer')
          .get();

      return Right(doc.exists);
    } catch (e) {
      return Left(FirestoreFailure(message: 'فشل في التحقق: ${e.toString()}'));
    }
  }
}
