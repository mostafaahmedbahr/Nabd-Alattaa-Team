import 'package:equatable/equatable.dart';

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

  const TaskModel({
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
  });

  factory TaskModel.fromMap(Map<String, dynamic> map) {
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
    };
  }

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
    );
  }

  @override
  List<Object?> get props => [
        id, title, description, assigneeId, assigneeName,
        creatorId, creatorName, priority, status, dueDate,
        createdAt, updatedAt, completionPercentage,
      ];
}
