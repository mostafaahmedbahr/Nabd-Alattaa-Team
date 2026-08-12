import 'package:equatable/equatable.dart';

import '../../data/models/announcement_model.dart';

abstract class AnnouncementState extends Equatable {
  const AnnouncementState();

  @override
  List<Object?> get props => [];
}

class AnnouncementInitial extends AnnouncementState {
  const AnnouncementInitial();
}

class AnnouncementLoading extends AnnouncementState {
  const AnnouncementLoading();
}

class AnnouncementLoaded extends AnnouncementState {
  final List<AnnouncementModel> announcements;

  const AnnouncementLoaded({required this.announcements});

  @override
  List<Object?> get props => [announcements];
}

class AnnouncementError extends AnnouncementState {
  final String message;

  const AnnouncementError({required this.message});

  @override
  List<Object?> get props => [message];
}

class AnnouncementCreating extends AnnouncementState {
  const AnnouncementCreating();
}

class AnnouncementCreated extends AnnouncementState {
  const AnnouncementCreated();
}