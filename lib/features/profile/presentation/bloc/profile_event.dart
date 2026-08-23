part of 'profile_bloc.dart';

@immutable
sealed class ProfileEvent {}

/// طلب جلب بيانات الملف الشخصي.
final class ProfileRequested extends ProfileEvent {}

/// طلب تغيير الصورة من مصدر معين (كاميرا أو معرض).
final class AvatarChanged extends ProfileEvent {
  final ImageSource source;
  AvatarChanged(this.source);
}

/// طلب حذف صورة الملف الشخصي.
final class AvatarRemoved extends ProfileEvent {}