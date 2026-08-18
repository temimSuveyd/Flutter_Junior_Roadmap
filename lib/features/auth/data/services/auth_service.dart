import 'dart:developer';

import 'package:juniorflutterroadmap/core/services/network/dio_clint.dart';
import 'package:juniorflutterroadmap/features/auth/data/dtos/sign_in/sign_in_request_dto.dart';
import 'package:juniorflutterroadmap/features/auth/data/dtos/sign_in/sign_in_response_dto.dart';
import 'package:juniorflutterroadmap/features/auth/data/dtos/sign_up/sign_up_request_dto.dart';
import 'package:juniorflutterroadmap/features/auth/data/dtos/sign_up/sign_up_response_dto.dart';

import '../../../../core/di/injection.dart';
import '../../../../core/services/network/api_endpoints.dart';

abstract class AuthService {
  Future<SignInResponseDto> signIn(SignInRequestDto loginDto);
  Future<SignUpResponseDto> signUp(SignUpRequestDto signUpDto);
}

class AuthServiceImpl extends AuthService {
  final DioClient _client = getIt<DioClient>();

  @override
  Future<SignInResponseDto> signIn(SignInRequestDto loginDto) async {
    final response = await _client.post(
      ApiEndpoints.login,
      data: loginDto.toJson(),
    );
    return SignInResponseDto.fromJson(response.data as Map<String, dynamic>);
  }

  @override
  Future<SignUpResponseDto> signUp(SignUpRequestDto signUpDto) async {
    final response = await _client.post(
      ApiEndpoints.users,
      data: signUpDto.toJson(),
    );
    log('SignUp response: ${response.data}');
    final id = (response.data as Map<String, dynamic>)['id'];
    return SignUpResponseDto(id: id, token: 'mock_token');
  }
}