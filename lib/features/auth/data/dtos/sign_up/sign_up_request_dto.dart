class SignUpRequestDto {
  final int id;
  final String username;
  final String email;
  final String password;

  SignUpRequestDto({
    this.id = 0,
    required this.username,
    required this.email,
    required this.password,
  });

  Map<String, dynamic> toJson() => {
    'id': id,
    'username': username,
    'email': email,
    'password': password,
  };
}