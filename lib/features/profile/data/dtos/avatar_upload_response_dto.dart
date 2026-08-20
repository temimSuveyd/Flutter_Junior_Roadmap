class AvatarUploadResponseDto {
  final String avatarUrl;

  AvatarUploadResponseDto({required this.avatarUrl});

  factory AvatarUploadResponseDto.fromJson(Map<String, dynamic> json) {
    final rawUrl = json['location'] ;
    return AvatarUploadResponseDto(avatarUrl: rawUrl?.toString() ?? '');
  }
}