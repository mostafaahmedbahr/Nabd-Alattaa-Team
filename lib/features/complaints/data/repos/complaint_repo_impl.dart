import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dartz/dartz.dart';

import '../../../../core/constants/firestore_constants.dart';
import '../../../../core/error/failures.dart';
import '../models/complaint_comment_model.dart';
import '../models/complaint_model.dart';
import 'complaint_repo.dart';

class ComplaintRepoImpl implements ComplaintRepository {
  final FirebaseFirestore _firestore;

  ComplaintRepoImpl({FirebaseFirestore? firestore})
      : _firestore = firestore ?? FirebaseFirestore.instance;

  @override
  Stream<Either<Failure, List<ComplaintModel>>> getComplaints({String? status}) {
    try {
      Query<Map<String, dynamic>> query =
          _firestore.collection(FirestoreConstants.complaints);

      if (status != null) {
        query = query.where(
          FirestoreConstants.complaintStatus,
          isEqualTo: status,
        );
      }

      final stream = query
          .orderBy(FirestoreConstants.complaintCreatedAt, descending: true)
          .snapshots();

      return stream.map((snapshot) {
        final complaints = snapshot.docs
            .map((doc) => ComplaintModel.fromMap(doc.data()..['complaint_id'] = doc.id))
            .toList();
        return Right(complaints);
      });
    } catch (e) {
      return Stream.value(
        Left(FirestoreFailure(message: 'فشل في تحميل الشكاوى: ${e.toString()}')),
      );
    }
  }

  @override
  Future<Either<Failure, void>> createComplaint(ComplaintModel complaint) async {
    try {
      await _firestore
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
      await _firestore
          .collection(FirestoreConstants.complaints)
          .doc(complaintId)
          .update({
        FirestoreConstants.complaintStatus: status,
        FirestoreConstants.complaintUpdatedAt: Timestamp.now(),
      });
      return const Right(null);
    } catch (e) {
      return Left(FirestoreFailure(message: 'خطأ في تحديث الحالة: ${e.toString()}'));
    }
  }

  @override
  Stream<Either<Failure, List<ComplaintCommentModel>>> getComments(String complaintId) {
    try {
      final stream = _firestore
          .collection(FirestoreConstants.complaintComments)
          .where('complaint_id', isEqualTo: complaintId)
          .orderBy(FirestoreConstants.complaintCreatedAt, descending: false)
          .snapshots();

      return stream.map((snapshot) {
        final comments = snapshot.docs
            .map((doc) => ComplaintCommentModel.fromMap(doc.data()))
            .toList();
        return Right(comments);
      });
    } catch (e) {
      return Stream.value(
        Left(FirestoreFailure(message: 'فشل في تحميل التعليقات: ${e.toString()}')),
      );
    }
  }

  @override
  Future<Either<Failure, void>> addComment(
    String complaintId,
    ComplaintCommentModel comment,
  ) async {
    try {
      await _firestore
          .collection(FirestoreConstants.complaintComments)
          .doc(comment.id)
          .set(comment.toMap());
      return const Right(null);
    } catch (e) {
      return Left(FirestoreFailure(message: 'خطأ في إضافة التعليق: ${e.toString()}'));
    }
  }
}
