import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../../../complaints/data/models/complaint_model.dart';
import '../../../ideas/data/models/idea_model.dart';
import '../../../users/data/models/user_model.dart';
import '../models/department_model.dart';
import '../models/employee_stats_model.dart';

abstract class AdminRepository {
  Future<Either<Failure, List<UserModel>>> getEmployees();
  Future<Either<Failure, List<DepartmentModel>>> getDepartments();
  Future<Either<Failure, void>> updateEmployeeRole(
      String userId, String newRole);
  Future<Either<Failure, void>> createDepartment(DepartmentModel department);
  Future<Either<Failure, Map<String, int>>> getStatistics();

  Future<Either<Failure, void>> updateUserActive(
      String userId, bool isActive);
  Future<Either<Failure, void>> addUserPoints(String userId, int amount);
  Future<Either<Failure, EmployeeStats>> getEmployeeStats(String userId);

  Future<Either<Failure, List<ComplaintModel>>> getComplaints();
  Future<Either<Failure, void>> updateComplaintStatus(
      String complaintId, String status);

  Future<Either<Failure, List<IdeaModel>>> getIdeas();
  Future<Either<Failure, void>> updateIdeaStatus(
      String ideaId, String status, int rating);
}
