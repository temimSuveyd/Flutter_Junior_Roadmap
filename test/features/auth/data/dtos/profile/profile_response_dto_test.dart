import 'package:flutter_test/flutter_test.dart';
import 'package:juniorflutterroadmap/features/auth/data/dtos/profile/profile_response_dto.dart';

/// Tests that a profile JSON is parsed with null safety.
void main() {
  test('fromJson parses a full profile', () {
    final dto = ProfileResponseDto.fromJson({
      'id': 9,
      'name': 'Bob',
      'email': 'bob@x.com',
      'avatar': 'https://img/b.jpg',
    });

    expect(dto.id, 9);
    expect(dto.name, 'Bob');
    expect(dto.email, 'bob@x.com');
    expect(dto.avatar, 'https://img/b.jpg');
  });

  test('fromJson handles missing fields without crashing', () {
    final dto = ProfileResponseDto.fromJson({'id': 0});
    expect(dto.id, 0);
    expect(dto.name, isNull);
    expect(dto.email, isNull);
    expect(dto.avatar, isNull);
  });
}
