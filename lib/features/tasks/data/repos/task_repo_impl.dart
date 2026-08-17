import 'package:dartz/dartz.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:uuid/uuid.dart';

import '../../../../core/constants/firestore_constants.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/utils/enums.dart';
import 'task_repo.dart';
import '../models/task_model.dart';
import '../models/task_comment_model.dart';
import '../models/task_subtask_model.dart';

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

  String _statusFromPercentage(int percentage) {
    if (percentage >= 100) return 'مكتملة';
    if (percentage <= 0) return 'لم تبدأ';
    return 'جاري التنفيذ';
  }

  Future<Either<Failure, void>> _writeSubtasks(
    String taskId,
    List<TaskSubtask> subtasks,
    TaskModel task, {
    bool forceClear = false,
  }) async {
    try {
      final total = subtasks.length;
      final done = subtasks.where((s) => s.isCompleted).length;
      final percentage = total == 0
          ? task.completionPercentage
          : ((done / total) * 100).round();

      final data = <String, dynamic>{
        FirestoreConstants.taskSubtasks: subtasks.map((s) => s.toMap()).toList(),
        FirestoreConstants.taskCompletionPercentage: percentage,
        FirestoreConstants.taskUpdatedAt: Timestamp.now(),
      };

      if (total > 0 && !forceClear) {
        data[FirestoreConstants.taskStatus] = _statusFromPercentage(percentage);
      }

      await firestore
          .collection(FirestoreConstants.tasks)
          .doc(taskId)
          .update(data);
      return const Right(null);
    } catch (e) {
      return Left(FirestoreFailure(message: 'خطأ في تحديث المهام الفرعية: ${e.toString()}'));
    }
  }

  @override
  Future<Either<Failure, void>> addSubtask(String taskId, TaskSubtask subtask) async {
    try {
      final doc = await firestore
          .collection(FirestoreConstants.tasks)
          .doc(taskId)
          .get();
      if (!doc.exists) {
        return const Left(FirestoreFailure(message: 'المهمة غير موجودة'));
      }
      final task = TaskModel.fromMap(doc.data()!);
      final updated = [
        ...task.subtasks,
        subtask.copyWith(order: task.subtasks.length),
      ];
      return _writeSubtasks(taskId, updated, task);
    } catch (e) {
      return Left(FirestoreFailure(message: 'خطأ في إضافة المهمة الفرعية: ${e.toString()}'));
    }
  }

  @override
  Future<Either<Failure, void>> updateSubtask(String taskId, TaskSubtask subtask) async {
    try {
      final doc = await firestore
          .collection(FirestoreConstants.tasks)
          .doc(taskId)
          .get();
      if (!doc.exists) {
        return const Left(FirestoreFailure(message: 'المهمة غير موجودة'));
      }
      final task = TaskModel.fromMap(doc.data()!);
      final updated = task.subtasks
          .map((s) => s.id == subtask.id ? subtask : s)
          .toList();
      return _writeSubtasks(taskId, updated, task);
    } catch (e) {
      return Left(FirestoreFailure(message: 'خطأ في تحديث المهمة الفرعية: ${e.toString()}'));
    }
  }

  @override
  Future<Either<Failure, void>> deleteSubtask(String taskId, String subtaskId) async {
    try {
      final doc = await firestore
          .collection(FirestoreConstants.tasks)
          .doc(taskId)
          .get();
      if (!doc.exists) {
        return const Left(FirestoreFailure(message: 'المهمة غير موجودة'));
      }
      final task = TaskModel.fromMap(doc.data()!);
      final updated = task.subtasks
          .where((s) => s.id != subtaskId)
          .toList();
      return _writeSubtasks(taskId, updated, task);
    } catch (e) {
      return Left(FirestoreFailure(message: 'خطأ في حذف المهمة الفرعية: ${e.toString()}'));
    }
  }

  @override
  Future<Either<Failure, void>> toggleSubtask({
    required String taskId,
    required String subtaskId,
    required bool isCompleted,
    required String userId,
  }) async {
    try {
      final doc = await firestore
          .collection(FirestoreConstants.tasks)
          .doc(taskId)
          .get();
      if (!doc.exists) {
        return const Left(FirestoreFailure(message: 'المهمة غير موجودة'));
      }
      final task = TaskModel.fromMap(doc.data()!);
      final updated = task.subtasks.map((s) {
        if (s.id != subtaskId) return s;
        return s.copyWith(
          isCompleted: isCompleted,
          completedAt: isCompleted ? DateTime.now() : null,
          completedBy: isCompleted ? userId : null,
        );
      }).toList();
      return _writeSubtasks(taskId, updated, task);
    } catch (e) {
      return Left(FirestoreFailure(message: 'خطأ في تحديث المهمة الفرعية: ${e.toString()}'));
    }
  }

  @override
  Future<Either<Failure, String>> forwardTask({
    required TaskModel originalTask,
    required String fromUserId,
    required String fromUserName,
    required String toUserId,
    required String toUserName,
    String? note,
  }) async {
    try {
      final originalDoc = await firestore
          .collection(FirestoreConstants.tasks)
          .doc(originalTask.id)
          .get();

      final sourceMap = originalDoc.exists ? originalDoc.data()! : originalTask.toMap();
      final sourceTask = TaskModel.fromMap(sourceMap);

      final newId = const Uuid().v4();

      final rootOriginalId =
          (sourceTask.originalTaskId != null && sourceTask.originalTaskId!.isNotEmpty)
              ? sourceTask.originalTaskId!
              : sourceTask.id;

      final copiedSubtasks = sourceTask.subtasks
          .map((s) => s.copyWith(
                isCompleted: false,
                completedAt: null,
                completedBy: null,
              ))
          .toList();

      final newTask = sourceTask.copyWith(
        id: newId,
        creatorId: fromUserId,
        creatorName: fromUserName,
        assigneeId: toUserId,
        assigneeName: toUserName,
        isForwarded: true,
        originalTaskId: rootOriginalId,
        parentTaskId: sourceTask.id,
        forwardedFromUserId: fromUserId,
        forwardedFromUserName: fromUserName,
        forwardedToUserId: toUserId,
        forwardedAt: DateTime.now(),
        forwardNote: note,
        status: 'لم تبدأ',
        completionPercentage: 0,
        subtasks: copiedSubtasks,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );

      final batch = firestore.batch();

      batch.set(
        firestore.collection(FirestoreConstants.tasks).doc(newId),
        newTask.toMap(),
      );

      batch.set(
        firestore.collection(FirestoreConstants.notifications).doc(),
        {
          FirestoreConstants.userId: toUserId,
          FirestoreConstants.notificationTitle: 'مهمة موجهة',
          FirestoreConstants.notificationBody: 'تم توجيه مهمة إليك: ${newTask.title}',
          FirestoreConstants.notificationType: 'new_task',
          FirestoreConstants.notificationReferenceId: newId,
          FirestoreConstants.notificationIsRead: false,
          FirestoreConstants.notificationCreatedAt: Timestamp.now(),
        },
      );

      await batch.commit();

      return Right(newId);
    } catch (e) {
      return Left(FirestoreFailure(message: 'خطأ في توجيه المهمة: ${e.toString()}'));
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
