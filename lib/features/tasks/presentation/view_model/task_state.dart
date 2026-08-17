import 'package:equatable/equatable.dart';

import '../../data/models/task_model.dart';

abstract class TaskState extends Equatable {
  const TaskState();

  @override
  List<Object?> get props => [];
}

class TaskInitial extends TaskState {
  const TaskInitial();
}

class TaskLoading extends TaskState {
  const TaskLoading();
}

class TaskLoaded extends TaskState {
  final List<TaskModel> tasks;
  final List<TaskModel> myAssignedTasks;
  final List<TaskModel> assignedToMeTasks;

  const TaskLoaded({
    required this.tasks,
    this.myAssignedTasks = const [],
    this.assignedToMeTasks = const [],
  });

  @override
  List<Object?> get props => [tasks, myAssignedTasks, assignedToMeTasks];
}

class TaskCreating extends TaskState {
  final String title;
  final String description;
  final String assigneeId;
  final String assigneeName;
  final String priority;
  final DateTime dueDate;
  final String currentUserId;
  final String currentUserName;
  final bool isSubmitting;
  final String? titleError;
  final String? assigneeError;
  final String? priorityError;
  final String? dueDateError;
  final String? submitError;

  const TaskCreating({
    this.title = '',
    this.description = '',
    this.assigneeId = '',
    this.assigneeName = '',
    this.priority = 'متوسطة',
    required this.dueDate,
    this.currentUserId = '',
    this.currentUserName = '',
    this.isSubmitting = false,
    this.titleError,
    this.assigneeError,
    this.priorityError,
    this.dueDateError,
    this.submitError,
  });

  bool get canSubmit =>
      title.isNotEmpty &&
      assigneeId.isNotEmpty &&
      !isSubmitting;

  TaskCreating copyWith({
    String? title,
    String? description,
    String? assigneeId,
    String? assigneeName,
    String? priority,
    DateTime? dueDate,
    String? currentUserId,
    String? currentUserName,
    bool? isSubmitting,
    String? titleError,
    String? assigneeError,
    String? priorityError,
    String? dueDateError,
    String? submitError,
    bool clearTitleError = false,
    bool clearAssigneeError = false,
    bool clearPriorityError = false,
    bool clearDueDateError = false,
    bool clearSubmitError = false,
  }) {
    return TaskCreating(
      title: title ?? this.title,
      description: description ?? this.description,
      assigneeId: assigneeId ?? this.assigneeId,
      assigneeName: assigneeName ?? this.assigneeName,
      priority: priority ?? this.priority,
      dueDate: dueDate ?? this.dueDate,
      currentUserId: currentUserId ?? this.currentUserId,
      currentUserName: currentUserName ?? this.currentUserName,
      isSubmitting: isSubmitting ?? this.isSubmitting,
      titleError: clearTitleError ? null : (titleError ?? this.titleError),
      assigneeError: clearAssigneeError ? null : (assigneeError ?? this.assigneeError),
      priorityError: clearPriorityError ? null : (priorityError ?? this.priorityError),
      dueDateError: clearDueDateError ? null : (dueDateError ?? this.dueDateError),
      submitError: clearSubmitError ? null : (submitError ?? this.submitError),
    );
  }

  @override
  List<Object?> get props => [
        title,
        description,
        assigneeId,
        assigneeName,
        priority,
        dueDate,
        currentUserId,
        currentUserName,
        isSubmitting,
        titleError,
        assigneeError,
        priorityError,
        dueDateError,
        submitError,
      ];
}

class TaskCreated extends TaskState {
  const TaskCreated();
}

class TaskForwarding extends TaskState {
  const TaskForwarding();
}

class TaskForwarded extends TaskLoaded {
  final String newTaskId;

  const TaskForwarded({
    required this.newTaskId,
    required super.tasks,
    super.myAssignedTasks = const [],
    super.assignedToMeTasks = const [],
  });

  @override
  List<Object?> get props => [newTaskId, tasks, myAssignedTasks, assignedToMeTasks];
}

class TaskError extends TaskState {
  final String message;

  const TaskError({required this.message});

  @override
  List<Object?> get props => [message];
}


class GetTheCurrentUserSuccessState extends TaskState{}