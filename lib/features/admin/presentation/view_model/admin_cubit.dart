import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../../../complaints/data/models/complaint_model.dart';
import '../../../ideas/data/models/idea_model.dart';
import '../../../users/data/models/user_model.dart';
import '../../data/models/department_model.dart';
import '../../data/models/employee_stats_model.dart';
import '../../data/repos/admin_repo.dart';
import 'admin_state.dart';

class AdminCubit extends Cubit<AdminState> {
  final AdminRepository _adminRepo;

  AdminCubit(this._adminRepo) : super(const AdminInitial());

  List<UserModel> allEmployees = [];

  Future<void> loadDashboard() async {
    emit(const AdminLoading());

    final statsResult = await _adminRepo.getStatistics();
    final employeesResult = await _adminRepo.getEmployees();

    statsResult.fold(
      (failure) => emit(AdminError(message: failure.message)),
      (stats) {
        employeesResult.fold(
          (failure) => emit(AdminError(message: failure.message)),
          (employees) {
            final currentUid = FirebaseAuth.instance.currentUser?.uid;
            final visible = currentUid != null
                ? employees.where((e) => e.id != currentUid).toList()
                : employees;
            final sortedByPoints = List<UserModel>.from(visible)
              ..sort((a, b) => b.points.compareTo(a.points));
            final topEmployees = sortedByPoints.take(5).toList();

            emit(DashboardLoaded(
              statistics: stats,
              topEmployees: topEmployees,
            ));
          },
        );
      },
    );
  }

  Future<void> loadEmployees() async {
    emit(const AdminLoading());
    final result = await _adminRepo.getEmployees();
    result.fold(
      (failure) => emit(AdminError(message: failure.message)),
      (employees) {
        final currentUid = FirebaseAuth.instance.currentUser?.uid;
        final visible = currentUid != null
            ? employees.where((e) => e.id != currentUid).toList()
            : employees;
        allEmployees = visible;
        emit(EmployeesLoaded(
          employees: visible,
          filteredEmployees: visible,
        ));
      },
    );
  }

  Future<void> toggleUserActive(String userId, bool isActive) async {
    emit(const AdminLoading());
    final result = await _adminRepo.updateUserActive(userId, isActive);
    result.fold(
      (failure) => emit(AdminError(message: failure.message)),
      (_) => emit(AdminSuccess(
        message: isActive
            ? 'تم تفعيل المستخدم بنجاح'
            : 'تم إيقاف تفعيل المستخدم',
      )),
    );
  }

  Future<void> addUserPoints(String userId, int amount) async {
    emit(const AdminLoading());
    final result = await _adminRepo.addUserPoints(userId, amount);
    result.fold(
      (failure) => emit(AdminError(message: failure.message)),
      (_) => emit(AdminSuccess(message: 'تم إضافة النقاط بنجاح')),
    );
  }

  Future<void> loadEmployeeStats(UserModel user) async {
    emit(const AdminLoading());
    final result = await _adminRepo.getEmployeeStats(user.id ?? '');
    result.fold(
      (failure) => emit(AdminError(message: failure.message)),
      (stats) => emit(EmployeeStatsLoaded(user: user, stats: stats)),
    );
  }

  Future<void> loadComplaints() async {
    emit(const AdminLoading());
    final result = await _adminRepo.getComplaints();
    result.fold(
      (failure) => emit(AdminError(message: failure.message)),
      (complaints) => emit(ComplaintsLoaded(complaints: complaints)),
    );
  }

  Future<void> changeComplaintStatus(String complaintId, String status) async {
    emit(const AdminLoading());
    final result =
        await _adminRepo.updateComplaintStatus(complaintId, status);
    result.fold(
      (failure) => emit(AdminError(message: failure.message)),
      (_) => emit(const AdminSuccess(message: 'تم تحديث حالة الشكوى')),
    );
  }

  Future<void> loadIdeas() async {
    emit(const AdminLoading());
    final result = await _adminRepo.getIdeas();
    result.fold(
      (failure) => emit(AdminError(message: failure.message)),
      (ideas) => emit(IdeasLoaded(ideas: ideas)),
    );
  }

  Future<void> changeIdeaStatus(String ideaId, String status, int rating) async {
    emit(const AdminLoading());
    final result = await _adminRepo.updateIdeaStatus(ideaId, status, rating);
    result.fold(
      (failure) => emit(AdminError(message: failure.message)),
      (_) => emit(const AdminSuccess(message: 'تم تحديث حالة الفكرة')),
    );
  }

  Future<void> updateEmployeeRole(String userId, String newRole) async {
    final result = await _adminRepo.updateEmployeeRole(userId, newRole);
    result.fold(
      (failure) => emit(AdminError(message: failure.message)),
      (_) => emit(const AdminSuccess(message: 'تم تحديث الصلاحية بنجاح')),
    );
  }

  Future<void> loadDepartments() async {
    emit(const AdminLoading());
    final result = await _adminRepo.getDepartments();
    result.fold(
      (failure) => emit(AdminError(message: failure.message)),
      (departments) => emit(DepartmentsLoaded(departments: departments)),
    );
  }

  Future<void> createDepartment(DepartmentModel department) async {
    final result = await _adminRepo.createDepartment(department);
    result.fold(
      (failure) => emit(AdminError(message: failure.message)),
      (_) => emit(const AdminSuccess(message: 'تم إنشاء القسم بنجاح')),
    );
  }
}
