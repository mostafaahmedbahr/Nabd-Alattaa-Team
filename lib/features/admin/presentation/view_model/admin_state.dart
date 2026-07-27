import 'package:equatable/equatable.dart';

import '../../auth/data/models/user_model.dart';
import '../models/department_model.dart';

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
