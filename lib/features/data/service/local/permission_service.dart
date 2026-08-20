// data/datasources/local/shared/permission_service.dart
import 'package:permission_handler/permission_handler.dart';

abstract class PermissionService {
  Future<bool> checkAndRequestPhotoPermission(Permission permission);
}

class PermissionServiceImpl implements PermissionService {
  @override
  Future<bool> checkAndRequestPhotoPermission(Permission permission) async {
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
