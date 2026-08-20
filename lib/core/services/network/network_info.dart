import 'dart:io';

mixin NetworkInfo {
  Future<bool> get isOnline async {
    try {
      final result = await InternetAddress.lookup('google.com');
      return result.isNotEmpty;
    } on SocketException catch (_) {
      return false;
    }
  }
}