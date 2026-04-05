import 'dart:io';

class ApiConstants {

  static String get baseUrl {
    if (Platform.isAndroid) return 'http://10.0.2.2:8000';
    return 'http://localhost:8000';
  }

  /// AUTH APIs
  static const String userRegister = '/api/auth/register/user/';
  static const String userWorker = '/api/auth/register/worker/';
  static const String login = '/api/auth/login/';
  static const String googleAuth = '/api/auth/google/';
  static const String resetPassword = '/api/auth/resetpassword/';
  static const String verifyOtp = '/api/auth/verifyotp/';
  static const String forgetPassword = '/api/auth/forgetpassword/';
  static const String logout = '/api/auth/logout/';
  static const String requestPasswordReset = '/api/auth/request-password-reset/';
  static const String changePasswordWithOtp = '/api/auth/change-password-with-otp/';
}
