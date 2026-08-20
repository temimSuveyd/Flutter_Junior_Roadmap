import 'dart:io';

import 'package:juniorflutterroadmap/core/errors/result.dart';
import 'package:juniorflutterroadmap/core/storage/user_profile_data.dart';
import 'package:juniorflutterroadmap/core/storage/user_profile_store.dart';
import '../services/profile_service.dart';

abstract class ProfileRepository {
  Future<Result<UserProfileData>> getProfile();
  Future<Result<UserProfileData>> updateAvatar(File image);
  Future<Result<UserProfileData>> removeAvatar();
}

class ProfileRepositoryImpl extends ProfileRepository {
  ProfileRepositoryImpl(this._profileService, this._userProfileStore);

  final ProfileService _profileService;
  final UserProfileStore _userProfileStore;

  @override
  Future<Result<UserProfileData>> getProfile() {
    return runCatching(() async {
      return await _userProfileStore.read() ?? const UserProfileData();
    });
  }

  @override
  Future<Result<UserProfileData>> updateAvatar(File image) {
    return runCatching(() async {
      final avatarUrl = await _profileService.uploadAvatar(image);
      final current =
          await _userProfileStore.read() ?? const UserProfileData();
      final updated = current.copyWith(avatarUrl: avatarUrl);
      await _userProfileStore.save(updated);
      return updated;
    });
  }

  @override
  Future<Result<UserProfileData>> removeAvatar() {
    return runCatching(() async {
      final current =
          await _userProfileStore.read() ?? const UserProfileData();
      final updated = current.copyWith(clearAvatarUrl: true);
      await _userProfileStore.save(updated);
      return updated;
    });
  }
}