import 'dart:io';

import 'package:image_picker/image_picker.dart';

import 'package:juniorflutterroadmap/core/services/device_features/permission_service.dart';

/// Image picking services from the camera or gallery.
abstract class ImagePickerService {
  /// Capture an image from the camera (after requesting permission).
  Future<File?> pickImageFromCamera();

  /// Pick an image from the gallery (after requesting permission).
  Future<File?> pickImageFromGallery();
}

class ImagePickerServiceImpl implements ImagePickerService {
  ImagePickerServiceImpl(this._permissionService);

  final PermissionService _permissionService;
  final ImagePicker _picker = ImagePicker();

  @override
  Future<File?> pickImageFromCamera() async {
    final hasPermission =
        await _permissionService.checkAndRequestCameraPermission();
    if (!hasPermission) return null;

    return _pick(source: ImageSource.camera);
  }

  @override
  Future<File?> pickImageFromGallery() async {
    final hasPermission =
        await _permissionService.checkAndRequestPhotoPermission();
    if (!hasPermission) return null;

    return _pick(source: ImageSource.gallery);
  }

  /// Pick an image from a given source with quality and size limits.
  Future<File?> _pick({required ImageSource source}) async {
    final picked = await _picker.pickImage(
      source: source,
      maxWidth: 1024,
      maxHeight: 1024,
      imageQuality: 85,
    );
    if (picked == null) return null;
    return File(picked.path);
  }
}
