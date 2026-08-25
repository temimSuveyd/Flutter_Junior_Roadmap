class ApiEndpoints {
  // Base URL
  static const String baseUrl = 'https://api.escuelajs.co/api/v1';

  // Timeout
  static const Duration connectTimeout = Duration(seconds: 10);
  static const Duration receiveTimeout = Duration(seconds: 10);

  // Endpoints
  static const String login = '/auth/login';
  static const String refreshToken = '/auth/refresh';
  static const String users = '/users';
  static const String getProducts = '/products';
  static const String getCategories = '/categories';
  static String getProductById(int id) => '/products/$id';
  static const String uploadAvatar = '/api/v1/files/upload';
  static const String profile = '/auth/profile';

}
