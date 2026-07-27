import 'package:dartz/dartz.dart';

import '../../../../core/error/failures.dart';
import '../models/task_model.dart';
import '../models/task_comment_model.dart';

abstract class TaskRepository {
  Stream<List<TaskModel>> getTasks({String? assigneeId, String? status});
  Future<Either<Failure, void>> createTask(TaskModel task);
  Future<Either<Failure, void>> updateTask(String taskId, Map<String, dynamic> data);
  Future<Either<Failure, void>> deleteTask(String taskId);
  Future<Either<Failure, void>> updateTaskStatus(String taskId, String status, int percentage);
  Stream<List<TaskCommentModel>> getComments(String taskId);
  Future<Either<Failure, void>> addComment(String taskId, TaskCommentModel comment);
}
