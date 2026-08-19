import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:juniorflutterroadmap/core/services/auth/refresh_token_provider.dart';
import 'package:juniorflutterroadmap/core/services/network/dio_clint.dart';
import 'package:juniorflutterroadmap/features/auth/data/dtos/sign_in/sign_in_request_dto.dart';
import 'package:juniorflutterroadmap/features/auth/data/dtos/sign_in/sign_in_response_dto.dart';
import 'package:juniorflutterroadmap/features/auth/data/dtos/sign_up/sign_up_request_dto.dart';
import 'package:juniorflutterroadmap/features/auth/data/dtos/sign_up/sign_up_response_dto.dart';

import '../../../../core/services/network/api_endpoints.dart';

abstract class AuthService extends RefreshTokenProvider {
  Future<SignInResponseDto> signIn(
    SignInRequestDto loginDto, {
    CancelToken? cancelToken,
  });
  Future<SignUpResponseDto> signUp(
    SignUpRequestDto signUpDto, {
    CancelToken? cancelToken,
  });
}

class AuthServiceImpl extends AuthService {
  final DioClient _client;

  AuthServiceImpl(this._client);

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
    log('SignUp response: ${response.data}');
    final id = (response.data as Map<String, dynamic>)['id'];
    return SignUpResponseDto(id: id, token: 'mock_token');
  }

  @override
  Future<String?> refreshUserToken(String refreshToken) async {
    final response = await _client.post(
      ApiEndpoints.refreshToken,
      data: {'refresh_token': refreshToken},
      options: Options(
        extra: {RefreshTokenProvider.isRefreshRequestKey: true},
      ),
    );
    final data = response.data as Map<String, dynamic>;
    return data['token'] as String?;
  }
}