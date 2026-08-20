import '../dtos/profile/profile_response_dto.dart';
import '../dtos/sign_up/sign_up_response_dto.dart';
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

  static UserModel toUserModelFromSignUp(SignUpResponseDto dto) {
    return UserModel(
      id: dto.id.toString(),
      name: dto.name?.isNotEmpty == true ? dto.name! : 'Anonymous User',
      email: dto.email ?? '',
      image: dto.avatar,
    );
  }
}
