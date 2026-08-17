class SignInRequestDto {
  final String email;
  final String password;

  SignInRequestDto({required this.email, required this.password});

  Map<String, dynamic> toJson() => {
    'auth_email': email,
    'auth_password': password,
  };
}