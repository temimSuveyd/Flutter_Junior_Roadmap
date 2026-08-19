class ApiEndpoints {
  // Base URL
  static const String baseUrl = "https://fakestoreapi.com";

  // Timeout
  static const Duration connectTimeout = Duration(seconds: 10);
  static const Duration receiveTimeout = Duration(seconds: 10);

  // Endpoints
  static const String login = "/auth/login";
  static const String refreshToken = "/auth/refresh";
  static const String users = "/users";
  static const String getProducts = "/products";
  static const String uploadAvatar = "/user/upload-avatar";
}
