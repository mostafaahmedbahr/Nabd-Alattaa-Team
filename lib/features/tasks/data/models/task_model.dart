import 'package:equatable/equatable.dart';

import '../../../../core/utils/enums.dart';
import 'task_subtask_model.dart';

class TaskModel extends Equatable {
  final String id;
  final String title;
  final String description;
  final String assigneeId;
  final String assigneeName;
  final String creatorId;
  final String creatorName;
  final String priority;
  final String status;
  final DateTime dueDate;
  final DateTime createdAt;
  final DateTime updatedAt;
  final int completionPercentage;
  TaskType taskType;

  final List<TaskSubtask> subtasks;

  final String entryType;

  final bool isForwarded;
  final String? originalTaskId;
  final String? parentTaskId;
  final String? forwardedFromUserId;
  final String? forwardedFromUserName;
  final String? forwardedToUserId;
  final DateTime? forwardedAt;
  final String? forwardNote;

  TaskModel({
    required this.id,
    required this.title,
    required this.description,
    required this.assigneeId,
    required this.assigneeName,
    required this.creatorId,
    required this.creatorName,
    required this.priority,
    required this.status,
    required this.dueDate,
    required this.createdAt,
    required this.updatedAt,
    this.completionPercentage = 0,
    this.taskType = TaskType.assignedToMe,
    this.subtasks = const [],
    this.entryType = 'single',
    this.isForwarded = false,
    this.originalTaskId,
    this.parentTaskId,
    this.forwardedFromUserId,
    this.forwardedFromUserName,
    this.forwardedToUserId,
    this.forwardedAt,
    this.forwardNote,
  });

