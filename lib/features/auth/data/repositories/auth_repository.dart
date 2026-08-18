import 'package:juniorflutterroadmap/core/services/network/failure.dart';
import 'package:juniorflutterroadmap/core/storage/secure_storage.dart';
import 'package:juniorflutterroadmap/features/auth/data/dtos/sign_in/sign_in_request_dto.dart';
import 'package:juniorflutterroadmap/features/auth/data/dtos/sign_up/sign_up_request_dto.dart';
import 'package:juniorflutterroadmap/features/auth/data/models/user_model.dart';
import 'package:juniorflutterroadmap/features/auth/data/services/auth_service.dart';

abstract class AuthRepository {
  Future<(Failure? failure, bool? isSuccess)> loginUser(
    SignInRequestDto loginDto,
  );

  Future<(Failure? failure, UserModel? user)> registerUser(
    SignUpRequestDto signUpDto,
  );
}

class AuthRepositoryImpl extends AuthRepository {
  final AuthService _authService;
  final SecureStorage _secureStorage;
  AuthRepositoryImpl(this._authService, this._secureStorage);

  @override
  Future<(Failure? failure, bool? isSuccess)> loginUser(
    SignInRequestDto loginDto,
  ) async {
    try {
      final response = await _authService.signIn(loginDto);
      await _secureStorage.saveToken(response.token);
      return (null, true);
    } on Failure catch (customFailure) {
      return (customFailure, null);
    } catch (unexpectedError) {
      final systemFailure = Failure(
        "A system error occurred: ${unexpectedError.toString()}",
      );
      return (systemFailure, null);
    }
  }

  @override
  Future<(Failure? failure, UserModel? user)> registerUser(
    SignUpRequestDto signUpDto,
  ) async {
    try {
      final response = await _authService.signUp(signUpDto);
      await _secureStorage.saveToken(response.token);
      final userModel = UserModel(
        id: response.id.toString(),
        name: signUpDto.username,
        email: signUpDto.email,
      );
      return (null, userModel);
    } on Failure catch (customFailure) {
      return (customFailure, null);
    } catch (unexpectedError) {
      final systemFailure = Failure(
        "A system error occurred: ${unexpectedError.toString()}",
      );
      return (systemFailure, null);
    }
  }
}
