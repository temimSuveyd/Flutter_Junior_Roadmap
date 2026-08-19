part of 'auth_bloc.dart';

@immutable
sealed class AuthEvent {}

class SignInRequested extends AuthEvent {
  final SignInRequestDto signInRequestDto;
  final CancelToken? cancelToken;
  SignInRequested(this.signInRequestDto, {this.cancelToken});
}

class SignUpRequested extends AuthEvent {
  final SignUpRequestDto signUpRequestDto;
  final CancelToken? cancelToken;
  SignUpRequested(this.signUpRequestDto, {this.cancelToken});
}