/// Abstract class for local storage of the FCM token.
abstract class FcmTokenManager {
  /// Returns the stored FCM token, or `null` if none.
  Future<String?> getToken();

  /// Writes the FCM token to local storage.
  Future<void> saveToken(String token);

  /// Clears the stored FCM token.
  Future<void> clearToken();
}
