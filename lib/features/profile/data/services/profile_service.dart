import 'dart:io';

import 'package:dio/dio.dart';
import 'package:juniorflutterroadmap/core/services/network/api_endpoints.dart';
import 'package:juniorflutterroadmap/core/services/network/dio_client.dart';
import '../dtos/avatar_upload_response_dto.dart';

abstract class ProfileService {
  Future<String> uploadAvatar(File image);
}

class ProfileServiceImpl extends ProfileService {
  ProfileServiceImpl(this._dioClient);

  final DioClient _dioClient;

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
}
