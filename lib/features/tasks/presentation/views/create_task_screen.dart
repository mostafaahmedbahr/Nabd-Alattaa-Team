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
import '../widgets/create_task_widgets/multiple_tasks_input.dart';

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
          if (state is TaskCreated) {
            context.read<TaskCubit>().resetCreateForm();
            context.read<TaskCubit>().loadTasks();
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: const Text("تم إنشاء المهمة بنجاح"),
                backgroundColor: Colors.green,
                behavior: SnackBarBehavior.floating,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                duration: const Duration(seconds: 2),
              ),
            );
            context.pop();
          } else if (state is TaskError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: Colors.red,
                behavior: SnackBarBehavior.floating,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
              ),
            );
          }
        },
        builder: (context, state) {
          var taskCubit = context.read<TaskCubit>();
          final isLoading = state is TaskCreating;
          return AdaptiveContainer(
            child: CustomScrollView(
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
                          title: "نوع المهمة",
                          icon: Icons.category_outlined,
                        ),
                        SizedBox(height: 14.h),
                        _buildEntryTypeSelector(taskCubit),
                        SizedBox(height: 24.h),
                        SectionHeader(
                          title: "بيانات المهمة",
                          icon: Icons.edit_note_rounded,
                        ),
                        SizedBox(height: 14.h),
                        if (taskCubit.selectedEntryType == 'single') ...[
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
                        ] else ...[
                          MultipleTasksInput(
                            items: taskCubit.draftSubtasks,
                            onAdd: (title, description) {
                              setState(() {
                                taskCubit.addDraftSubtask(title, description);
                              });
                            },
                            onUpdate: (updated) {
                              setState(() {
                                taskCubit.updateDraftSubtaskFull(updated);
                              });
                            },
                            onRemove: (id) {
                              setState(() {
                                taskCubit.removeDraftSubtask(id);
                              });
                            },
                            onReorder: (oldIndex, newIndex) {
                              setState(() {
                                taskCubit.reorderDraftSubtasks(oldIndex, newIndex);
                              });
                            },
                          ),
                        ],
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
          ),
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

  Widget _buildEntryTypeSelector(TaskCubit taskCubit) {
    final options = [
      (key: 'single', label: 'مهمة واحدة', icon: Icons.looks_one_rounded),
      (
        key: 'multiple',
        label: 'اختيار من متعدد',
        icon: Icons.playlist_add_check_rounded
      ),
    ];

    return Row(
      children: options.map((option) {
        final isSelected = taskCubit.selectedEntryType == option.key;
        return Expanded(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 5),
            child: GestureDetector(
              onTap: () {
                setState(() {
                  taskCubit.selectedEntryType = option.key;
                  if (option.key == 'single') {
                    taskCubit.clearDraftSubtasks();
                  }
                });
              },
              child: Container(
                padding: EdgeInsets.symmetric(vertical: 14.h),
                decoration: BoxDecoration(
                  color: isSelected
                      ? AppColors.primary.withValues(alpha: 0.1)
                      : Colors.white,
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(
                    color: isSelected
                        ? AppColors.primary.withValues(alpha: 0.5)
                        : AppColors.grey200,
                    width: isSelected ? 1.5 : 1,
                  ),
                ),
                child: Column(
                  children: [
                    Icon(
                      option.icon,
                      color: isSelected ? AppColors.primary : AppColors.grey400,
                      size: 24,
                    ),
                    SizedBox(height: 8.h),
                    Text(
                      option.label,
                      style: TextStyle(
                        fontSize: 13.sp,
                        fontWeight:
                            isSelected ? FontWeight.bold : FontWeight.w500,
                        color: isSelected ? AppColors.primary : AppColors.grey500,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      }).toList(),
    );
  }




}


