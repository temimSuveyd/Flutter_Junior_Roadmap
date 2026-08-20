import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:juniorflutterroadmap/core/errors/result.dart';
import 'package:juniorflutterroadmap/core/storage/user_profile_data.dart';
import 'package:juniorflutterroadmap/features/profile/data/repositories/profile_repository.dart';
import 'package:meta/meta.dart';

part 'profile_event.dart';
part 'profile_state.dart';

class ProfileBloc extends Bloc<ProfileEvent, ProfileState> {
  ProfileBloc(this._profileRepository) : super(ProfileInitial()) {
    on<ProfileRequested>(_onProfileRequested);
    on<AvatarPicked>(_onAvatarPicked);
    on<AvatarRemoved>(_onAvatarRemoved);
  }

  final ProfileRepository _profileRepository;

  Future<void> _onProfileRequested(
    ProfileRequested event,
    Emitter<ProfileState> emit,
  ) async {
    emit(ProfileLoading());
    final result = await _profileRepository.getProfile();
    if (isClosed) return;
    switch (result) {
      case Success(:final data):
        emit(ProfileLoaded(data));
      case Error(:final error):
        emit(ProfileError(error.message));
    }
  }

  Future<void> _onAvatarPicked(
    AvatarPicked event,
    Emitter<ProfileState> emit,
  ) async {
    final currentProfile = switch (state) {
      ProfileLoaded(:final profile) => profile,
      AvatarUploading(:final profile) => profile,
      _ => const UserProfileData(),
    };
    emit(AvatarUploading(currentProfile));
    final result = await _profileRepository.updateAvatar(event.image);
    if (isClosed) return;
    switch (result) {
      case Success(:final data):
        emit(ProfileLoaded(data));
      case Error(:final error):
        emit(ProfileError(error.message));
    }
  }

  Future<void> _onAvatarRemoved(
    AvatarRemoved event,
    Emitter<ProfileState> emit,
  ) async {
    final result = await _profileRepository.removeAvatar();
    if (isClosed) return;
    switch (result) {
      case Success(:final data):
        emit(ProfileLoaded(data));
      case Error(:final error):
        emit(ProfileError(error.message));
    }
  }
}