import 'package:dartz/dartz.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../../../../core/constants/firestore_constants.dart';
import '../../../../core/error/failures.dart';
import '../repos/report_repo.dart';
import '../models/report_model.dart';
import '../models/report_comment_model.dart';

class ReportRepoImpl implements ReportRepository {
  final FirebaseFirestore firestore;

  ReportRepoImpl({required this.firestore});

  @override
  Stream<List<ReportModel>> getReports({String? status}) {
    Query query = firestore.collection(FirestoreConstants.reports);

    if (status != null) {
      query = query.where('status', isEqualTo: status);
    }

    return query.orderBy('created_at', descending: true).snapshots().map(
          (snapshot) => snapshot.docs
              .map((doc) => ReportModel.fromMap(doc.data() as Map<String, dynamic>))
              .toList(),
        );
  }

  @override
  Future<Either<Failure, void>> createReport(ReportModel report) async {
    try {
      await firestore
          .collection(FirestoreConstants.reports)
          .doc(report.id)
          .set(report.toMap());
      return const Right(null);
    } catch (e) {
      return Left(FirestoreFailure(message: 'خطأ في إنشاء البلاغ: ${e.toString()}'));
    }
  }

  @override
  Future<Either<Failure, void>> updateReportStatus(String reportId, String status) async {
    try {
      final data = <String, dynamic>{
        'status': status,
        'updated_at': Timestamp.now(),
      };
      if (status == 'closed') {
        data['closed_at'] = Timestamp.now();
      }
      await firestore
          .collection(FirestoreConstants.reports)
          .doc(reportId)
          .update(data);
      return const Right(null);
    } catch (e) {
      return Left(FirestoreFailure(message: 'خطأ في تحديث الحالة: ${e.toString()}'));
    }
  }

  @override
  Stream<List<ReportCommentModel>> getComments(String reportId) {
    return firestore
        .collection(FirestoreConstants.reportComments)
        .where('report_id', isEqualTo: reportId)
        .orderBy('created_at', descending: false)
        .snapshots()
        .map(
          (snapshot) => snapshot.docs
              .map((doc) => ReportCommentModel.fromMap(doc.data()))
              .toList(),
        );
  }

  @override
  Future<Either<Failure, void>> addComment(String reportId, ReportCommentModel comment) async {
    try {
      await firestore
          .collection(FirestoreConstants.reportComments)
          .doc(comment.id)
          .set(comment.toMap());
      return const Right(null);
    } catch (e) {
      return Left(FirestoreFailure(message: 'خطأ في إضافة التعليق: ${e.toString()}'));
    }
  }
}
