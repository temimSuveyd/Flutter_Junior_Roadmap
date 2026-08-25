import 'dart:io';

import 'package:dio/dio.dart';
import 'package:juniorflutterroadmap/core/services/network/api_endpoints.dart';
import 'package:juniorflutterroadmap/core/services/network/dio_client.dart';
import '../dtos/avatar_upload_response_dto.dart';

abstract class ProfileService {
  Future<String> uploadAvatar(File image);
  Future<void> updateAvatar({required int userId, required String avatarUrl});
  Future<void> removeAvatar({required int userId});
}

class ProfileServiceImpl extends ProfileService {
  ProfileServiceImpl(this._dioClient);

  final DioClient _dioClient;
  static const String _defaultAvatarUrl = 'https://placeholder.com';

  @override
  Future<String> uploadAvatar(File image) async {
    final formData = FormData.fromMap({
      'file': await MultipartFile.fromFile(image.path),
    });

    final response = await _dioClient.post(
      ApiEndpoints.uploadAvatar,
      data: formData,
      // options: Options(contentType: 'multipart/form-data'),
    );

    final dto = AvatarUploadResponseDto.fromJson(
      response.data as Map<String, dynamic>,
    );
    return dto.avatarUrl;
  }

  @override
  Future<void> updateAvatar({
    required int userId,
    required String avatarUrl,
  }) async {
    await _dioClient.put(
      ApiEndpoints.userById(userId),
      data: {'avatar': avatarUrl},
    );
  }

  @override
  Future<void> removeAvatar({required int userId}) async {
    await _dioClient.put(
      ApiEndpoints.userById(userId),
      data: {'avatar': _defaultAvatarUrl},
    );
  }
}
