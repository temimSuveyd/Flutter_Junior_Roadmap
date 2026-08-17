class SignUpResponseDto {
  final String token;
  final Map<String, dynamic> userRawData;

  SignUpResponseDto({required this.token, required this.userRawData});

  factory SignUpResponseDto.fromJson(Map<String, dynamic> json) {
    return SignUpResponseDto(
      token: json['access_token'],
      userRawData: json['user_details'],
    );
  }
}