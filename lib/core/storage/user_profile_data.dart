class UserProfileData {

  const UserProfileData({this.id, this.name, this.email, this.avatarUrl});

  factory UserProfileData.fromJson(Map<String, dynamic> json) {
    return UserProfileData(
      id: json['id']?.toString(),
      name: json['name'] as String?,
      email: json['email'] as String?,
      avatarUrl: json['avatarUrl'] as String?,
    );
  }
  final String? id;
  final String? name;
  final String? email;
  final String? avatarUrl;

  UserProfileData copyWith({
    String? id,
    String? name,
    String? email,
    String? avatarUrl,
    bool clearAvatarUrl = false,
  }) {
    return UserProfileData(
      id: id ?? this.id,
      name: name ?? this.name,
      email: email ?? this.email,
      avatarUrl: clearAvatarUrl ? null : (avatarUrl ?? this.avatarUrl),
    );
  }

  Map<String, dynamic> toJson() => {
        if (id != null) 'id': id,
        if (name != null) 'name': name,
        if (email != null) 'email': email,
        if (avatarUrl != null) 'avatarUrl': avatarUrl,
      };
}