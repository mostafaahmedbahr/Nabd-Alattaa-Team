import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../../core/constants/firestore_constants.dart';
import '../../../../core/widgets/custom_text_field.dart';
import '../../../../core/widgets/error_widget.dart';
import '../../../../core/widgets/loading_widget.dart';
import '../../../users/data/models/user_model.dart';
import '../view_model/admin_cubit.dart';
import '../view_model/admin_state.dart';
import '../widgets/employee_card.dart';
import 'employee_details_screen.dart';

class ManageEmployeesScreen extends StatefulWidget {
  const ManageEmployeesScreen({super.key});

  @override
  State<ManageEmployeesScreen> createState() => _ManageEmployeesScreenState();
}

class _ManageEmployeesScreenState extends State<ManageEmployeesScreen> {
  final _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    context.read<AdminCubit>().loadEmployees();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.textPrimary),
          onPressed: () => context.pop(),
        ),
        title: const Text(
          'إدارة الموظفين',
          style: TextStyle(
            color: AppColors.textPrimary,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: CustomTextField(
              controller: _searchController,
              labelText: AppStrings.search,
              hintText: 'بحث بالاسم أو البريد أو القسم',
              prefixIcon: Icons.search,
              onChanged: (value) {
                context.read<AdminCubit>().filterEmployees(value ?? '');
              },
            ),
          ),
          Expanded(
            child: BlocConsumer<AdminCubit, AdminState>(
              listener: (context, state) {
                if (state is AdminSuccess) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(state.message),
                      backgroundColor: Colors.green,
                      behavior: SnackBarBehavior.floating,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  );
                  context.read<AdminCubit>().loadEmployees();
                } else if (state is AdminError) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(state.message),
                      backgroundColor: Colors.red,
                      behavior: SnackBarBehavior.floating,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  );
                }
              },
              builder: (context, state) {
                if (state is AdminLoading) {
                  return const LoadingWidget(message: AppStrings.loading);
                }

                if (state is AdminError) {
                  return CustomErrorWidget(
                    message: state.message,
                    onRetry: () => context.read<AdminCubit>().loadEmployees(),
                  );
                }

                if (state is EmployeesLoaded) {
                  if (state.filteredEmployees.isEmpty) {
                    return const EmptyStateWidget(
                      message: 'لا يوجد موظفين',
                      icon: Icons.people_outline,
                    );
                  }

                  return ListView.builder(
                    padding: const EdgeInsets.only(bottom: 16),
                    itemCount: state.filteredEmployees.length,
                    itemBuilder: (context, index) {
                      final employee = state.filteredEmployees[index];
                      return EmployeeCard(
                        employee: employee,
                        onToggleActive: (value) {
                          context
                              .read<AdminCubit>()
                              .toggleUserActive(employee.id ?? '', value);
                        },
                        onAddPoints: () => _openDetails(employee),
                        onTap: () => _openDetails(employee),
                      );
                    },
                  );
                }

                return const SizedBox.shrink();
              },
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _openDetails(UserModel employee) async {
    await context.push(
      '/employee-details',
      extra: employee,
    );
    if (mounted) {
      context.read<AdminCubit>().loadEmployees();
    }
  }
}
