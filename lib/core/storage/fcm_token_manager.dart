/// FCM token'ının yerel depolanması için soyut sınıf.
abstract class FcmTokenManager {
  /// Kayıtlı FCM token'ını döndürür; yoksa `null`.
  Future<String?> getToken();

  /// FCM token'ını yerel depolamaya yazar.
  Future<void> saveToken(String token);

  /// Kayıtlı FCM token'ını temizler.
  Future<void> clearToken();
}
