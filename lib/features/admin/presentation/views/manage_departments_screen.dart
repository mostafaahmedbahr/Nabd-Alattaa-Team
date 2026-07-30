// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
//
// import '../../../../core/constants/app_colors.dart';
// import '../../../../core/constants/app_strings.dart';
// import '../../../../core/widgets/custom_button.dart';
// import '../../../../core/widgets/custom_text_field.dart';
// import '../../../../core/widgets/loading_widget.dart';
// import '../../../../core/widgets/error_widget.dart';
// import '../view_model/admin_cubit.dart';
// import '../view_model/admin_state.dart';
// import '../../data/models/department_model.dart';
//
// class ManageDepartmentsScreen extends StatefulWidget {
//   const ManageDepartmentsScreen({super.key});
//
//   @override
//   State<ManageDepartmentsScreen> createState() =>
//       _ManageDepartmentsScreenState();
// }
//
// class _ManageDepartmentsScreenState extends State<ManageDepartmentsScreen> {
//   @override
//   void initState() {
//     super.initState();
//     context.read<AdminCubit>().loadDepartments();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: AppColors.background,
//       floatingActionButton: FloatingActionButton(
//         onPressed: () => _showAddDepartmentDialog(),
//         backgroundColor: AppColors.primary,
//         child: const Icon(Icons.add, color: AppColors.textWhite),
//       ),
//       body: BlocConsumer<AdminCubit, AdminState>(
//         listener: (context, state) {
//           if (state is AdminSuccess) {
//             ScaffoldMessenger.of(context).showSnackBar(
//               SnackBar(
//                 content: Text(state.message),
//                 backgroundColor: AppColors.success,
//               ),
//             );
//             context.read<AdminCubit>().loadDepartments();
//           } else if (state is AdminError) {
//             ScaffoldMessenger.of(context).showSnackBar(
//               SnackBar(
//                 content: Text(state.message),
//                 backgroundColor: AppColors.error,
//               ),
//             );
//           }
//         },
//         builder: (context, state) {
//           if (state is AdminLoading) {
//             return const LoadingWidget(message: AppStrings.loading);
//           }
//
//           if (state is AdminError) {
//             return CustomErrorWidget(
//               message: state.message,
//               onRetry: () => context.read<AdminCubit>().loadDepartments(),
//             );
//           }
//
//           if (state is DepartmentsLoaded) {
//             if (state.departments.isEmpty) {
//               return const EmptyStateWidget(
//                 message: 'لا توجد أقسام',
//                 icon: Icons.business_outlined,
//               );
//             }
//
//             return ListView.builder(
//               padding: const EdgeInsets.all(16),
//               itemCount: state.departments.length,
//               itemBuilder: (context, index) {
//                 final dept = state.departments[index];
//                 return _buildDepartmentCard(dept);
//               },
//             );
//           }
//
//           return const SizedBox.shrink();
//         },
//       ),
//     );
//   }
//
//   Widget _buildDepartmentCard(DepartmentModel dept) {
//     return Card(
//       elevation: 1,
//       margin: const EdgeInsets.only(bottom: 12),
//       shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
//       child: Padding(
//         padding: const EdgeInsets.all(16),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Row(
//               children: [
//                 Container(
//                   padding: const EdgeInsets.all(8),
//                   decoration: BoxDecoration(
//                     color: AppColors.primary.withOpacity(0.1),
//                     borderRadius: BorderRadius.circular(8),
//                   ),
//                   child: const Icon(
//                     Icons.business,
//                     color: AppColors.primary,
//                     size: 24,
//                   ),
//                 ),
//                 const SizedBox(width: 12),
//                 Expanded(
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       Text(
//                         dept.name,
//                         style: const TextStyle(
//                           fontSize: 16,
//                           fontWeight: FontWeight.bold,
//                           color: AppColors.textPrimary,
//                         ),
//                       ),
//                       if (dept.description.isNotEmpty)
//                         Text(
//                           dept.description,
//                           style: const TextStyle(
//                             fontSize: 12,
//                             color: AppColors.textSecondary,
//                           ),
//                           maxLines: 2,
//                           overflow: TextOverflow.ellipsis,
//                         ),
//                     ],
//                   ),
//                 ),
//               ],
//             ),
//             if (dept.managerName.isNotEmpty) ...[
//               const SizedBox(height: 12),
//               Row(
//                 children: [
//                   const Icon(
//                     Icons.person_outline,
//                     size: 16,
//                     color: AppColors.textSecondary,
//                   ),
//                   const SizedBox(width: 6),
//                   Text(
//                     'المدير: ${dept.managerName}',
//                     style: const TextStyle(
//                       fontSize: 12,
//                       color: AppColors.textSecondary,
//                     ),
//                   ),
//                 ],
//               ),
//             ],
//           ],
//         ),
//       ),
//     );
//   }
//
//   void _showAddDepartmentDialog() {
//     final nameController = TextEditingController();
//     final descController = TextEditingController();
//     final formKey = GlobalKey<FormState>();
//
//     showDialog(
//       context: context,
//       builder: (context) => AlertDialog(
//         title: const Text('إضافة قسم جديد'),
//         content: Form(
//           key: formKey,
//           child: Column(
//             mainAxisSize: MainAxisSize.min,
//             children: [
//               CustomTextField(
//                 controller: nameController,
//                 labelText: 'اسم القسم',
//                 prefixIcon: Icons.business_outlined,
//                 validator: (value) {
//                   if (value == null || value.isEmpty) {
//                     return 'اسم القسم مطلوب';
//                   }
//                   return null;
//                 },
//               ),
//               const SizedBox(height: 16),
//               CustomTextField(
//                 controller: descController,
//                 labelText: 'وصف القسم',
//                 prefixIcon: Icons.description_outlined,
//                 maxLines: 3,
//               ),
//             ],
//           ),
//         ),
//         actions: [
//           TextButton(
//             onPressed: () => Navigator.pop(context),
//             child: const Text(AppStrings.cancel),
//           ),
//           CustomButton(
//             text: AppStrings.add,
//             onPressed: () {
//               if (formKey.currentState!.validate()) {
//                 final department = DepartmentModel(
//                   id: '',
//                   name: nameController.text.trim(),
//                   description: descController.text.trim(),
//                 );
//                 Navigator.pop(context);
//                 context.read<AdminCubit>().createDepartment(department);
//               }
//             },
//             width: 100,
//           ),
//         ],
//       ),
//     );
//   }
// }
