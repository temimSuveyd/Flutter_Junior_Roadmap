import 'package:juniorflutterroadmap/features/auth/data/dtos/sign_in/sign_in_request_dto.dart';
import 'package:juniorflutterroadmap/features/auth/data/dtos/sign_in/sign_in_response_dto.dart';
import 'package:juniorflutterroadmap/features/auth/data/dtos/sign_up/sign_up_request_dto.dart';
import 'package:juniorflutterroadmap/features/auth/data/dtos/sign_up/sign_up_response_dto.dart';

abstract class AuthService {
  SignInResponseDto signIn(SignInRequestDto loginDto);
  SignUpResponseDto signUp(SignUpRequestDto signUpDto);
}

class AuthServiceImpl extends AuthService {
  @override
  SignInResponseDto signIn(SignInRequestDto loginDto) {
    final Map<String, dynamic> mockData = {
      'access_token': '1234',
      'user_details': {
        'db_user_id': '1',
        'full_name': 'Tamim',
        'email_address': 'test@gmail.com',
      },
    };

    final response = SignInResponseDto.fromJson(mockData);
    return response;
  }

  @override
  SignUpResponseDto signUp(SignUpRequestDto signUpDto) {
    final Map<String, dynamic> mockData = {
      'access_token': '5678',
      'user_details': {
        'db_user_id': '2',
        'full_name': 'New User',
        'email_address': signUpDto.email,
      },
    };

    final response = SignUpResponseDto.fromJson(mockData);
    return response;
  }
}