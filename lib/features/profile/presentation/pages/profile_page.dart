import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';

import '../../../../core/common/helpers/helpers.dart';
import '../../../../core/storage/user_profile_data.dart';
import '../../../../core/utils/error_state.dart';
import '../../../../core/utils/loading_state.dart';
import '../bloc/profile_bloc.dart';
import '../widgets/profile_avatar.dart';

/// خيارات اختيار مصدر الصورة في ورقة السحب.
enum _AvatarAction { camera, gallery, remove }

/// صفحة الملف الشخصي.
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

  /// عرض ورقة اختيار المصدر ثم إرسال الحدث المناسب.
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

  /// عرض حوار التأكيد قبل حذف الصورة.
  Future<void> _onRemovePhoto() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(context.t.removePhoto),
        content: Text(context.t.removePhotoConfirm),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text(context.t.cancel),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: Text(context.t.remove),
          ),
        ],
      ),
    );
    if (confirmed == true && mounted) {
      context.read<ProfileBloc>().add(AvatarRemoved());
    }
  }

  /// ورقة سحب لاختيار مصدر الصورة (كاميرا / معرض / حذف).
  Future<_AvatarAction?> _showImageSourceSheet() async {
    return showModalBottomSheet<_AvatarAction>(
      context: context,
      builder: (context) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.photo_camera_outlined),
              title: Text(context.t.camera),
              onTap: () => Navigator.pop(context, _AvatarAction.camera),
            ),
            ListTile(
              leading: const Icon(Icons.photo_library_outlined),
              title: Text(context.t.gallery),
              onTap: () => Navigator.pop(context, _AvatarAction.gallery),
            ),
            if (_hasAvatar)
              ListTile(
                leading: const Icon(Icons.delete_outline),
                title: Text(context.t.removePhoto),
                onTap: () => Navigator.pop(context, _AvatarAction.remove),
              ),
          ],
        ),
      ),
    );
  }

  /// التحقق مما إذا كان لدى المستخدم صورة حالية.
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
          ScaffoldMessenger.of(context)
              .showSnackBar(SnackBar(content: Text(state.message)));
        }
      },
      builder: (context, state) {
        return switch (state) {
          ProfileInitial() || ProfileLoading() =>
            LoadingState(message: context.t.loadingProfile),
          ProfileError(:final message) => ErrorState(
            message: message,
            onRetry: () => context.read<ProfileBloc>().add(ProfileRequested()),
          ),
          AvatarUploading(:final profile) => _ProfileContent(
            profile: profile,
            isUploading: true,
            onChangePhoto: _onChangePhoto,
          ),
          ProfileLoaded(:final profile) =>
            _ProfileContent(profile: profile, onChangePhoto: _onChangePhoto),
        };
      },
    );
  }
}

/// محتوى الصفحة عند تحميل البيانات بنجاح.
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
              profile.name?.isNotEmpty == true ? profile.name! : context.t.anonymousUser,
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
              label: Text(context.t.changePhoto),
            ),
            const Spacer(),
          ],
        ),
      ),
    );
  }
}