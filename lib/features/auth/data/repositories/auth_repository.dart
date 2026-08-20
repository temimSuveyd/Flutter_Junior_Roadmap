import 'package:dio/dio.dart';

import '../../../../core/errors/result.dart';
import '../../../../core/services/network/failure.dart';
import '../../../../core/storage/auth_token_manager.dart';
import '../../../../core/storage/user_profile_data.dart';
import '../../../../core/storage/user_profile_store.dart';
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
  final UserProfileStore _userProfileStore;
  AuthRepositoryImpl(
    this._authService,
    this._secureStorage,
    this._userProfileStore,
  );

  @override
  Future<Result<bool>> loginUser(
    SignInRequestDto loginDto, {
    CancelToken? cancelToken,
  }) {
    return runCatching(() async {
      final loginResponse = await _authService.signIn(
        loginDto,
        cancelToken: cancelToken,
      );

      final accessToken = loginResponse.accessToken;
      if (accessToken == null) {
        throw Failure('Login failed: no access token received.');
      }
      await _secureStorage.saveTokens(
        accessToken: accessToken,
        refreshToken: loginResponse.refreshToken,
      );

      final response = await _authService.getProfileData(accessToken);

      final userModel = AuthMapper.toUserModelFromProfile(response);
      await _saveProfile(
        name: userModel.name,
        email: userModel.email,
        avatarUrl: userModel.image,
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
      final userModel = AuthMapper.toUserModelFromSignUp(response);
      await _saveProfile(name: userModel.name, email: userModel.email);
      return userModel;
    });
  }

  Future<void> _saveProfile({
    required String? name,
    required String? email,
    String? avatarUrl,
  }) {
    return _userProfileStore.save(
      UserProfileData(name: name, email: email, avatarUrl: avatarUrl),
    );
  }
}
