part of 'profile_bloc.dart';

@immutable
sealed class ProfileEvent {}

final class ProfileRequested extends ProfileEvent {}

final class AvatarPicked extends ProfileEvent {
  final File image;
  AvatarPicked(this.image);
}

final class AvatarRemoved extends ProfileEvent {}