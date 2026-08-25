import '../dtos/profile/profile_response_dto.dart';
import '../models/user_model.dart';

class AuthMapper {
  static UserModel toUserModelFromProfile(ProfileResponseDto dto) {
    return UserModel(
      id: dto.id.toString(),
      name: dto.name ?? '',
      email: dto.email ?? '',
      image: dto.avatar ?? '',
    );
  }
}
