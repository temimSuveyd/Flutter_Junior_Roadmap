/// إعدادات الاتصال الأساسية بالـ API.
class ApiConstants {
  static const String baseUrl = 'https://fakestoreapi.com';
  static const Duration connectTimeOut = Duration(seconds: 5);
  static const Duration receiveTimeOut = Duration(seconds: 5);
}

/// نقاط النهاية الخاصة بالـ API.
class Endpoints {
  static const String logIn = '${ApiConstants.baseUrl}/auth/login';
  static const String signUp = '${ApiConstants.baseUrl}/users';
  static const String getUserData = '${ApiConstants.baseUrl}/users';
  static const String getAllProducts = '${ApiConstants.baseUrl}/products';
  static const String getAllCarts = '${ApiConstants.baseUrl}/carts';
  static const String getSingleCart = '${ApiConstants.baseUrl}/carts';
  static const String getProductDetails = '${ApiConstants.baseUrl}/products';
}
