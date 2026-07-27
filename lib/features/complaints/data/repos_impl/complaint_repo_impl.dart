import 'package:dartz/dartz.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../../../../core/constants/firestore_constants.dart';
import '../../../../core/error/failures.dart';
import '../repos/complaint_repo.dart';
import '../models/complaint_model.dart';
import '../models/complaint_comment_model.dart';

class ComplaintRepoImpl implements ComplaintRepository {
  final FirebaseFirestore firestore;

  ComplaintRepoImpl({required this.firestore});

  @override
  Stream<List<ComplaintModel>> getComplaints({String? status}) {
    Query query = firestore.collection(FirestoreConstants.complaints);

    if (status != null) {
      query = query.where('status', isEqualTo: status);
    }

    return query.orderBy('created_at', descending: true).snapshots().map(
          (snapshot) => snapshot.docs
              .map((doc) => ComplaintModel.fromMap(doc.data() as Map<String, dynamic>))
              .toList(),
        );
  }

  @override
  Future<Either<Failure, void>> createComplaint(ComplaintModel complaint) async {
    try {
      await firestore
          .collection(FirestoreConstants.complaints)
          .doc(complaint.id)
          .set(complaint.toMap());
      return const Right(null);
    } catch (e) {
      return Left(FirestoreFailure(message: 'خطأ في إنشاء الشكوى: ${e.toString()}'));
    }
  }

  @override
  Future<Either<Failure, void>> updateComplaintStatus(String complaintId, String status) async {
    try {
      await firestore
          .collection(FirestoreConstants.complaints)
          .doc(complaintId)
          .update({
        'status': status,
        'updated_at': Timestamp.now(),
      });
      return const Right(null);
    } catch (e) {
      return Left(FirestoreFailure(message: 'خطأ في تحديث الحالة: ${e.toString()}'));
    }
  }

  @override
  Stream<List<ComplaintCommentModel>> getComments(String complaintId) {
    return firestore
        .collection(FirestoreConstants.complaintComments)
        .where('complaint_id', isEqualTo: complaintId)
        .orderBy('created_at', descending: false)
        .snapshots()
        .map(
          (snapshot) => snapshot.docs
              .map((doc) => ComplaintCommentModel.fromMap(doc.data()))
              .toList(),
        );
  }

  @override
  Future<Either<Failure, void>> addComment(String complaintId, ComplaintCommentModel comment) async {
    try {
      await firestore
          .collection(FirestoreConstants.complaintComments)
          .doc(comment.id)
          .set(comment.toMap());
      return const Right(null);
    } catch (e) {
      return Left(FirestoreFailure(message: 'خطأ في إضافة التعليق: ${e.toString()}'));
    }
  }
}
