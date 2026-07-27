import 'package:dartz/dartz.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../../../../core/constants/firestore_constants.dart';
import '../../../../core/error/failures.dart';
import '../repos/idea_repo.dart';
import '../models/idea_model.dart';

class IdeaRepoImpl implements IdeaRepository {
  final FirebaseFirestore firestore;

  IdeaRepoImpl({required this.firestore});

  @override
  Stream<List<IdeaModel>> getIdeas({String? status}) {
    Query query = firestore.collection(FirestoreConstants.ideas);

    if (status != null) {
      query = query.where('status', isEqualTo: status);
    }

    return query.orderBy('created_at', descending: true).snapshots().map(
          (snapshot) => snapshot.docs
              .map((doc) => IdeaModel.fromMap(doc.data() as Map<String, dynamic>))
              .toList(),
        );
  }

  @override
  Future<Either<Failure, void>> createIdea(IdeaModel idea) async {
    try {
      await firestore
          .collection(FirestoreConstants.ideas)
          .doc(idea.id)
          .set(idea.toMap());
      return const Right(null);
    } catch (e) {
      return Left(FirestoreFailure(message: 'خطأ في إنشاء الفكرة: ${e.toString()}'));
    }
  }

  @override
  Future<Either<Failure, void>> updateIdeaStatus(String ideaId, String status, int rating) async {
    try {
      await firestore
          .collection(FirestoreConstants.ideas)
          .doc(ideaId)
          .update({
        'status': status,
        'rating': rating,
        'updated_at': Timestamp.now(),
      });
      return const Right(null);
    } catch (e) {
      return Left(FirestoreFailure(message: 'خطأ في تحديث الفكرة: ${e.toString()}'));
    }
  }
}
