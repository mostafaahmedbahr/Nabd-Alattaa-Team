import 'package:dartz/dartz.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../../../../core/constants/firestore_constants.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/utils/enums.dart';
import 'task_repo.dart';
import '../models/task_model.dart';
import '../models/task_comment_model.dart';

class TaskRepoImpl implements TaskRepository {
  final FirebaseFirestore firestore;

  TaskRepoImpl({required this.firestore});

  @override
  Stream<List<TaskModel>> getTasks({required String currentUserId,
    String? status,}) {
    return firestore
        .collection(FirestoreConstants.tasks)
        .snapshots()
        .map((snapshot) {
      final tasks = snapshot.docs
          .map((doc) {
        final task = TaskModel.fromMap(doc.data());

        if (task.creatorId == currentUserId &&
            task.assigneeId == currentUserId) {
          task.taskType = TaskType.myOwnTask;
        } else if (task.creatorId == currentUserId) {
          task.taskType = TaskType.createdByMe;
        } else if (task.assigneeId == currentUserId) {
          task.taskType = TaskType.assignedToMe;
        }

        return task;
      })
          .where((task) =>
      task.creatorId == currentUserId ||
          task.assigneeId == currentUserId)
          .toList();

      if (status != null) {
        tasks.removeWhere((e) => e.status != status);
      }

      tasks.sort((a, b) => b.createdAt.compareTo(a.createdAt));

      return tasks;
    });
  }

  @override
  Future<Either<Failure, void>> createTask(TaskModel task) async {
    try {
      await firestore
          .collection(FirestoreConstants.tasks)
          .doc(task.id)
          .set(task.toMap());

      await _sendNotificationToAssignee(
        assigneeId: task.assigneeId,
        title: 'مهمة جديدة',
        body: 'تم تعيين لك مهمة: ${task.title}',
        taskId: task.id,
      );

      return const Right(null);
    } catch (e) {
      return Left(FirestoreFailure(message: 'خطأ في إنشاء المهمة: ${e.toString()}'));
    }
  }

  Future<void> _sendNotificationToAssignee({
    required String assigneeId,
    required String title,
    required String body,
    required String taskId,
  }) async {
    try {
      await firestore.collection(FirestoreConstants.notifications).add({
        FirestoreConstants.userId: assigneeId,
        FirestoreConstants.notificationTitle: title,
        FirestoreConstants.notificationBody: body,
        FirestoreConstants.notificationType: 'new_task',
        FirestoreConstants.notificationReferenceId: taskId,
        FirestoreConstants.notificationIsRead: false,
        FirestoreConstants.notificationCreatedAt: Timestamp.now(),
      });
    } catch (e) {
      print('Error sending task notification: $e');
    }
  }

  @override
  Future<Either<Failure, void>> updateTask(String taskId, Map<String, dynamic> data) async {
    try {
      data['updated_at'] = Timestamp.now();
      await firestore
          .collection(FirestoreConstants.tasks)
          .doc(taskId)
          .update(data);
      return const Right(null);
    } catch (e) {
      return Left(FirestoreFailure(message: 'خطأ في تحديث المهمة: ${e.toString()}'));
    }
  }

  @override
  Future<Either<Failure, void>> deleteTask(String taskId) async {
    try {
      await firestore
          .collection(FirestoreConstants.tasks)
          .doc(taskId)
          .delete();
      return const Right(null);
    } catch (e) {
      return Left(FirestoreFailure(message: 'خطأ في حذف المهمة: ${e.toString()}'));
    }
  }

  @override
  Future<Either<Failure, void>> updateTaskStatus(String taskId, String status, int percentage) async {
    try {
      await firestore
          .collection(FirestoreConstants.tasks)
          .doc(taskId)
          .update({
        'status': status,
        'completion_percentage': percentage,
        'updated_at': Timestamp.now(),
      });
      return const Right(null);
    } catch (e) {
      return Left(FirestoreFailure(message: 'خطأ في تحديث حالة المهمة: ${e.toString()}'));
    }
  }

  @override
  Stream<List<TaskCommentModel>> getComments(String taskId) {
    return firestore
        .collection(FirestoreConstants.taskComments)
        .where('task_id', isEqualTo: taskId)
        .snapshots()
        .map(
          (snapshot) {
        final comments = snapshot.docs
            .map((doc) => TaskCommentModel.fromMap(doc.data()))
            .toList();
        comments.sort((a, b) => a.createdAt.compareTo(b.createdAt));
        return comments;
      },
    );
  }

  @override
  Future<Either<Failure, void>> addComment(String taskId, TaskCommentModel comment) async {
    try {
      await firestore
          .collection(FirestoreConstants.taskComments)
          .doc(comment.id)
          .set(comment.toMap());
      return const Right(null);
    } catch (e) {
      return Left(FirestoreFailure(message: 'خطأ في إضافة التعليق: ${e.toString()}'));
    }
  }
}
