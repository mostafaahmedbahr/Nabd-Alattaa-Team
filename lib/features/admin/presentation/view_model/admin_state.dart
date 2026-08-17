import 'package:equatable/equatable.dart';

import '../../../complaints/data/models/complaint_model.dart';
import '../../../ideas/data/models/idea_model.dart';
import '../../../users/data/models/user_model.dart';
import '../../data/models/department_model.dart';
import '../../data/models/employee_stats_model.dart';

abstract class AdminState extends Equatable {
  const AdminState();

  @override
  List<Object?> get props => [];
}

class AdminInitial extends AdminState {
  const AdminInitial();
}

class AdminLoading extends AdminState {
  const AdminLoading();
}

class DashboardLoaded extends AdminState {
  final Map<String, int> statistics;
  final List<UserModel> topEmployees;

  const DashboardLoaded({
    required this.statistics,
    required this.topEmployees,
  });

  @override
  List<Object?> get props => [statistics, topEmployees];
}

class EmployeesLoaded extends AdminState {
  final List<UserModel> employees;
  final List<UserModel> filteredEmployees;

  const EmployeesLoaded({
    required this.employees,
    required this.filteredEmployees,
  });

  @override
  List<Object?> get props => [employees, filteredEmployees];
}

class EmployeeStatsLoaded extends AdminState {
  final UserModel user;
  final EmployeeStats stats;

  const EmployeeStatsLoaded({
    required this.user,
    required this.stats,
  });

  @override
  List<Object?> get props => [user, stats];
}

class ComplaintsLoaded extends AdminState {
  final List<ComplaintModel> complaints;

  const ComplaintsLoaded({required this.complaints});

  @override
  List<Object?> get props => [complaints];
}

class IdeasLoaded extends AdminState {
  final List<IdeaModel> ideas;

  const IdeasLoaded({required this.ideas});

  @override
  List<Object?> get props => [ideas];
}

class DepartmentsLoaded extends AdminState {
  final List<DepartmentModel> departments;

  const DepartmentsLoaded({required this.departments});

  @override
  List<Object?> get props => [departments];
}

class AdminError extends AdminState {
  final String message;

  const AdminError({required this.message});

  @override
  List<Object?> get props => [message];
}

class AdminSuccess extends AdminState {
  final String message;

  const AdminSuccess({required this.message});

  @override
  List<Object?> get props => [message];
}
