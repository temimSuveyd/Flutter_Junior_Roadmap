import 'package:flutter_test/flutter_test.dart';
import 'package:juniorflutterroadmap/features/auth/data/dtos/profile/profile_response_dto.dart';
import 'package:juniorflutterroadmap/features/auth/data/mappers/auth_mapper.dart';
import 'package:juniorflutterroadmap/features/auth/data/models/user_model.dart';

/// Tests that a profile response is mapped into the user model.
void main() {
  test('toUserModelFromProfile maps profile fields to the user model', () {
    final dto = ProfileResponseDto(
      id: 7,
      name: 'Alice',
      email: 'a@b.com',
      avatar: 'https://img/a.jpg',
    );

    final user = AuthMapper.toUserModelFromProfile(dto);

    expect(user.id, '7');
    expect(user.name, 'Alice');
    expect(user.email, 'a@b.com');
    expect(user.image, 'https://img/a.jpg');
  });
}
