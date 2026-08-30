part of 'auth_bloc.dart';

@immutable
sealed class AuthEvent {}

class SignInRequested extends AuthEvent {
  SignInRequested(this.signInRequestDto, {this.cancelToken});
  final SignInRequestDto signInRequestDto;
  final CancelToken? cancelToken;
}

class SignUpRequested extends AuthEvent {
  SignUpRequested(this.signUpRequestDto, {this.cancelToken});
  final SignUpRequestDto signUpRequestDto;
  final CancelToken? cancelToken;
}
