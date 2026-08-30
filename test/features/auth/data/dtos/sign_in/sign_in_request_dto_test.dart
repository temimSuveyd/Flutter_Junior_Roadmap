import 'package:flutter_test/flutter_test.dart';
import 'package:juniorflutterroadmap/features/auth/data/dtos/sign_in/sign_in_request_dto.dart';

/// Tests that the sign-in request sends the right API keys.
void main() {
  test('toJson sends email and password', () {
    final dto = SignInRequestDto(userName: 'me@x.com', password: 'secret');

    final json = dto.toJson();

    expect(json['email'], 'me@x.com');
    expect(json['password'], 'secret');
  });
}
