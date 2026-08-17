import 'package:juniorflutterroadmap/features/auth/data/models/user_model.dart';

class AuthMapper {
  static UserModel toUserModel(Map<String, dynamic> rawUser) {
    return UserModel(
      id: rawUser['db_user_id'].toString(),
      name: rawUser['full_name'] ?? 'Anonymous User',
      email: rawUser['email_address'] ?? '',
    );
  }
}