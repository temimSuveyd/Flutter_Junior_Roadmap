import 'dart:io';

import 'package:image_picker/image_picker.dart';

import 'permission_service.dart';

/// خدمات اختيار الصور من الكاميرا أو المعرض.
abstract class ImagePickerService {
  /// التقاط صورة من الكاميرا (بعد طلب الإذن).
  Future<File?> pickImageFromCamera();

  /// اختيار صورة من المعرض (بعد طلب الإذن).
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

  /// التقاط صورة من مصدر معين مع تحديد الجودة والأبعاد.
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
