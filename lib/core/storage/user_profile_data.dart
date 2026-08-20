class UserProfileData {
  final String? name;
  final String? email;
  final String? avatarUrl;

  const UserProfileData({this.name, this.email, this.avatarUrl});

  UserProfileData copyWith({
    String? name,
    String? email,
    String? avatarUrl,
    bool clearAvatarUrl = false,
  }) {
    return UserProfileData(
      name: name ?? this.name,
      email: email ?? this.email,
      avatarUrl: clearAvatarUrl ? null : (avatarUrl ?? this.avatarUrl),
    );
  }

  Map<String, dynamic> toJson() => {
        if (name != null) 'name': name,
        if (email != null) 'email': email,
        if (avatarUrl != null) 'avatarUrl': avatarUrl,
      };

  factory UserProfileData.fromJson(Map<String, dynamic> json) {
    return UserProfileData(
      name: json['name'] as String?,
      email: json['email'] as String?,
      avatarUrl: json['avatarUrl'] as String?,
    );
  }
}