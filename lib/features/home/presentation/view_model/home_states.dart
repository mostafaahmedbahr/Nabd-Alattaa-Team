abstract class HomeStates {}

class HomeInitial extends HomeStates {}
class HomeLoading extends HomeStates {}
class HomeLoaded extends HomeStates {
  final String userName;
  final String greeting;
  final List<Map<String, dynamic>> announcements;
  final List<Map<String, dynamic>> tasks;
  final int totalTasksCount;
  final int goodDeedsCount;
  final int complaintsCount;
  final int reportsCount;
  final int ideasCount;

  HomeLoaded({
    required this.userName,
    required this.greeting,
    required this.announcements,
    required this.tasks,
    this.totalTasksCount = 0,
    this.goodDeedsCount = 0,
    this.complaintsCount = 0,
    this.reportsCount = 0,
    this.ideasCount = 0,
  });
}
class HomeError extends HomeStates {
  final String message;
  HomeError({required this.message});
}
