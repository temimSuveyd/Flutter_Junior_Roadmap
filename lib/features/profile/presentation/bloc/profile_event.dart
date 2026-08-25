part of 'profile_bloc.dart';

@immutable
sealed class ProfileEvent {}

/// Event to load the profile data.
final class ProfileRequested extends ProfileEvent {}

/// Event to change the photo from a source (camera or gallery).
final class AvatarChanged extends ProfileEvent {
  AvatarChanged(this.source);
  final ImageSource source;
}

/// Event to delete the profile photo.
final class AvatarRemoved extends ProfileEvent {}