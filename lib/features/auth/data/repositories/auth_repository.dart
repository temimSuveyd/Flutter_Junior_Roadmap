import 'package:dio/dio.dart';
import 'package:juniorflutterroadmap/core/errors/result.dart';
import 'package:juniorflutterroadmap/core/storage/secure_storage.dart';
import 'package:juniorflutterroadmap/features/auth/data/dtos/sign_in/sign_in_request_dto.dart';
import 'package:juniorflutterroadmap/features/auth/data/dtos/sign_up/sign_up_request_dto.dart';
import 'package:juniorflutterroadmap/features/auth/data/mappers/auth_mapper.dart';
import 'package:juniorflutterroadmap/features/auth/data/models/user_model.dart';
import 'package:juniorflutterroadmap/features/auth/data/services/auth_service.dart';

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
  final SecureStorage _secureStorage;
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
      await _secureStorage.saveToken(response.token);
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
      await _secureStorage.saveToken(response.token);
      return AuthMapper.toUserModel({
        'db_user_id': response.id,
        'full_name': signUpDto.username,
        'email_address': signUpDto.email,
      });
    });
  }
}
