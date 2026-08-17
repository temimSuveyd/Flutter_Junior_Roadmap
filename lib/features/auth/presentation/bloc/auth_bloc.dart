import 'package:bloc/bloc.dart';
import 'package:bloc_concurrency/bloc_concurrency.dart';
import 'package:juniorflutterroadmap/features/auth/data/dtos/sign_in/sign_in_request_dto.dart';
import 'package:juniorflutterroadmap/features/auth/data/dtos/sign_up/sign_up_request_dto.dart';
import 'package:juniorflutterroadmap/features/auth/data/repositories/auth_repository.dart';
import 'package:meta/meta.dart';

part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final AuthRepository _authRepository;

  AuthBloc(this._authRepository) : super(AuthInitial()) {
    on<SignInRequested>(
      transformer: droppable(),
      (event, emit) => _onLoginRequested(event, emit),
    );
    on<SignUpRequested>(
      transformer: droppable(),
      (event, emit) => _onRegisterRequested(event, emit),
    );
  }

  Future<void> _onLoginRequested(
    SignInRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoading());
    final (failure, user) = await _authRepository.loginUser(
      event.signInRequestDto,
    );
    if (failure != null) {
      emit(AuthError(failure.message));
    } else {
      emit(AuthSignInSuccess());
    }
  }

  Future<void> _onRegisterRequested(
    SignUpRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoading());
    final (failure, user) = await _authRepository.registerUser(
      event.signUpRequestDto,
    );
    if (failure != null) {
      emit(AuthError(failure.message));
    } else {
      emit(AuthSignUpSuccess());
    }
  }
}