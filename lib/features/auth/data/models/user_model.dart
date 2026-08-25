class UserModel {

  UserModel({
    required this.id,
    required this.name,
    required this.email,
    this.image,
  });
  final String id;
  final String name;
  final String email;
  final String? image;
}