import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../core/common/helpers/helpers.dart';
import '../../../../core/di/injection.dart';
import '../../../../core/storage/auth_token_manager.dart';
import '../../../../core/storage/user_profile_data.dart';
import '../../../../core/utils/app_primary_button.dart';
import '../../../../core/utils/error_state.dart';
import '../../../../core/utils/loading_state.dart';
import '../bloc/profile_bloc.dart';
import '../widgets/profile_avatar.dart';

/// Image-source options shown in the bottom sheet.
enum _AvatarAction { camera, gallery, remove }

/// Profile page.
class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  @override
  void initState() {
    super.initState();
    context.read<ProfileBloc>().add(ProfileRequested());
  }

  /// Shows the source picker sheet then emits the corresponding event.
  Future<void> _onChangePhoto() async {
    final action = await _showImageSourceSheet();
    if (action == null || !mounted) return;

    switch (action) {
      case _AvatarAction.camera:
        context.read<ProfileBloc>().add(AvatarChanged(ImageSource.camera));
      case _AvatarAction.gallery:
        context.read<ProfileBloc>().add(AvatarChanged(ImageSource.gallery));
      case _AvatarAction.remove:
        await _onRemovePhoto();
    }
  }

  /// Shows a confirmation dialog before deleting the photo.
  Future<void> _onRemovePhoto() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(context.l10n.t.removePhoto),
        content: Text(context.l10n.t.removePhotoConfirm),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text(context.l10n.t.cancel),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: Text(context.l10n.t.remove),
          ),
        ],
      ),
    );
    if (confirmed == true && mounted) {
      context.read<ProfileBloc>().add(AvatarRemoved());
    }
  }

  /// Clears all local storage and navigates back to the sign-in screen.
  Future<void> _onLogout() async {
    await getIt<AuthTokenManager>().clearTokens();
    await getIt<SharedPreferences>().clear();
    if (Hive.isBoxOpen('products_cache')) {
      await Hive.box('products_cache').clear();
    }
    if (mounted) context.go(AppRoutes.signIn);
  }

  /// Bottom sheet to pick the image source (camera / gallery / remove).
  Future<_AvatarAction?> _showImageSourceSheet() async {
    return showModalBottomSheet<_AvatarAction>(
      context: context,
      builder: (context) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.photo_camera_outlined),
              title: Text(context.l10n.t.camera),
              onTap: () => Navigator.pop(context, _AvatarAction.camera),
            ),
            ListTile(
              leading: const Icon(Icons.photo_library_outlined),
              title: Text(context.l10n.t.gallery),
              onTap: () => Navigator.pop(context, _AvatarAction.gallery),
            ),
            if (_hasAvatar)
              ListTile(
                leading: const Icon(Icons.delete_outline),
                title: Text(context.l10n.t.removePhoto),
                onTap: () => Navigator.pop(context, _AvatarAction.remove),
              ),
          ],
        ),
      ),
    );
  }

  /// Checks whether the user already has a profile photo.
  bool get _hasAvatar {
    final state = context.read<ProfileBloc>().state;
    return switch (state) {
      ProfileLoaded(:final profile) => profile.avatarUrl != null,
      AvatarUploading(:final profile) => profile.avatarUrl != null,
      _ => false,
    };
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ProfileBloc, ProfileState>(
      listener: (context, state) {
        if (state is ProfileError) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text(state.message)));
        }
      },
      builder: (context, state) {
        return switch (state) {
          ProfileInitial() || ProfileLoading() => LoadingState(
            message: context.l10n.t.loadingProfile,
          ),
          ProfileError(:final message) => ErrorState(
            message: message,
            onRetry: () => context.read<ProfileBloc>().add(ProfileRequested()),
          ),
          AvatarUploading(:final profile) => _ProfileContent(
            profile: profile,
            isUploading: true,
            onChangePhoto: _onChangePhoto,
            onLogout: _onLogout,
          ),
          ProfileLoaded(:final profile) => _ProfileContent(
            profile: profile,
            onChangePhoto: _onChangePhoto,
            onLogout: _onLogout,
          ),
        };
      },
    );
  }
}

/// Page content shown once data loads successfully.
class _ProfileContent extends StatelessWidget {
  const _ProfileContent({
    required this.profile,
    this.isUploading = false,
    required this.onChangePhoto,
    required this.onLogout,
  });

  final UserProfileData profile;
  final bool isUploading;
  final VoidCallback onChangePhoto;
  final VoidCallback onLogout;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: context.spacing.insetXl,
        child: Column(
          children: [
            const Spacer(),
            ProfileAvatar(
              profile: profile,
              isUploading: isUploading,
              onTap: onChangePhoto,
            ),
            context.spacing.vGapXl,
            Text(
              profile.name?.isNotEmpty == true
                  ? profile.name!
                  : context.l10n.t.anonymousUser,
              style: context.textTheme.titleLarge,
            ),
            context.spacing.vGapSm,
            Text(
              profile.email?.isNotEmpty == true ? profile.email! : '',
              style: context.textTheme.bodyMedium!.copyWith(
                color: context.colors.textSecondary,
              ),
            ),
            context.spacing.vGapLg,
            SizedBox(
              height: 45,
              child: AppPrimaryButton(
                label: context.l10n.t.logout,
                onPressed: onLogout,
              ),
            ),
            const Spacer(),
          ],
        ),
      ),
    );
  }
}
