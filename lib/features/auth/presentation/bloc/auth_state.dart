part of 'auth_bloc.dart';

@immutable
sealed class AuthState {}

final class AuthInitial extends AuthState {}
final class AuthLoading extends AuthState {}
final class AuthError extends AuthState {
  final String message;
  AuthError(this.message);
}
final class AuthSignInSuccess extends AuthState {}
final class AuthSignUpSuccess extends AuthState {}






