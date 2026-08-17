import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:uuid/uuid.dart';
import '../../../../common_imports.dart';
import '../../data/repos/task_repo.dart';
import '../../data/models/task_model.dart';
import '../../data/models/task_comment_model.dart';
import '../../data/models/task_subtask_model.dart';
import 'task_state.dart';

class TaskCubit extends Cubit<TaskState> {
  final TaskRepository taskRepository;
  StreamSubscription? _tasksSubscription;
  StreamSubscription? _commentsSubscription;

  String?  currentUserId;
  String?  currentStatus;

  TaskCubit({required this.taskRepository}) : super(TaskInitial());

  void loadTasks({String? status}) {
    final user = FirebaseAuth.instance.currentUser;
    currentUserId = user?.uid;
    currentStatus = status;

    if (currentUserId == null) return;

    _tasksSubscription?.cancel();

    _tasksSubscription = taskRepository
        .getTasks(
      currentUserId: currentUserId!,
      status: status,
    )
        .listen(
      (tasks) {
        final myAssignedTasks = tasks
            .where((t) =>
                t.creatorId == currentUserId &&
                t.assigneeId != currentUserId)
            .toList();
        final assignedToMeTasks = tasks
            .where((t) =>
                t.assigneeId == currentUserId &&
                t.creatorId != currentUserId)
            .toList();

        emit(TaskLoaded(
          tasks: tasks,
          myAssignedTasks: myAssignedTasks,
          assignedToMeTasks: assignedToMeTasks,
        ));
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
      (_) => loadTasks(status: currentStatus),
    );
  }

  Future<void> updateTask(String taskId, Map<String, dynamic> data) async {
    final result = await taskRepository.updateTask(taskId, data);
    result.fold(
      (failure) => emit(TaskError(message: failure.message)),
      (_) => loadTasks(status: currentStatus),
    );
  }

  Future<void> deleteTask(String taskId) async {
    final result = await taskRepository.deleteTask(taskId);
    result.fold(
      (failure) => emit(TaskError(message: failure.message)),
      (_) => loadTasks(status: currentStatus),
    );
  }

  Future<void> updateTaskStatus(String taskId, String status, int percentage) async {
    final result = await taskRepository.updateTaskStatus(taskId, status, percentage);
    result.fold(
      (failure) => emit(TaskError(message: failure.message)),
      (_) => loadTasks(status: currentStatus),
    );
  }

  Future<void> addSubtask(String taskId, TaskSubtask subtask) async {
    final result = await taskRepository.addSubtask(taskId, subtask);
    result.fold(
      (failure) => emit(TaskError(message: failure.message)),
      (_) => loadTasks(status: currentStatus),
    );
  }

  Future<void> updateSubtask(String taskId, TaskSubtask subtask) async {
    final result = await taskRepository.updateSubtask(taskId, subtask);
    result.fold(
      (failure) => emit(TaskError(message: failure.message)),
      (_) => loadTasks(status: currentStatus),
    );
  }

  Future<void> deleteSubtask(String taskId, String subtaskId) async {
    final result = await taskRepository.deleteSubtask(taskId, subtaskId);
    result.fold(
      (failure) => emit(TaskError(message: failure.message)),
      (_) => loadTasks(status: currentStatus),
    );
  }

  Future<void> toggleSubtask({
    required String taskId,
    required String subtaskId,
    required bool isCompleted,
    required String userId,
  }) async {
    final result = await taskRepository.toggleSubtask(
      taskId: taskId,
      subtaskId: subtaskId,
      isCompleted: isCompleted,
      userId: userId,
    );
    result.fold(
      (failure) => emit(TaskError(message: failure.message)),
      (_) => loadTasks(status: currentStatus),
    );
  }

  Future<void> forwardTask({
    required TaskModel originalTask,
    required String toUserId,
    required String toUserName,
    String? note,
  }) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      emit(const TaskError(message: 'لم يتم تسجيل الدخول'));
      return;
    }

    String fromUserName = currentUserName;
    if (fromUserName.isEmpty) {
      try {
        final ud = await FirebaseFirestore.instance
            .collection('users')
            .doc(user.uid)
            .get();
        fromUserName = ud.data()?['user_name'] ?? '';
      } catch (_) {}
    }

    emit(const TaskForwarding());

    final result = await taskRepository.forwardTask(
      originalTask: originalTask,
      fromUserId: user.uid,
      fromUserName: fromUserName,
      toUserId: toUserId,
      toUserName: toUserName,
      note: note,
    );

    result.fold(
      (failure) => emit(TaskError(message: failure.message)),
      (newTaskId) {
        final previous = state is TaskLoaded ? state as TaskLoaded : null;
        emit(TaskForwarded(
          newTaskId: newTaskId,
          tasks: previous?.tasks ?? const [],
          myAssignedTasks: previous?.myAssignedTasks ?? const [],
          assignedToMeTasks: previous?.assignedToMeTasks ?? const [],
        ));
      },
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

  @override
  Future<void> close() {
    _tasksSubscription?.cancel();
    _commentsSubscription?.cancel();
    return super.close();
  }

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

  void resetCreateForm() {
    titleController.clear();
    descriptionController.clear();
    selectedPriority = 'متوسطة';
    selectedAssigneeId = '';
    selectedAssigneeName = '';
    dueDate = DateTime.now().add(const Duration(days: 1));
    clearDraftSubtasks();
  }

  // Draft subtasks for the create-task form (local UI state).
  List<TaskSubtask> draftSubtasks = const [];

  void addDraftSubtask(String title) {
    draftSubtasks = [
      ...draftSubtasks,
      TaskSubtask(
        id: const Uuid().v4(),
        title: title,
        order: draftSubtasks.length,
      ),
    ];
  }

  void updateDraftSubtask(String id, String title) {
    draftSubtasks = draftSubtasks
        .map((s) => s.id == id ? s.copyWith(title: title) : s)
        .toList();
  }

  void removeDraftSubtask(String id) {
    draftSubtasks = draftSubtasks.where((s) => s.id != id).toList();
  }

  void toggleDraftSubtask(String id) {
    draftSubtasks = draftSubtasks
        .map((s) => s.id == id ? s.copyWith(isCompleted: !s.isCompleted) : s)
        .toList();
  }

  void reorderDraftSubtasks(int oldIndex, int newIndex) {
    final list = [...draftSubtasks];
    if (oldIndex < 0 || oldIndex >= list.length) return;
    final target = newIndex;
    final item = list.removeAt(oldIndex);
    list.insert(target, item);
    draftSubtasks = list
        .asMap()
        .entries
        .map((e) => e.value.copyWith(order: e.key))
        .toList();
  }

  void clearDraftSubtasks() {
    draftSubtasks = const [];
  }
}
