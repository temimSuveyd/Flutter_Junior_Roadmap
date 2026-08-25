import 'package:permission_handler/permission_handler.dart';

abstract class PermissionService {
  Future<bool> checkAndRequestCameraPermission();

  Future<bool> checkAndRequestPhotoPermission();

  Future<bool> checkAndRequestLocationPermission();
}

class PermissionServiceImpl implements PermissionService {
  @override
  Future<bool> checkAndRequestCameraPermission() =>
      _requestPermission(Permission.camera);

  @override
  Future<bool> checkAndRequestPhotoPermission() =>
      _requestPermission(Permission.photos);

  @override
  Future<bool> checkAndRequestLocationPermission() =>
      _requestPermission(Permission.locationWhenInUse);

  Future<bool> _requestPermission(Permission permission) async {
    var status = await permission.status;

    if (status.isDenied) {
      status = await permission.request();
    }

    if (status.isPermanentlyDenied) {
      await openAppSettings();
      // Refresh status after the user grants permission from settings and returns.
      status = await permission.status;
    }

    // On iOS, `isLimited` (partial access) for photos is also accepted.
    return status.isGranted || status.isLimited;
  }
}
