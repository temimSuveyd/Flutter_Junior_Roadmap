class SignUpResponseDto {

  SignUpResponseDto({
    required this.id,
    this.name,
    this.email,
    this.avatar,
  });

  factory SignUpResponseDto.fromJson(Map<String, dynamic> json) {
    return SignUpResponseDto(
      id: json['id'] as int? ?? 0,
      name: json['name'] as String?,
      email: json['email'] as String?,
      avatar: json['avatar'] as String?,
    );
  }
  final int id;
  final String? name;
  final String? email;
  final String? avatar;
}