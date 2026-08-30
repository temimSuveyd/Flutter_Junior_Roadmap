part of 'profile_bloc.dart';

@immutable
sealed class ProfileState {}

final class ProfileInitial extends ProfileState {}

final class ProfileLoading extends ProfileState {}

final class AvatarUploading extends ProfileState {
  AvatarUploading(this.profile);
  final UserProfileData profile;
}

final class ProfileLoaded extends ProfileState {
  ProfileLoaded(this.profile);
  final UserProfileData profile;
}

final class ProfileError extends ProfileState {
  ProfileError(this.message);
  final String message;
}
