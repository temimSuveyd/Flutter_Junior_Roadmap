class SignUpResponseDto {
  final int id;
  final String token;

  SignUpResponseDto({required this.id, required this.token});

  factory SignUpResponseDto.fromJson(Map<String, dynamic> json) {
    return SignUpResponseDto(
      id: json['id'],
      token: json['token'] ?? '',
    );
  }
}