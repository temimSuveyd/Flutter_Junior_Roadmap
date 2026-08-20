// data/datasources/local/shared/image_picker_service.dart
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'permission_service.dart';

abstract class ImagePickerService {
  Future<File?> pickImageFromGallery();
}

class ImagePickerServiceImp implements ImagePickerService {
  final ImagePicker _picker = ImagePicker();
  final PermissionService _permissionService;

  ImagePickerServiceImp(this._permissionService);

  @override
  Future<File?> pickImageFromGallery() async {
    final hasPermission = await _permissionService
        .checkAndRequestPhotoPermission(Permission.photos);
    if (!hasPermission) return null;

    final XFile? pickedFile = await _picker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 60,
    );

    if (pickedFile != null) {
      return File(pickedFile.path);
    }
    return null;
  }
}
