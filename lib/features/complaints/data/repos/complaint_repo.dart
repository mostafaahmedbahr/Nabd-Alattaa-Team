import 'package:dartz/dartz.dart';

import '../../../../core/error/failures.dart';
import '../models/complaint_model.dart';
import '../models/complaint_comment_model.dart';

abstract class ComplaintRepository {
  Stream<List<ComplaintModel>> getComplaints({String? status});
  Future<Either<Failure, void>> createComplaint(ComplaintModel complaint);
  Future<Either<Failure, void>> updateComplaintStatus(String complaintId, String status);
  Stream<List<ComplaintCommentModel>> getComments(String complaintId);
  Future<Either<Failure, void>> addComment(String complaintId, ComplaintCommentModel comment);
}
