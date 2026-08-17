import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';

class HomeData extends Equatable {
  final String userName;
  final List<Map<String, dynamic>> announcements;
  final List<Map<String, dynamic>> tasks;
  final int totalTasksCount;

  const HomeData({
    required this.userName,
    required this.announcements,
    required this.tasks,
    required this.totalTasksCount,
  });

  HomeData copyWith({
    String? userName,
    List<Map<String, dynamic>>? announcements,
    List<Map<String, dynamic>>? tasks,
    int? totalTasksCount,
  }) {
    return HomeData(
      userName: userName ?? this.userName,
      announcements: announcements ?? this.announcements,
      tasks: tasks ?? this.tasks,
      totalTasksCount: totalTasksCount ?? this.totalTasksCount,
    );
  }

  @override
  List<Object?> get props => [userName, announcements, tasks, totalTasksCount];
}
