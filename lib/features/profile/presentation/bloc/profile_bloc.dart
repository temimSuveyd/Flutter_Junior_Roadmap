import 'package:bloc/bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:juniorflutterroadmap/core/errors/result.dart';
import 'package:juniorflutterroadmap/core/storage/user_profile_data.dart';
import 'package:juniorflutterroadmap/features/profile/data/repositories/profile_repository.dart';
import 'package:meta/meta.dart';

part 'profile_event.dart';
part 'profile_state.dart';

/// Bloc that manages the profile.
class ProfileBloc extends Bloc<ProfileEvent, ProfileState> {
  ProfileBloc(this._profileRepository) : super(ProfileInitial()) {
    on<ProfileRequested>(_onProfileRequested);
    on<AvatarChanged>(_onAvatarChanged);
    on<AvatarRemoved>(_onAvatarRemoved);
  }

  final ProfileRepository _profileRepository;

  /// Loads the profile data.
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

  /// Captures an image from a source and uploads it.
  Future<void> _onAvatarChanged(
    AvatarChanged event,
    Emitter<ProfileState> emit,
  ) async {
    final currentProfile = switch (state) {
      ProfileLoaded(:final profile) => profile,
      AvatarUploading(:final profile) => profile,
      _ => const UserProfileData(),
    };
    emit(AvatarUploading(currentProfile));
    final result = await _profileRepository.updateAvatarFromSource(
      event.source,
    );
    if (isClosed) return;
    switch (result) {
      case Success(:final data):
        emit(ProfileLoaded(data));
      case Error(:final error):
        emit(ProfileError(error.message));
    }
  }

  /// Deletes the profile photo.
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