  factory TaskModel.fromMap(Map<String, dynamic> map) {
    TaskType parseTaskType(dynamic value) {
      if (value is TaskType) return value;
      if (value is String) {
        switch (value) {
          case 'myOwnTask':
            return TaskType.myOwnTask;
          case 'createdByMe':
            return TaskType.createdByMe;
          case 'assignedToMe':
            return TaskType.assignedToMe;
        }
      }
      return TaskType.assignedToMe;
    }

    final subtasksRaw = map['subtasks'];
    final List<TaskSubtask> subtasks = subtasksRaw is List
        ? subtasksRaw
            .map((e) => e is Map<String, dynamic>
                ? TaskSubtask.fromMap(e)
                : TaskSubtask.fromMap(Map<String, dynamic>.from(e as Map)))
            .toList()
        : const <TaskSubtask>[];

    return TaskModel(
      id: map['task_id'] ?? '',
      title: map['title'] ?? '',
      description: map['description'] ?? '',
      assigneeId: map['assignee_id'] ?? '',
      assigneeName: map['assignee_name'] ?? '',
      creatorId: map['creator_id'] ?? '',
      creatorName: map['creator_name'] ?? '',
      priority: map['priority'] ?? 'medium',
      status: map['status'] ?? 'not_started',
      dueDate: map['due_date']?.toDate() ?? DateTime.now(),
      createdAt: map['created_at']?.toDate() ?? DateTime.now(),
      updatedAt: map['updated_at']?.toDate() ?? DateTime.now(),
      completionPercentage: map['completion_percentage'] ?? 0,
      taskType: parseTaskType(map['task_type']),
      subtasks: subtasks,
      entryType: map['entry_type'] ?? 'single',
      isForwarded: map['is_forwarded'] ?? false,
      originalTaskId: map['original_task_id'],
      parentTaskId: map['parent_task_id'],
      forwardedFromUserId: map['forwarded_from_user_id'],
      forwardedFromUserName: map['forwarded_from_user_name'],
      forwardedToUserId: map['forwarded_to_user_id'],
      forwardedAt: map['forwarded_at']?.toDate(),
      forwardNote: map['forward_note'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'task_id': id,
      'title': title,
      'description': description,
      'assignee_id': assigneeId,
      'assignee_name': assigneeName,
      'creator_id': creatorId,
      'creator_name': creatorName,
      'priority': priority,
      'status': status,
      'due_date': dueDate,
      'created_at': createdAt,
      'updated_at': updatedAt,
      'completion_percentage': completionPercentage,
      'task_type': taskType.name,
      'subtasks': subtasks.map((e) => e.toMap()).toList(),
      'entry_type': entryType,
      'is_forwarded': isForwarded,
      'original_task_id': originalTaskId,
      'parent_task_id': parentTaskId,
      'forwarded_from_user_id': forwardedFromUserId,
      'forwarded_from_user_name': forwardedFromUserName,
      'forwarded_to_user_id': forwardedToUserId,
      'forwarded_at': forwardedAt,
      'forward_note': forwardNote,
    };
  }

  /// Effective completion percentage.
  /// If the task has subtasks it is derived from them, otherwise the
  /// manually stored [completionPercentage] is used.
  int get effectiveCompletionPercentage {
    if (subtasks.isEmpty) return completionPercentage;
    final done = subtasks.where((s) => s.isCompleted).length;
    return ((done / subtasks.length) * 100).round();
  }

  /// Status derived from the effective completion percentage.
  /// 0% -> 'لم تبدأ', 1%-99% -> 'جاري التنفيذ', 100% -> 'مكتملة'.
  String get derivedStatus {
    final p = effectiveCompletionPercentage;
    if (p >= 100) return 'مكتملة';
    if (p <= 0) return 'لم تبدأ';
    return 'جاري التنفيذ';
  }

  /// Whether the status should be derived automatically (task has subtasks).
  bool get hasChecklist => subtasks.isNotEmpty;

  TaskModel copyWith({
    String? id,
    String? title,
    String? description,
    String? assigneeId,
    String? assigneeName,
    String? creatorId,
    String? creatorName,
    String? priority,
    String? status,
    DateTime? dueDate,
    DateTime? createdAt,
    DateTime? updatedAt,
    int? completionPercentage,
    TaskType? taskType,
    List<TaskSubtask>? subtasks,
    bool? isForwarded,
    String? originalTaskId,
    bool clearOriginalTaskId = false,
    String? parentTaskId,
    bool clearParentTaskId = false,
    String? forwardedFromUserId,
    String? forwardedFromUserName,
    String? forwardedToUserId,
    DateTime? forwardedAt,
    String? forwardNote,
  }) {
    return TaskModel(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      assigneeId: assigneeId ?? this.assigneeId,
      assigneeName: assigneeName ?? this.assigneeName,
      creatorId: creatorId ?? this.creatorId,
      creatorName: creatorName ?? this.creatorName,
      priority: priority ?? this.priority,
      status: status ?? this.status,
      dueDate: dueDate ?? this.dueDate,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      completionPercentage: completionPercentage ?? this.completionPercentage,
      taskType: taskType ?? this.taskType,
      subtasks: subtasks ?? this.subtasks,
      entryType: entryType ?? this.entryType,
      isForwarded: isForwarded ?? this.isForwarded,
      originalTaskId:
          clearOriginalTaskId ? null : (originalTaskId ?? this.originalTaskId),
      parentTaskId: clearParentTaskId ? null : (parentTaskId ?? this.parentTaskId),
      forwardedFromUserId: forwardedFromUserId ?? this.forwardedFromUserId,
      forwardedFromUserName: forwardedFromUserName ?? this.forwardedFromUserName,
      forwardedToUserId: forwardedToUserId ?? this.forwardedToUserId,
      forwardedAt: forwardedAt ?? this.forwardedAt,
      forwardNote: forwardNote ?? this.forwardNote,
    );
  }

  @override
  List<Object?> get props => [
        id,
        title,
        description,
        assigneeId,
        assigneeName,
        creatorId,
        creatorName,
        priority,
        status,
        dueDate,
        createdAt,
        updatedAt,
        completionPercentage,
        subtasks,
        entryType,
        isForwarded,
        originalTaskId,
        parentTaskId,
      ];
}
