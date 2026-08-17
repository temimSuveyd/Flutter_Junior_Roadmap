class SignUpRequestDto {
  final String email;
  final String password;

  SignUpRequestDto({required this.email, required this.password});

  Map<String, dynamic> toJson() => {
    'auth_email': email,
    'auth_password': password,
  };
}