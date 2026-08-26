import 'package:flutter/material.dart';
import 'package:iconsax_plus/iconsax_plus.dart';
import 'package:juniorflutterroadmap/core/common/helpers/helpers.dart';
import 'package:juniorflutterroadmap/core/storage/user_profile_data.dart';
import 'package:juniorflutterroadmap/core/utils/app_network_image.dart';

class ProfileAvatar extends StatelessWidget {
  const ProfileAvatar({
    super.key,
    required this.profile,
    this.isUploading = false,
    this.onTap,
  });

  final UserProfileData profile;
  final bool isUploading;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final avatarUrl = profile.avatarUrl;
    return Stack(
      clipBehavior: Clip.none,
      children: [
        GestureDetector(
          onTap: onTap,
            child: CircleAvatar(
              radius: 56,
              backgroundColor: context.colors.primary.withValues(alpha: 0.15),
              child: avatarUrl != null
                  ? AppNetworkImage(
                      url: avatarUrl,
                      width: 112,
                      height: 112,
                    )
                  : Text(
                      _initials(profile.name),
                      style: context.textTheme.titleLarge!.copyWith(
                        color: context.colors.primary,
                      ),
                    ),
            ),
        ),
        if (isUploading)
          const Positioned.fill(
            child: Center(
              child: SizedBox(
                width: 22,
                height: 22,
                child: CircularProgressIndicator(strokeWidth: 2),
              ),
            ),
          ),
        PositionedDirectional(
          end: 0,
          bottom: 0,
          child: Container(
            padding: const EdgeInsets.all(6),
            decoration: BoxDecoration(
              color: context.colors.surface,
              shape: BoxShape.circle,
            ),
            child: Icon(
              IconsaxPlusLinear.camera,
              size: 20,
              color: context.colors.textPrimary,
            ),
          ),
        ),
      ],
    );
  }

  String _initials(String? name) {
    if (name == null || name.isEmpty) {
      return '?';
    }
    final parts = name.trim().split(RegExp(r'\s+'));
    if (parts.length == 1) {
      return parts.first[0].toUpperCase();
    }
    return (parts.first[0] + parts.last[0]).toUpperCase();
  }
}