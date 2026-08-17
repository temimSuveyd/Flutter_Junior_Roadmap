part of 'auth_bloc.dart';

@immutable
sealed class AuthEvent {}

class SignInRequested extends AuthEvent {
  final SignInRequestDto signInRequestDto;
  SignInRequested(this.signInRequestDto);
}

class SignUpRequested extends AuthEvent {
  final SignUpRequestDto signUpRequestDto;
  SignUpRequested(this.signUpRequestDto);
}