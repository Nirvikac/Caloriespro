// Network configuration
class NetworkConfig {
  // Configure at runtime (build/run time) with:
  //   flutter run --dart-define=BASE_URL=http://192.168.1.67:3000/api
  // Android emulator (host machine):
  //   flutter run --dart-define=BASE_URL=http://10.0.2.2:3000/api
  static const String baseUrl = String.fromEnvironment(
    'BASE_URL',
    defaultValue: 'http://192.168.1.67:3000/api',
  );

  // For Android physical device on network
  // static const String baseUrl = "http://192.168.1.79:3000/api";

  // For Android Emulator
  // static const String baseUrl = "http://10.0.2.2:3000/api";

  static const Duration connectTimeout = Duration(seconds: 15);
  static const Duration receiveTimeout = Duration(seconds: 30);
}
