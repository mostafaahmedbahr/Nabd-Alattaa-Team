// import 'package:flutter_bloc/flutter_bloc.dart';
//
//  import '../../../register/data/models/register_model.dart';
// import '../../data/models/department_model.dart';
// import '../../data/repos/admin_repo.dart';
// import 'admin_state.dart';
//
// class AdminCubit extends Cubit<AdminState> {
//   final AdminRepository _adminRepo;
//
//   AdminCubit(this._adminRepo) : super(const AdminInitial());
//
//   List<UserModel> allEmployees = [];
//
//   Future<void> loadDashboard() async {
//     emit(const AdminLoading());
//
//     final statsResult = await _adminRepo.getStatistics();
//     final employeesResult = await _adminRepo.getEmployees();
//
//     statsResult.fold(
//       (failure) => emit(AdminError(message: failure.message)),
//       (stats) {
//         employeesResult.fold(
//           (failure) => emit(AdminError(message: failure.message)),
//           (employees) {
//             final sortedByPoints = List<UserModel>.from(employees)
//               ..sort((a, b) => b.points.compareTo(a.points));
//             final topEmployees = sortedByPoints.take(5).toList();
//
//             emit(DashboardLoaded(
//               statistics: stats,
//               topEmployees: topEmployees,
//             ));
//           },
//         );
//       },
//     );
//   }
//
//   Future<void> loadEmployees() async {
//     emit(const AdminLoading());
//     final result = await _adminRepo.getEmployees();
//     result.fold(
//       (failure) => emit(AdminError(message: failure.message)),
//       (employees) {
//         allEmployees = employees;
//         emit(EmployeesLoaded(
//           employees: employees,
//           filteredEmployees: employees,
//         ));
//       },
//     );
//   }
//
//   // void filterEmployees(String query) {
//   //   final currentState = state;
//   //   if (currentState is EmployeesLoaded) {
//   //     if (query.isEmpty) {
//   //       emit(EmployeesLoaded(
//   //         employees: currentState.employees,
//   //         filteredEmployees: currentState.employees,
//   //       ));
//   //     } else {
//   //       final filtered = currentState.employees.where((emp) {
//   //         return emp.toLowerCase().contains(query.toLowerCase()) ||
//   //             emp.email.toLowerCase().contains(query.toLowerCase()) ||
//   //             emp.department.toLowerCase().contains(query.toLowerCase());
//   //       }).toList();
//   //       emit(EmployeesLoaded(
//   //         employees: currentState.employees,
//   //         filteredEmployees: filtered,
//   //       ));
//   //     }
//   //   }
//   // }
//
//   Future<void> updateEmployeeRole(String userId, String newRole) async {
//     final result = await _adminRepo.updateEmployeeRole(userId, newRole);
//     result.fold(
//       (failure) => emit(AdminError(message: failure.message)),
//       (_) => emit(const AdminSuccess(message: 'تم تحديث الصلاحية بنجاح')),
//     );
//   }
//
//   Future<void> loadDepartments() async {
//     emit(const AdminLoading());
//     final result = await _adminRepo.getDepartments();
//     result.fold(
//       (failure) => emit(AdminError(message: failure.message)),
//       (departments) => emit(DepartmentsLoaded(departments: departments)),
//     );
//   }
//
//   Future<void> createDepartment(DepartmentModel department) async {
//     final result = await _adminRepo.createDepartment(department);
//     result.fold(
//       (failure) => emit(AdminError(message: failure.message)),
//       (_) => emit(const AdminSuccess(message: 'تم إنشاء القسم بنجاح')),
//     );
//   }
// }
