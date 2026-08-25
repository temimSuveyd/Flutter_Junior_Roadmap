class SignInResponseDto {
  final String? accessToken;
  final String? refreshToken;

  SignInResponseDto({required this.accessToken, required this.refreshToken});

  factory SignInResponseDto.fromJson(Map<String, dynamic> json) {
    return SignInResponseDto(
      accessToken: json['access_token'] as String?,
      refreshToken: json['refresh_token'] as String?,
    );
  }
}
