class SignInResponseDto {
  final String token;

  SignInResponseDto({required this.token});

  factory SignInResponseDto.fromJson(Map<String, dynamic> json) {
    return SignInResponseDto(token: json['token']);
  }
}
