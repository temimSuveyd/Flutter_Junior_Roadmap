import 'package:dio/dio.dart';

import '../../../../core/errors/result.dart';
import '../../../../core/storage/auth_token_manager.dart';
import '../dtos/sign_in/sign_in_request_dto.dart';
import '../dtos/sign_up/sign_up_request_dto.dart';
import '../mappers/auth_mapper.dart';
import '../models/user_model.dart';
import '../services/auth_service.dart';

abstract class AuthRepository {
  Future<Result<bool>> loginUser(
    SignInRequestDto loginDto, {
    CancelToken? cancelToken,
  });

  Future<Result<UserModel>> registerUser(
    SignUpRequestDto signUpDto, {
    CancelToken? cancelToken,
  });
}

class AuthRepositoryImpl extends AuthRepository {
  final AuthService _authService;
  final AuthTokenManager _secureStorage;
  AuthRepositoryImpl(this._authService, this._secureStorage);

  @override
  Future<Result<bool>> loginUser(
    SignInRequestDto loginDto, {
    CancelToken? cancelToken,
  }) {
    return runCatching(() async {
      final response = await _authService.signIn(
        loginDto,
        cancelToken: cancelToken,
      );
      await _secureStorage.saveTokens(
        accessToken: response.token,
        refreshToken: response.token,
      );
      return true;
    });
  }

  @override
  Future<Result<UserModel>> registerUser(
    SignUpRequestDto signUpDto, {
    CancelToken? cancelToken,
  }) {
    return runCatching(() async {
      final response = await _authService.signUp(
        signUpDto,
        cancelToken: cancelToken,
      );
      await _secureStorage.saveTokens(
        accessToken: response.token,
        refreshToken: response.token,
      );
      return AuthMapper.toUserModel({
        'db_user_id': response.id,
        'full_name': signUpDto.username,
        'email_address': signUpDto.email,
      });
    });
  }
}
