class AvatarUploadResponseDto {
  AvatarUploadResponseDto({required this.avatarUrl});

  factory AvatarUploadResponseDto.fromJson(Map<String, dynamic> json) {
    final rawUrl = json['location'];
    return AvatarUploadResponseDto(avatarUrl: rawUrl as String);
  }
  final String avatarUrl;
}
