import 'package:permission_handler/permission_handler.dart';

/// خدمات طلب الأذونات من الجهاز.
abstract class PermissionService {
  /// التحقق من إذن الكاميرا وطلبه إذا لم يُمنح.
  Future<bool> checkAndRequestCameraPermission();

  /// التحقق من إذن الصور (المعرض) وطلبه إذا لم يُمنح.
  Future<bool> checkAndRequestPhotoPermission();
}

class PermissionServiceImpl implements PermissionService {
  @override
  Future<bool> checkAndRequestCameraPermission() =>
      _requestPermission(Permission.camera);

  @override
  Future<bool> checkAndRequestPhotoPermission() =>
      _requestPermission(Permission.photos);

  /// طلب إذن معين وفتح إعدادات الجهاز إذا رُفض بشكل دائم.
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
