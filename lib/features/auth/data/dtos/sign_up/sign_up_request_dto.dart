class SignUpRequestDto {

  SignUpRequestDto({
    required this.name,
    required this.email,
    required this.password,
    this.avatar,
  });
  final String name;
  final String email;
  final String password;
  final String? avatar;

  Map<String, dynamic> toJson() => {
        'name': name,
        'email': email,
        'password': password,
        // if (avatar != null) 
        'avatar': 'https://i.imgur.com/LDOO4Qs.jpg',
      };
}