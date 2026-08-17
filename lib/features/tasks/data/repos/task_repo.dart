import 'package:dartz/dartz.dart';

import '../../../../core/error/failures.dart';
import '../models/task_model.dart';
import '../models/task_comment_model.dart';
import '../models/task_subtask_model.dart';

abstract class TaskRepository {
  Stream<List<TaskModel>> getTasks({required String currentUserId, String? status});

  Future<Either<Failure, void>> createTask(TaskModel task);

  Future<Either<Failure, void>> updateTask(String taskId, Map<String, dynamic> data);

  Future<Either<Failure, void>> deleteTask(String taskId);

  Future<Either<Failure, void>> updateTaskStatus(String taskId, String status, int percentage);

  // Subtasks
  Future<Either<Failure, void>> addSubtask(String taskId, TaskSubtask subtask);

  Future<Either<Failure, void>> updateSubtask(String taskId, TaskSubtask subtask);

  Future<Either<Failure, void>> deleteSubtask(String taskId, String subtaskId);

  Future<Either<Failure, void>> toggleSubtask({
    required String taskId,
    required String subtaskId,
    required bool isCompleted,
    required String userId,
  });

  // Forwarding
  Future<Either<Failure, String>> forwardTask({
    required TaskModel originalTask,
    required String fromUserId,
    required String fromUserName,
    required String toUserId,
    required String toUserName,
    String? note,
  });

  Stream<List<TaskCommentModel>> getComments(String taskId);

  Future<Either<Failure, void>> addComment(String taskId, TaskCommentModel comment);
}
