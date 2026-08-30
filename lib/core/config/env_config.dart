import '../../flavors.dart';
import '../services/network/api_endpoints.dart';

class EnvConfig {
  factory EnvConfig.init() {
    switch (F.appFlavor) {
      case Flavor.staging:
        return EnvConfig._(
          apiBaseUrl: ApiEndpoints.stagBaseUrl,
          appName: F.title,
        );
      case Flavor.production:
        return EnvConfig._(apiBaseUrl: ApiEndpoints.baseUrl, appName: F.title);
      case Flavor.dev:
        return EnvConfig._(
          apiBaseUrl: ApiEndpoints.devBaseUrl,
          appName: F.title,
        );
    }
  }

  EnvConfig._({required this.apiBaseUrl, required this.appName});
  final String apiBaseUrl;
  final String appName;
}
