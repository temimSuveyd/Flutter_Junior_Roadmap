part of 'profile_bloc.dart';

@immutable
sealed class ProfileState {}

final class ProfileInitial extends ProfileState {}

final class ProfileLoading extends ProfileState {}

final class AvatarUploading extends ProfileState {
  final UserProfileData profile;
  AvatarUploading(this.profile);
}

final class ProfileLoaded extends ProfileState {
  final UserProfileData profile;
  ProfileLoaded(this.profile);
}

final class ProfileError extends ProfileState {
  final String message;
  ProfileError(this.message);
}