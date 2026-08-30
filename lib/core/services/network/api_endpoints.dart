class ApiEndpoints {
  // Base URL
  static const String baseUrl = 'https://api.escuelajs.co/api/v1';
  static const String devBaseUrl = 'https://api.escuelajs.co/api/v1';
  static const String stagBaseUrl = 'https://api.escuelajs.co/api/v1';



  // Timeout
  static const Duration connectTimeout = Duration(seconds: 10);
  static const Duration receiveTimeout = Duration(seconds: 10);

  // Endpoints
  static const String login = '/auth/login';
  static const String refreshToken = '/auth/refresh-token';
  static const String users = '/users';
  static const String getProducts = '/products';
  static const String getCategories = '/categories';
  static String getProductById(int id) => '/products/$id';
  static String productsByCategory(int id) => '/categories/$id/products';
  static String userById(int id) => '/users/$id';
  static const String uploadAvatar = '/files/upload';
  static const String profile = '/auth/profile';

}
