import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../../../common_imports.dart';
import '../../../users/data/models/user_model.dart';
import '../../../users/presentation/widgets/user_search_dropdown.dart';
import '../view_model/task_cubit.dart';
import '../view_model/task_state.dart';
import '../widgets/create_task_widgets/create_task_app_bar_header.dart';
import '../widgets/create_task_widgets/date_card.dart';
import '../widgets/create_task_widgets/priority_selector.dart';
import '../widgets/create_task_widgets/section_header.dart' show SectionHeader;
import '../widgets/create_task_widgets/submit_button.dart';

class CreateTaskScreen extends StatefulWidget {
  const CreateTaskScreen({super.key});

  @override
  State<CreateTaskScreen> createState() => _CreateTaskScreenState();
}

class _CreateTaskScreenState extends State<CreateTaskScreen> {
  @override
  void initState() {
    super.initState();
    context.read<TaskCubit>().loadCurrentUser();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: BlocConsumer<TaskCubit, TaskState>(
        listener: (context, state) {
          if (state is TaskLoaded) {
            context.pop();
          } else if (state is TaskError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.message)),
            );
          }
        },
        builder: (context, state) {
          var taskCubit = context.read<TaskCubit>();
          final isLoading = state is TaskCreating;
          return CustomScrollView(
            physics: const BouncingScrollPhysics(),
            slivers: [
              CreateTaskAppBarHeader(),
              SliverToBoxAdapter(
                child: Form(
                  key: taskCubit.formKey,
                  child: Padding(
                    padding:   EdgeInsets.all(16.r),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SectionHeader(
                          title: "بيانات المهمة",
                          icon: Icons.edit_note_rounded,
                        ),
                          SizedBox(height: 14.h),
                        _buildTextField(
                          controller: taskCubit.titleController,
                          label: AppStrings.taskTitle,
                          icon: Icons.title_rounded,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'عنوان المهمة مطلوب';
                            }
                            return null;
                          },
                        ),
                          SizedBox(height: 12.h),
                        _buildTextField(
                          controller: taskCubit.descriptionController,
                          label: AppStrings.taskDescription,
                          icon: Icons.description_outlined,
                          maxLines: 3,
                        ),
                          SizedBox(height: 24.h),
                        SectionHeader(
                          title: "المسؤول والموعد",
                          icon: Icons.person_pin_circle_outlined,
                        ),
                        SizedBox(height: 24.h),
                        UserSearchDropdown(
                          selectedUserId: taskCubit.selectedAssigneeId,
                          selectedUserName: taskCubit.selectedAssigneeName,
                          onUserSelected: (UserModel user) {
                            setState(() {
                              taskCubit.selectedAssigneeId = user.id ?? '';
                              taskCubit.selectedAssigneeName = user.name;
                            });
                          },
                        ),
                        SizedBox(height: 12.h),
                        DateCard(),
                        SizedBox(height: 24.h),
                        SectionHeader(
                          title: "الأولوية",
                          icon: Icons.flag_outlined,
                        ),
                          SizedBox(height: 14.h),
                        PrioritySelector(
                          selectedPriority: taskCubit.selectedPriority,
                        ),
                          SizedBox(height: 32.h),
                        SubmitButton(isLoading: isLoading,),
                          SizedBox(height: 32.h),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    int maxLines = 1,
    String? Function(String?)? validator,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.grey200),
      ),
      child: CustomTextField(
        controller: controller,
        labelText: label,
        prefixIcon: icon,
        maxLines: maxLines,
        validator: validator,
      ),
    );
  }




}


