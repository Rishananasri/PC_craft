import 'dart:io';
import 'package:flutter/foundation.dart';

class ApiConstants {
  /// BASE URL - Use 10.0.2.2 for Android emulator, actual IP for physical devices.
  /// Use localhost for web and iOS/desktop.
  static String get baseUrl {
    if (kIsWeb) return 'http://localhost:8000';
    if (Platform.isAndroid) return 'http://10.0.2.2:8000';
    return 'http://localhost:8000';
  }

  /// AUTH APIs
  static const String userRegister = '/api/auth/register/user/';
  static const String userWorker = '/api/auth/register/worker/';
  static const String login = '/api/auth/login/';
  static const String googleAuth = '/api/auth/google/';
}
