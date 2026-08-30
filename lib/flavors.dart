enum Flavor { dev, staging, production }

class F {
  static late final Flavor appFlavor;

  static String get name => appFlavor.name;

  static String get title {
    switch (appFlavor) {
      case Flavor.dev:
        return 'App Dev';
      case Flavor.staging:
        return 'App Staging';
      case Flavor.production:
        return 'E-Commerce';
    }
  }
}
