class SignInRequestDto {
  final String userName;
  final String password;

  SignInRequestDto({required this.userName, required this.password});

  Map<String, dynamic> toJson() => {
    'email': userName,
    'password': password,
  };
}