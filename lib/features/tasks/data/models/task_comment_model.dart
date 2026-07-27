import 'package:equatable/equatable.dart';

class TaskCommentModel extends Equatable {
  final String id;
  final String taskId;
  final String userId;
  final String userName;
  final String content;
  final DateTime createdAt;

  const TaskCommentModel({
    required this.id,
    required this.taskId,
    required this.userId,
    required this.userName,
    required this.content,
    required this.createdAt,
  });

  factory TaskCommentModel.fromMap(Map<String, dynamic> map) {
    return TaskCommentModel(
      id: map['id'] ?? '',
      taskId: map['task_id'] ?? '',
      userId: map['user_id'] ?? '',
      userName: map['user_name'] ?? '',
      content: map['content'] ?? '',
      createdAt: map['created_at']?.toDate() ?? DateTime.now(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'task_id': taskId,
      'user_id': userId,
      'user_name': userName,
      'content': content,
      'created_at': createdAt,
    };
  }

  @override
  List<Object?> get props => [id, taskId, userId, userName, content, createdAt];
}
