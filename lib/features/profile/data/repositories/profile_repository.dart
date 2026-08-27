import 'dart:io';

import 'package:image_picker/image_picker.dart';
import 'package:juniorflutterroadmap/core/errors/result.dart';
import 'package:juniorflutterroadmap/core/services/network/failure.dart';
import 'package:juniorflutterroadmap/core/storage/user_profile_data.dart';
import 'package:juniorflutterroadmap/core/storage/user_profile_store.dart';
import '../../../../core/services/device_features/image_picker_service.dart';
import '../services/profile_service.dart';

/// Profile repository interface.
abstract class ProfileRepository {
  /// Loads the locally stored profile data.
  Future<Result<UserProfileData>> getProfile();

  /// Captures an image from a source, uploads it, and saves the URL.
  Future<Result<UserProfileData>> updateAvatarFromSource(ImageSource source);

  /// Deletes the profile photo.
  Future<Result<UserProfileData>> removeAvatar();
}

class ProfileRepositoryImpl extends ProfileRepository {
  ProfileRepositoryImpl(
    this._profileService,
    this._userProfileStore,
    this._imagePickerService,
  );

  final ProfileService _profileService;
  final UserProfileStore _userProfileStore;
  final ImagePickerService _imagePickerService;

  @override
  Future<Result<UserProfileData>> getProfile() {
    return runCatching(() async {
      return await _userProfileStore.read() ?? const UserProfileData();
    });
  }

  @override
  Future<Result<UserProfileData>> updateAvatarFromSource(ImageSource source) {
    return runCatching(() async {
      final File? image;
      if (source == ImageSource.camera) {
        image = await _imagePickerService.pickImageFromCamera();
      } else {
        image = await _imagePickerService.pickImageFromGallery();
      }
      if (image == null) {
        final current =
            await _userProfileStore.read() ?? const UserProfileData();
        return current;
      }

      final String avatarUrl;
      try {
        avatarUrl = await _profileService.uploadAvatar(image);
      } on Failure catch (failure) {
        throw Failure(
          'Profile photo could not be uploaded: ${failure.message}',
        );
      } catch (e) {
        throw Failure(
          'Profile photo could not be uploaded. Please check your '
          'internet connection and try again.',
        );
      }

      final userId = await _requireUserId();
      await _profileService.updateAvatar(userId: userId, avatarUrl: avatarUrl);

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
      final userId = await _requireUserId();
      await _profileService.removeAvatar(userId: userId);

      final current =
          await _userProfileStore.read() ?? const UserProfileData();
      final updated = current.copyWith(clearAvatarUrl: true);
      await _userProfileStore.save(updated);
      return updated;
    });
  }

  Future<int> _requireUserId() async {
    final id = (await _userProfileStore.read())?.id;
    if (id == null) {
      throw Failure('User identifier not found.');
    }
    final parsed = int.tryParse(id);
    if (parsed == null) {
      throw Failure('Invalid user identifier.');
    }
    return parsed;
  }
}