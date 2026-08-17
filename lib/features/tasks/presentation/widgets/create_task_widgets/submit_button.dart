import 'package:nabd_alattaa_team/features/tasks/data/models/task_model.dart';
import 'package:uuid/uuid.dart';

import '../../../../../common_imports.dart';
import '../../../../../core/utils/enums.dart';
import '../../view_model/task_cubit.dart';
import '../../view_model/task_state.dart';

class SubmitButton extends StatelessWidget {
  const SubmitButton({super.key, required this.isLoading,});
  final bool isLoading;
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<TaskCubit, TaskState>(
      builder: (context, state) {
        var taskCubit = context.read<TaskCubit>();
        return SizedBox(
          width: double.infinity,
          height: 54,
          child: ElevatedButton(
            onPressed: isLoading
                ? null
                : () {
              if (taskCubit.formKey.currentState!.validate()) {
                final task = TaskModel(
                  id: const Uuid().v4(),
                  title: taskCubit.titleController.text,
                  description: taskCubit.descriptionController.text,
                  assigneeId: taskCubit.selectedAssigneeId,
                  assigneeName: taskCubit.selectedAssigneeName,
                  creatorId: taskCubit.currentUserId.toString(),
                  creatorName: taskCubit.currentUserName,
                  priority: taskCubit.selectedPriority,
                  status: 'لم تبدأ',
                  dueDate: taskCubit.dueDate,
                  createdAt: DateTime.now(),
                  updatedAt: DateTime.now(),
                  taskType: taskCubit.selectedAssigneeId == taskCubit.currentUserId
                      ? TaskType.myOwnTask
                      : TaskType.createdByMe,
                  subtasks: taskCubit.draftSubtasks,
                );
                context.read<TaskCubit>().createTask(task);
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              foregroundColor: Colors.white,
              disabledBackgroundColor: AppColors.grey300,
              elevation: 0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(14.r),
              ),
            ),
            child: isLoading
                ?   SizedBox(
              height: 24.h,
              width: 24.w,
              child: CircularProgressIndicator(
                strokeWidth: 2.5.w,
                color: Colors.white,
              ),
            )
                :   Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.check_rounded, size: 22.sp),
                SizedBox(width: 10.w),
                Text(
                  "إنشاء المهمة",
                  style: TextStyle(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
