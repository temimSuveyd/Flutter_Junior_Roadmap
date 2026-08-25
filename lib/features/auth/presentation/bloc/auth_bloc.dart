import 'package:bloc/bloc.dart';
import 'package:bloc_concurrency/bloc_concurrency.dart';
import 'package:dio/dio.dart';
import 'package:juniorflutterroadmap/core/errors/result.dart';
import 'package:juniorflutterroadmap/features/auth/data/dtos/sign_in/sign_in_request_dto.dart';
import 'package:juniorflutterroadmap/features/auth/data/dtos/sign_up/sign_up_request_dto.dart';
import 'package:juniorflutterroadmap/features/auth/data/repositories/auth_repository.dart';
import 'package:meta/meta.dart';

part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final AuthRepository _authRepository;
  final CancelToken _cancelToken = CancelToken();
  bool _isProcessing = false;

  AuthBloc(this._authRepository) : super(AuthInitial()) {
    on<SignInRequested>(
      transformer: droppable(),
      _onLoginRequested,
    );
    on<SignUpRequested>(
      transformer: droppable(),
      _onRegisterRequested,
    );
  }

  CancelToken _tokenFor(CancelToken? provided) => provided ?? _cancelToken;

  Future<void> _onLoginRequested(
    SignInRequested event,
    Emitter<AuthState> emit,
  ) async {
    if (_isProcessing) return;
    _isProcessing = true;
    emit(AuthLoading());
    final cancelToken = _tokenFor(event.cancelToken);
    final result = await _authRepository.loginUser(
      event.signInRequestDto,
      cancelToken: cancelToken,
    );
    _isProcessing = false;
    if (isClosed || cancelToken.isCancelled) return;
    switch (result) {
      case Success():
        emit(AuthSignInSuccess());
      case Error(:final error):
        emit(AuthError(error.message));
    }
  }

  Future<void> _onRegisterRequested(
    SignUpRequested event,
    Emitter<AuthState> emit,
  ) async {
    if (_isProcessing) return;
    _isProcessing = true;
    emit(AuthLoading());
    final cancelToken = _tokenFor(event.cancelToken);
    final result = await _authRepository.registerUser(
      event.signUpRequestDto,
      cancelToken: cancelToken,
    );
    _isProcessing = false;
    if (isClosed || cancelToken.isCancelled) return;
    switch (result) {
      case Success():
        emit(AuthSignUpSuccess());
      case Error(:final error):
        emit(AuthError(error.message));
    }
  }

  @override
  Future<void> close() {
    _cancelToken.cancel('AuthBloc closed');
    return super.close();
  }
}
