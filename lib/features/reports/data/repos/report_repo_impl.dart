import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dartz/dartz.dart';

import '../../../../core/constants/firestore_constants.dart';
import '../../../../core/error/failures.dart';
import '../models/report_comment_model.dart';
import '../models/report_model.dart';
import 'report_repo.dart';

class ReportRepoImpl implements ReportRepository {
  final FirebaseFirestore _firestore;

  ReportRepoImpl({FirebaseFirestore? firestore})
      : _firestore = firestore ?? FirebaseFirestore.instance;

  @override
  Stream<Either<Failure, List<ReportModel>>> getReports({String? status}) {
    try {
      Query<Map<String, dynamic>> query =
          _firestore.collection(FirestoreConstants.reports);

      if (status != null) {
        query = query.where(
          FirestoreConstants.reportStatus,
          isEqualTo: status,
        );
      }

      final stream = query
          .orderBy(FirestoreConstants.reportCreatedAt, descending: true)
          .snapshots();

      return stream.map((snapshot) {
        final reports = snapshot.docs
            .map((doc) => ReportModel.fromMap(doc.data()..['report_id'] = doc.id))
            .toList();
        return Right(reports);
      });
    } catch (e) {
      return Stream.value(
        Left(FirestoreFailure(message: 'فشل في تحميل البلاغات: ${e.toString()}')),
      );
    }
  }

  @override
  Future<Either<Failure, void>> createReport(ReportModel report) async {
    try {
      await _firestore
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
        FirestoreConstants.reportStatus: status,
        FirestoreConstants.reportUpdatedAt: Timestamp.now(),
      };
      if (status == ReportStatus.closed) {
        data[FirestoreConstants.reportClosedAt] = Timestamp.now();
      }
      await _firestore
          .collection(FirestoreConstants.reports)
          .doc(reportId)
          .update(data);
      return const Right(null);
    } catch (e) {
      return Left(FirestoreFailure(message: 'خطأ في تحديث الحالة: ${e.toString()}'));
    }
  }

  @override
  Stream<Either<Failure, List<ReportCommentModel>>> getComments(String reportId) {
    try {
      final stream = _firestore
          .collection(FirestoreConstants.reportComments)
          .where('report_id', isEqualTo: reportId)
          .orderBy(FirestoreConstants.reportCreatedAt, descending: false)
          .snapshots();

      return stream.map((snapshot) {
        final comments = snapshot.docs
            .map((doc) => ReportCommentModel.fromMap(doc.data()))
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
    String reportId,
    ReportCommentModel comment,
  ) async {
    try {
      await _firestore
          .collection(FirestoreConstants.reportComments)
          .doc(comment.id)
          .set(comment.toMap());
      return const Right(null);
    } catch (e) {
      return Left(FirestoreFailure(message: 'خطأ في إضافة التعليق: ${e.toString()}'));
    }
  }
}
