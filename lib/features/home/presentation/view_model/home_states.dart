abstract class HomeStates {}

class HomeInitial extends HomeStates {}
class HomeLoading extends HomeStates {}
class HomeLoaded extends HomeStates {
  final String userName;
  final String greeting;
  final List<Map<String, dynamic>> announcements;
  final List<Map<String, dynamic>> tasks;

  HomeLoaded({
    required this.userName,
    required this.greeting,
    required this.announcements,
    required this.tasks,
});
}
class HomeError extends HomeStates {
  final String message;
  HomeError({required this.message});
}
