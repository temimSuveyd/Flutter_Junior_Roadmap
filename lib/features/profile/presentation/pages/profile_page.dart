import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:juniorflutterroadmap/core/common/helpers/helpers.dart';
import 'package:juniorflutterroadmap/core/common/widgets/error_state.dart';
import 'package:juniorflutterroadmap/core/common/widgets/loading_state.dart';
import 'package:juniorflutterroadmap/core/storage/user_profile_data.dart';
import 'package:juniorflutterroadmap/features/profile/presentation/bloc/profile_bloc.dart';
import 'package:juniorflutterroadmap/features/profile/presentation/widgets/profile_avatar.dart';
import 'package:permission_handler/permission_handler.dart';

enum _AvatarAction { camera, gallery, remove }

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final ImagePicker _picker = ImagePicker();

  @override
  void initState() {
    super.initState();
    context.read<ProfileBloc>().add(ProfileRequested());
  }

  Future<void> _onChangePhoto() async {
    final action = await _showImageSourceSheet();
    if (action == null || !mounted) return;

    switch (action) {
      case _AvatarAction.camera:
        await _pickImage(ImageSource.camera);
      case _AvatarAction.gallery:
        await _pickImage(ImageSource.gallery);
      case _AvatarAction.remove:
        await _onRemovePhoto();
    }
  }

  Future<void> _pickImage(ImageSource source) async {
    final granted = await _ensurePermission(source);
    if (!granted) {
      _showMessage('Permission denied. Enable it in device settings.');
      return;
    }

    final picked = await _picker.pickImage(
      source: source,
      maxWidth: 1024,
      maxHeight: 1024,
      imageQuality: 85,
    );
    if (picked == null || !mounted) return;

    context.read<ProfileBloc>().add(AvatarPicked(File(picked.path)));
  }

  Future<bool> _ensurePermission(ImageSource source) async {
    if (source == ImageSource.camera) {
      return (await Permission.camera.request()).isGranted;
    }
    if (Platform.isIOS) {
      return (await Permission.photos.request()).isGranted;
    }
    return true;
  }

  Future<void> _onRemovePhoto() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Remove photo'),
        content: const Text('Are you sure you want to remove your profile photo?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Remove'),
          ),
        ],
      ),
    );
    if (confirmed == true && mounted) {
      context.read<ProfileBloc>().add(AvatarRemoved());
    }
  }

  Future<_AvatarAction?> _showImageSourceSheet() async {
    return showModalBottomSheet<_AvatarAction>(
      context: context,
      builder: (context) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.photo_camera_outlined),
              title: const Text('Camera'),
              onTap: () => Navigator.pop(context, _AvatarAction.camera),
            ),
            ListTile(
              leading: const Icon(Icons.photo_library_outlined),
              title: const Text('Gallery'),
              onTap: () => Navigator.pop(context, _AvatarAction.gallery),
            ),
            if (_hasAvatar)
              ListTile(
                leading: const Icon(Icons.delete_outline),
                title: const Text('Remove photo'),
                onTap: () => Navigator.pop(context, _AvatarAction.remove),
              ),
          ],
        ),
      ),
    );
  }

  bool get _hasAvatar {
    final state = context.read<ProfileBloc>().state;
    return switch (state) {
      ProfileLoaded(:final profile) => profile.avatarUrl != null,
      AvatarUploading(:final profile) => profile.avatarUrl != null,
      _ => false,
    };
  }

  void _showMessage(String message) {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(message)));
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ProfileBloc, ProfileState>(
      listener: (context, state) {
        if (state is ProfileError) {
          _showMessage(state.message);
        }
      },
      builder: (context, state) {
        return switch (state) {
          ProfileInitial() || ProfileLoading() =>
            const LoadingState(message: 'Loading profile...'),
          ProfileError(:final message) => ErrorState(
            message: message,
            onRetry: () => context.read<ProfileBloc>().add(ProfileRequested()),
          ),
          AvatarUploading(:final profile) =>
            _ProfileContent(profile: profile, isUploading: true, onChangePhoto: _onChangePhoto),
          ProfileLoaded(:final profile) =>
            _ProfileContent(profile: profile, onChangePhoto: _onChangePhoto),
        };
      },
    );
  }
}

class _ProfileContent extends StatelessWidget {
  const _ProfileContent({
    required this.profile,
    this.isUploading = false,
    required this.onChangePhoto,
  });

  final UserProfileData profile;
  final bool isUploading;
  final VoidCallback onChangePhoto;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: context.insetXl,
        child: Column(
          children: [
            const Spacer(),
            ProfileAvatar(
              profile: profile,
              isUploading: isUploading,
              onTap: onChangePhoto,
            ),
            context.vGapXl,
            Text(
              profile.name?.isNotEmpty == true ? profile.name! : 'Anonymous User',
              style: context.titleLarge,
            ),
            context.vGapSm,
            Text(
              profile.email?.isNotEmpty == true ? profile.email! : '',
              style: context.bodyMedium.copyWith(color: context.textSecondary),
            ),
            context.vGapLg,
            TextButton.icon(
              onPressed: onChangePhoto,
              icon: const Icon(Icons.edit_outlined, size: 18),
              label: const Text('Change photo'),
            ),
            const Spacer(),
          ],
        ),
      ),
    );
  }
}