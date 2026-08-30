import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:image_picker/image_picker.dart';
import 'package:juniorflutterroadmap/core/services/device_features/image_picker_service.dart';
import 'package:juniorflutterroadmap/core/services/device_features/permission_service.dart';
import 'package:mocktail/mocktail.dart';

/// Mock of the permission dependency, so no real OS permission prompt happens.
class MockPermissionService extends Mock implements PermissionService {}

/// Reusable mock of [ImagePickerService] for widget/bloc tests that need to
/// fake image picking without touching the real implementation.
class MockImagePickerService extends Mock implements ImagePickerService {}

/// Fake of the real [ImagePicker] that records calls and returns a canned file,
/// so no native picker UI is ever opened during the test.
class FakeImagePicker extends Fake implements ImagePicker {
  XFile? picked;
  int pickCallCount = 0;

  @override
  Future<XFile?> pickImage({
    required ImageSource source,
    double? maxWidth,
    double? maxHeight,
    int? imageQuality,
    CameraDevice preferredCameraDevice = CameraDevice.rear,
    bool? requestFullMetadata,
  }) async {
    pickCallCount++;
    return picked;
  }
}

void main() {
  group('ImagePickerServiceImpl', () {
    late MockPermissionService permission;
    late FakeImagePicker picker;
    late ImagePickerServiceImpl service;

    setUp(() {
      permission = MockPermissionService();
      picker = FakeImagePicker();
      service = ImagePickerServiceImpl(permission, picker);
    });

    test(
      'camera: returns null and never opens picker when permission denied',
      () async {
        when(
          () => permission.checkAndRequestCameraPermission(),
        ).thenAnswer((_) async => false);

        final result = await service.pickImageFromCamera();

        expect(result, isNull);
        expect(picker.pickCallCount, 0);
      },
    );

    test(
      'gallery: returns null and never opens picker when permission denied',
      () async {
        when(
          () => permission.checkAndRequestPhotoPermission(),
        ).thenAnswer((_) async => false);

        final result = await service.pickImageFromGallery();

        expect(result, isNull);
        expect(picker.pickCallCount, 0);
      },
    );

    test(
      'camera: returns a File when permission granted and an image is picked',
      () async {
        when(
          () => permission.checkAndRequestCameraPermission(),
        ).thenAnswer((_) async => true);
        picker.picked = XFile('fake_photo.jpg');

        final result = await service.pickImageFromCamera();

        expect(result, isNotNull);
        expect(result!.path, 'fake_photo.jpg');
        expect(picker.pickCallCount, 1);
      },
    );

    test(
      'gallery: returns null when permission granted but user cancels',
      () async {
        when(
          () => permission.checkAndRequestPhotoPermission(),
        ).thenAnswer((_) async => true);
        picker.picked = null;

        final result = await service.pickImageFromGallery();

        expect(result, isNull);
        expect(picker.pickCallCount, 1);
      },
    );
  });

  group('MockImagePickerService (reusable mock)', () {
    test('can be stubbed to return a picked file', () async {
      final mock = MockImagePickerService();
      when(
        () => mock.pickImageFromGallery(),
      ).thenAnswer((_) async => File('picked.png'));

      final result = await mock.pickImageFromGallery();

      expect(result?.path, 'picked.png');
    });
  });
}
