import 'package:permission_handler/permission_handler.dart';

/// Services for requesting device permissions.
abstract class PermissionService {
  /// Checks and requests the camera permission if not granted.
  Future<bool> checkAndRequestCameraPermission();

  /// Checks and requests the photos (gallery) permission if not granted.
  Future<bool> checkAndRequestPhotoPermission();
}

class PermissionServiceImpl implements PermissionService {
  @override
  Future<bool> checkAndRequestCameraPermission() =>
      _requestPermission(Permission.camera);

  @override
  Future<bool> checkAndRequestPhotoPermission() =>
      _requestPermission(Permission.photos);

  /// Requests a permission and opens device settings if permanently denied.
  Future<bool> _requestPermission(Permission permission) async {
    var status = await permission.status;

    if (status.isDenied) {
      status = await permission.request();
    }

    if (status.isPermanentlyDenied) {
      await openAppSettings();
      return false;
    }

    return status.isGranted;
  }
}
