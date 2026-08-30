import 'package:dio/dio.dart';
import 'package:juniorflutterroadmap/features/auth/data/dtos/sign_in/sign_in_request_dto.dart';
import 'package:juniorflutterroadmap/features/auth/data/dtos/sign_in/sign_in_response_dto.dart';
import 'package:juniorflutterroadmap/features/auth/data/dtos/sign_up/sign_up_request_dto.dart';
import 'package:juniorflutterroadmap/features/auth/data/dtos/sign_up/sign_up_response_dto.dart';

import '../../../../core/services/network/api_endpoints.dart';
import '../../../../core/services/network/dio_client.dart';
import '../dtos/profile/profile_response_dto.dart';

abstract class AuthService {
  Future<SignInResponseDto> signIn(
    SignInRequestDto loginDto, {
    CancelToken? cancelToken,
  });
  Future<SignUpResponseDto> signUp(
    SignUpRequestDto signUpDto, {
    CancelToken? cancelToken,
  });

  Future<ProfileResponseDto> getProfileData(
    String accessToken, {
    CancelToken? cancelToken,
  });
}

class AuthServiceImpl extends AuthService {
  AuthServiceImpl(this._client);
  final DioClient _client;

  @override
  Future<SignInResponseDto> signIn(
    SignInRequestDto loginDto, {
    CancelToken? cancelToken,
  }) async {
    final response = await _client.post(
      ApiEndpoints.login,
      data: loginDto.toJson(),
      cancelToken: cancelToken,
    );
    return SignInResponseDto.fromJson(response.data as Map<String, dynamic>);
  }

  @override
  Future<SignUpResponseDto> signUp(
    SignUpRequestDto signUpDto, {
    CancelToken? cancelToken,
  }) async {
    final response = await _client.post(
      ApiEndpoints.users,
      data: signUpDto.toJson(),
      cancelToken: cancelToken,
    );
    return SignUpResponseDto.fromJson(response.data as Map<String, dynamic>);
  }

  @override
  Future<ProfileResponseDto> getProfileData(
    String accessToken, {
    CancelToken? cancelToken,
  }) async {
    final response = await _client.get(
      ApiEndpoints.profile,
      cancelToken: cancelToken,
    );
    return ProfileResponseDto.fromJson(response.data as Map<String, dynamic>);
  }
}
