abstract class AnnouncementState {}

class AnnouncementInitial extends AnnouncementState {}
class AnnouncementLoading extends AnnouncementState {}
class AnnouncementLoaded extends AnnouncementState {
  final List<Map<String, dynamic>> announcements;
  AnnouncementLoaded({required this.announcements});
}
class AnnouncementError extends AnnouncementState {
  final String message;
  AnnouncementError({required this.message});
}
class AnnouncementCreated extends AnnouncementState {}
