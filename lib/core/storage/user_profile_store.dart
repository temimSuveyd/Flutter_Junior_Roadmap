import 'user_profile_data.dart';

abstract class UserProfileStore {
  Future<UserProfileData?> read();
  Future<void> save(UserProfileData data);
  Future<void> clear();
}
