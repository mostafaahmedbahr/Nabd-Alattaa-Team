import 'package:firebase_auth/firebase_auth.dart';
import '../../../../common_imports.dart';
import '../view_model/task_cubit.dart';
import '../view_model/task_state.dart';
import '../widgets/tasks_view_widgets/tasks_app_bar_header.dart';
import '../widgets/tasks_view_widgets/tasks_filter_section.dart';
import '../widgets/tasks_view_widgets/tasks_list_items.dart';

class TasksScreen extends StatefulWidget {
  const TasksScreen({super.key});

  @override
  State<TasksScreen> createState() => _TasksScreenState();
}

class _TasksScreenState extends State<TasksScreen> {
  @override
  void initState() {
    super.initState();
    _loadMyTasks();
  }

  void _loadMyTasks() {
    context.read<TaskCubit>().loadTasks();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: BlocBuilder<TaskCubit, TaskState>(
        builder: (context, state) {
          final cubit = context.read<TaskCubit>();
          int totalTasks = 0;
          int completedTasks = 0;
          int inProgressTasks = 0;

          if (state is TaskLoaded) {
            totalTasks = state.tasks.length;
            completedTasks = state.tasks
                .where((t) => t.status == 'مكتملة')
                .length;
            inProgressTasks = state.tasks
                .where((t) => t.status == 'جاري التنفيذ')
                .length;
          }

          return AdaptiveContainer(
            child: CustomScrollView(
              physics: const BouncingScrollPhysics(),
              slivers: [
                TasksAppBarHeader(
                  totalTasks: totalTasks,
                  completedTasks: completedTasks,
                  inProgressTasks: inProgressTasks,
                ),
                TasksFilterSection(
                  statuses: cubit.statuses,
                  initialStatus: null,
                ),
                const TasksListItems(),
              ],
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () async {
          await context.push('/create-task');
          if (mounted) {
            _loadMyTasks();
          }
        },
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
        elevation: 4,
        icon: Icon(Icons.add_rounded, size: 24.sp),
        label: Text(
          "مهمة جديدة",
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15.sp),
        ),
      ),
    );
  }
}
