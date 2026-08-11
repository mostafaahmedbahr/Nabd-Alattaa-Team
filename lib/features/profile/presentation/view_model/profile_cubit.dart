import 'package:flutter_bloc/flutter_bloc.dart';

import '../../data/repos/profile_repo.dart';
import 'profile_state.dart';

class ProfileCubit extends Cubit<ProfileState> {
  final ProfileRepository _profileRepo;

  ProfileCubit(this._profileRepo) : super(const ProfileInitial());

  Future<void> loadProfile(String userId) async {
    if (state is ProfileLoaded) return;
    emit(const ProfileLoading());
    final result = await _profileRepo.getProfile(userId);
    result.fold(
      (failure) => emit(ProfileError(message: failure.message)),
      (profile) => emit(ProfileLoaded(profile: profile)),
    );
  }

  void reset() {
    emit(const ProfileInitial());
  }

  Future<void> refreshProfile(String userId) async {
    emit(const ProfileLoading());
    final result = await _profileRepo.getProfile(userId);
    result.fold(
      (failure) => emit(ProfileError(message: failure.message)),
      (profile) => emit(ProfileLoaded(profile: profile)),
    );
  }

  Future<void> updateProfile(
      String userId, Map<String, dynamic> data) async {
    final currentState = state;
    if (currentState is ProfileLoaded) {
      emit(ProfileUpdating(profile: currentState.profile));
    }

    final result = await _profileRepo.updateProfile(userId, data);
    result.fold(
      (failure) {
        if (currentState is ProfileLoaded) {
          emit(ProfileLoaded(profile: currentState.profile));
        } else {
          emit(ProfileError(message: failure.message));
        }
      },
      (_) => emit(const ProfileUpdated()),
    );
  }


}
