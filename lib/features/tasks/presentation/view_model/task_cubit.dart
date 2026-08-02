import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../../../common_imports.dart';
import '../../data/repos/task_repo.dart';
import '../../data/models/task_model.dart';
import '../../data/models/task_comment_model.dart';
import 'task_state.dart';

class TaskCubit extends Cubit<TaskState> {
  final TaskRepository taskRepository;
  StreamSubscription? _tasksSubscription;
  StreamSubscription? _commentsSubscription;

  TaskCubit({required this.taskRepository}) : super(TaskInitial());

  void loadTasks({String? assigneeId, String? status}) {
    emit(TaskLoading());
    _tasksSubscription?.cancel();
    _tasksSubscription = taskRepository
        .getTasks(assigneeId: assigneeId, status: status)
        .listen(
      (tasks) {
        emit(TaskLoaded(tasks: tasks));
      },
      onError: (error) {
        emit(TaskError(message: error.toString()));
      },
    );
  }

  Future<void> createTask(TaskModel task) async {
    emit(TaskCreated());
    final result = await taskRepository.createTask(task);
    result.fold(
      (failure) => emit(TaskError(message: failure.message)),
      (_) => loadTasks(),
    );
  }

  Future<void> updateTask(String taskId, Map<String, dynamic> data) async {
    final result = await taskRepository.updateTask(taskId, data);
    result.fold(
      (failure) => emit(TaskError(message: failure.message)),
      (_) {},
    );
  }

  Future<void> deleteTask(String taskId) async {
    final result = await taskRepository.deleteTask(taskId);
    result.fold(
      (failure) => emit(TaskError(message: failure.message)),
      (_) => loadTasks(),
    );
  }

  Future<void> updateTaskStatus(String taskId, String status, int percentage) async {
    final result = await taskRepository.updateTaskStatus(taskId, status, percentage);
    result.fold(
      (failure) => emit(TaskError(message: failure.message)),
      (_) {},
    );
  }

  void loadComments(String taskId) {
    _commentsSubscription?.cancel();
    _commentsSubscription = taskRepository.getComments(taskId).listen(
      (comments) {
        if (state is TaskLoaded) {
          // Handle comments separately if needed
        }
      },
      onError: (error) {
        emit(TaskError(message: error.toString()));
      },
    );
  }

  Future<void> addComment(String taskId, TaskCommentModel comment) async {
    final result = await taskRepository.addComment(taskId, comment);
    result.fold(
      (failure) => emit(TaskError(message: failure.message)),
      (_) => loadComments(taskId),
    );
  }

  // @override
  // void close() {
  //   _tasksSubscription?.cancel();
  //   _commentsSubscription?.cancel();
  //   return super.close();
  // }

  final List<Map<String, dynamic>> statuses = [
    {'key': null, 'label': 'الكل', 'icon': Icons.grid_view_rounded, 'color': AppColors.primary},
    {'key': 'لم تبدأ', 'label': AppStrings.notStarted, 'icon': Icons.hourglass_empty_rounded, 'color': AppColors.taskNotStarted},
    {'key': 'جاري التنفيذ', 'label': AppStrings.inProgress, 'icon': Icons.play_circle_fill_rounded, 'color': AppColors.taskInProgress},
    {'key': 'مكتملة', 'label': AppStrings.completed, 'icon': Icons.check_circle_rounded, 'color': AppColors.taskCompleted},
  ];



  /// create task
  final formKey = GlobalKey<FormState>();
  final titleController = TextEditingController();
  final descriptionController = TextEditingController();
  String selectedPriority = 'متوسطة';
  String selectedAssigneeId = '';
  String selectedAssigneeName = '';
  DateTime dueDate = DateTime.now().add(const Duration(days: 1));
  String currentUserName = '';
  String currentUserId = '';

  void loadCurrentUser() {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      currentUserId = user.uid;
      FirebaseFirestore.instance.collection('users').doc(user.uid).get().then((doc) {
        if (doc.exists) {
            currentUserName = doc.data()?['user_name'] ?? '';
            emit(GetTheCurrentUserSuccessState());
        }
      });
    }
  }


  @override
  Future<void> close() {
    titleController.dispose();
    descriptionController.dispose();

    return super.close();
  }

}
