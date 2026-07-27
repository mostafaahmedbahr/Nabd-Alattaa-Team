import 'package:dartz/dartz.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../../../../core/constants/firestore_constants.dart';
import '../../../../core/error/failures.dart';
import '../repos/task_repo.dart';
import '../models/task_model.dart';
import '../models/task_comment_model.dart';

class TaskRepoImpl implements TaskRepository {
  final FirebaseFirestore firestore;

  TaskRepoImpl({required this.firestore});

  @override
  Stream<List<TaskModel>> getTasks({String? assigneeId, String? status}) {
    Query query = firestore.collection(FirestoreConstants.tasks);

    if (assigneeId != null) {
      query = query.where('assignee_id', isEqualTo: assigneeId);
    }
    if (status != null) {
      query = query.where('status', isEqualTo: status);
    }

    return query.orderBy('created_at', descending: true).snapshots().map(
          (snapshot) => snapshot.docs
              .map((doc) => TaskModel.fromMap(doc.data() as Map<String, dynamic>))
              .toList(),
        );
  }

  @override
  Future<Either<Failure, void>> createTask(TaskModel task) async {
    try {
      await firestore
          .collection(FirestoreConstants.tasks)
          .doc(task.id)
          .set(task.toMap());
      return const Right(null);
    } catch (e) {
      return Left(FirestoreFailure(message: 'خطأ في إنشاء المهمة: ${e.toString()}'));
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
        .orderBy('created_at', descending: false)
        .snapshots()
        .map(
          (snapshot) => snapshot.docs
              .map((doc) => TaskCommentModel.fromMap(doc.data()))
              .toList(),
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
