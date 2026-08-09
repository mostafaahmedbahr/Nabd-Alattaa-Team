import 'package:dartz/dartz.dart';

import '../../../../core/error/failures.dart';
import '../models/report_comment_model.dart';
import '../models/report_model.dart';

abstract class ReportRepository {
  Stream<Either<Failure, List<ReportModel>>> getReports({String? status});
  Future<Either<Failure, void>> createReport(ReportModel report);
  Future<Either<Failure, void>> updateReportStatus(String reportId, String status);
  Stream<Either<Failure, List<ReportCommentModel>>> getComments(String reportId);
  Future<Either<Failure, void>> addComment(String reportId, ReportCommentModel comment);
}
