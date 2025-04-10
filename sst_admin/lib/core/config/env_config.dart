import 'dart:io';

class EnvConfig {
  static String get apiBaseUrl {
    // Check if running on mobile emulator
    if (Platform.isAndroid) {
      return 'http://10.0.2.2:4300'; // Android emulator localhost
    } else if (Platform.isIOS) {
      return 'http://localhost:4300'; // iOS simulator localhost
    }
    
    // For web or real devices, try to get local network IP
    // You should replace this with your actual local IP when testing on real devices
    return 'http://localhost:4300';
  }

  static const timeout = Duration(seconds: 30);
  static const String apiVersion = 'v1';
}
