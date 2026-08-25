class SignInRequestDto {

  SignInRequestDto({required this.userName, required this.password});
  final String userName;
  final String password;

  Map<String, dynamic> toJson() => {
    'email': userName,
    'password': password,
  };
}