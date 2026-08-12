import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../data/models/announcement_model.dart';
import '../../data/repos/announcement_repo.dart';
import 'announcement_state.dart';

class AnnouncementCubit extends Cubit<AnnouncementState> {
  final AnnouncementRepository _announcementRepository;
  StreamSubscription? _announcementsSubscription;

  AnnouncementCubit({
    required AnnouncementRepository announcementRepository,
  }) : _announcementRepository = announcementRepository,
       super(const AnnouncementInitial());

  final formKey = GlobalKey<FormState>();
  final titleController = TextEditingController();
  final contentController = TextEditingController();
  String selectedType = 'news';

  void loadAnnouncements() {
    _announcementsSubscription?.cancel();
    emit(const AnnouncementLoading());
    _announcementsSubscription = _announcementRepository
        .getAnnouncements()
        .listen(
      (result) {
        result.fold(
          (failure) => emit(AnnouncementError(message: failure.message)),
          (announcements) => emit(AnnouncementLoaded(announcements: announcements)),
        );
      },
      onError: (error) =>
          emit(AnnouncementError(message: 'فشل في تحميل الإعلانات')),
    );
  }

  Future<void> createAnnouncement() async {
    emit(const AnnouncementCreating());

    final announcement = AnnouncementModel(
      id: '',
      title: titleController.text.trim(),
      content: contentController.text.trim(),
      type: selectedType,
      createdAt: DateTime.now(),
    );

    final result = await _announcementRepository.createAnnouncement(announcement);

    result.fold(
      (failure) => emit(AnnouncementError(message: failure.message)),
      (_) => emit(const AnnouncementCreated()),
    );
  }

  void clearForm() {
    titleController.clear();
    contentController.clear();
    selectedType = 'news';
  }

  @override
  Future<void> close() {
    _announcementsSubscription?.cancel();
    titleController.dispose();
    contentController.dispose();
    return super.close();
  }
}