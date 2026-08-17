import 'dart:developer';

class SignInResponseDto {
  final String token;
  final Map<String, dynamic> userRawData; // Sunucudan gelen ham kullanıcı datası

  SignInResponseDto({required this.token, required this.userRawData});

  factory SignInResponseDto.fromJson(Map<String, dynamic> json) {
    log(json.toString());
    return SignInResponseDto(
      token: json['access_token'],
      userRawData: json['user_details'],
    );
  }
}
