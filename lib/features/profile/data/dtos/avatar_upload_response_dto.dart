class AvatarUploadResponseDto {
  final String avatarUrl;

  AvatarUploadResponseDto({required this.avatarUrl});

  factory AvatarUploadResponseDto.fromJson(Map<String, dynamic> json) {
    final rawUrl = json['avatar_url'] ?? json['url'] ?? json['image'];
    return AvatarUploadResponseDto(avatarUrl: rawUrl?.toString() ?? '');
  }
}