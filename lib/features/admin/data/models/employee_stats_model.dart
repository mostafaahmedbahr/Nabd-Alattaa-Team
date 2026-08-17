import 'package:equatable/equatable.dart';

class EmployeeStats extends Equatable {
  final String userId;
  final int totalTasks;
  final int completedTasks;
  final int inProgressTasks;
  final int openTasks;
  final int totalComplaints;
  final int totalIdeas;
  final int points;
  final bool isActive;

  const EmployeeStats({
    required this.userId,
    this.totalTasks = 0,
    this.completedTasks = 0,
    this.inProgressTasks = 0,
    this.openTasks = 0,
    this.totalComplaints = 0,
    this.totalIdeas = 0,
    this.points = 0,
    this.isActive = true,
  });

  EmployeeStats copyWith({
    String? userId,
    int? totalTasks,
    int? completedTasks,
    int? inProgressTasks,
    int? openTasks,
    int? totalComplaints,
    int? totalIdeas,
    int? points,
    bool? isActive,
  }) {
    return EmployeeStats(
      userId: userId ?? this.userId,
      totalTasks: totalTasks ?? this.totalTasks,
      completedTasks: completedTasks ?? this.completedTasks,
      inProgressTasks: inProgressTasks ?? this.inProgressTasks,
      openTasks: openTasks ?? this.openTasks,
      totalComplaints: totalComplaints ?? this.totalComplaints,
      totalIdeas: totalIdeas ?? this.totalIdeas,
      points: points ?? this.points,
      isActive: isActive ?? this.isActive,
    );
  }

  @override
  List<Object?> get props => [
        userId,
        totalTasks,
        completedTasks,
        inProgressTasks,
        openTasks,
        totalComplaints,
        totalIdeas,
        points,
        isActive,
      ];
}
