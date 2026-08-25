abstract class LauncherService {
  Future<bool> openUrl(String urlString);
  Future<bool> makePhoneCall(String phoneNumber);

  Future<bool> openWhatsApp({
    required String phoneNumber,
    required String message,
  });
}
