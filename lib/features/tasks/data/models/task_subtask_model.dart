import 'package:equatable/equatable.dart';

import '../../../../core/constants/firestore_constants.dart';

class TaskSubtask extends Equatable {
  final String id;
  final String title;
  final bool isCompleted;
  final DateTime? completedAt;
  final String? completedBy;
  final int order;

  const TaskSubtask({
    required this.id,
    required this.title,
    this.isCompleted = false,
    this.completedAt,
    this.completedBy,
    this.order = 0,
  });

  factory TaskSubtask.fromMap(Map<String, dynamic> map) {
    return TaskSubtask(
      id: map[FirestoreConstants.taskSubtaskId] ?? '',
      title: map[FirestoreConstants.taskSubtaskTitle] ?? '',
      isCompleted: map[FirestoreConstants.taskSubtaskIsCompleted] ?? false,
      completedAt: map[FirestoreConstants.taskSubtaskCompletedAt]?.toDate(),
      completedBy: map[FirestoreConstants.taskSubtaskCompletedBy],
      order: map[FirestoreConstants.taskSubtaskOrder] ?? 0,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      FirestoreConstants.taskSubtaskId: id,
      FirestoreConstants.taskSubtaskTitle: title,
      FirestoreConstants.taskSubtaskIsCompleted: isCompleted,
      FirestoreConstants.taskSubtaskCompletedAt: completedAt,
      FirestoreConstants.taskSubtaskCompletedBy: completedBy,
      FirestoreConstants.taskSubtaskOrder: order,
    };
  }

  TaskSubtask copyWith({
    String? id,
    String? title,
    bool? isCompleted,
    DateTime? completedAt,
    String? completedBy,
    int? order,
  }) {
    return TaskSubtask(
      id: id ?? this.id,
      title: title ?? this.title,
      isCompleted: isCompleted ?? this.isCompleted,
      completedAt: completedAt ?? this.completedAt,
      completedBy: completedBy ?? this.completedBy,
      order: order ?? this.order,
    );
  }

  @override
  List<Object?> get props => [id, title, isCompleted, completedAt, completedBy, order];
}
