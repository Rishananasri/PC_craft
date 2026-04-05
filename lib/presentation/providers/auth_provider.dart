import 'dart:developer';
import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../../constants/api_constants.dart';
import 'auth_state.dart';

class AuthNotifier extends StateNotifier<AuthState> {
  final Dio _dio = Dio(
    BaseOptions(
      baseUrl: ApiConstants.baseUrl,
      headers: {"Content-Type": "application/json"},
    ),
  );

  AuthNotifier() : super(const AuthState(isLoading: true)) {
    _loadTokenFromHive();
  }

  Future<void> _loadTokenFromHive() async {
    try {
      final box = await Hive.openBox('authBox');
      final savedToken = box.get('token');
      final savedUserType = box.get('userType');
      final savedUserData = box.get('userData');

      state = AuthState(
        token: savedToken is String ? savedToken : null,
        userType: savedUserType is String ? savedUserType : null,
        userData: savedUserData == null
            ? null
            : Map<String, dynamic>.from(savedUserData as Map),
        isLoading: false,
      );
    } catch (e) {
      state = state.copyWith(isLoading: false);
    }
  }

  Future<void> _saveTokenToHive() async {
    final box = await Hive.openBox('authBox');
    await box.put('token', state.token);
    await box.put('userType', state.userType);
    await box.put(
      'userData',
      state.userData == null
          ? null
          : Map<String, dynamic>.from(state.userData!),
    );
    await box.put('isLoggedIn', state.isLoggedIn);
  }

  Future<void> setToken(
    String? token, {
    String? userType,
    Map<String, dynamic>? userData,
  }) async {
    state = state.copyWith(
      token: token,
      userType: userType ?? state.userType,
      userData: userData ?? state.userData,
    );
    await _saveTokenToHive();
  }

  Future<void> clearToken() async {
    state = const AuthState();
    final box = await Hive.openBox('authBox');
    await box.delete('token');
    await box.delete('userType');
    await box.delete('userData');
    await box.put('isLoggedIn', false);
  }

  Future<Map<String, dynamic>> registerUser({
    required String name,
    required String username,
    required String email,
    required String password,
    required String confirmpassword,
  }) async {
    state = state.copyWith(isLoading: true, errorMessage: null);

    try {
      log("Attempting to register user with email: $email");

      final response = await _dio.post(
        ApiConstants.userRegister,
        data: {
          "full_name": name,
          "email": email,
          "username": username,
          "password": password,
          "confirm_password": confirmpassword,
        },
      );

      log("Response status: ${response.statusCode}");
      log("Response data: ${response.data}");

      if (response.statusCode == 200 || response.statusCode == 201) {
        state = state.copyWith(isLoading: false);
        return {
          'success': true,
          'data': response.data,
          'message': response.data['message'] ?? 'User registered successfully',
        };
      } else {
        state = state.copyWith(
          isLoading: false,
          errorMessage: response.data['message'] ?? 'Registration failed',
        );
        return {
          'success': false,
          'message': response.data['message'] ?? 'Registration failed',
        };
      }
    } on DioException catch (e) {
      log("DioException: ${e.message}");
      log("Type: ${e.type}");

      if (e.response != null) {
        log("Status: ${e.response?.statusCode}");
        log("Data: ${e.response?.data}");
      }

      String errorMessage = 'Network error occurred';

      if (e.response != null) {
        final statusCode = e.response?.statusCode;
        final data = e.response?.data;

        if (statusCode == 400) {
          errorMessage = data?['message'] ?? 'Invalid data';
        } else if (statusCode == 409) {
          errorMessage = data?['message'] ?? 'User already exists';
        } else if (statusCode == 500) {
          errorMessage = 'Server error';
        } else {
          errorMessage = data?['message'] ?? 'Registration failed';
        }
      } else {
        errorMessage = 'Check internet connection';
      }

      state = state.copyWith(isLoading: false, errorMessage: errorMessage);
      return {'success': false, 'message': errorMessage};
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        errorMessage: 'Unexpected error',
      );
      return {'success': false, 'message': 'Unexpected error'};
    }
  }

  Future<Map<String, dynamic>> registerWorker({
    required String name,
    required String username,
    required String email,
    required String password,
    required String confirmpassword,
  }) async {
    state = state.copyWith(isLoading: true, errorMessage: null);

    try {
      log("Attempting to register worker with email: $email");

      final response = await _dio.post(
        ApiConstants.userWorker,
        data: {
          "full_name": name,
          "email": email,
          "username": username,
          "password": password,
          "confirm_password": confirmpassword,
        },
      );

      log("Response status: ${response.statusCode}");
      log("Response data: ${response.data}");

      if (response.statusCode == 200 || response.statusCode == 201) {
        state = state.copyWith(isLoading: false);
        return {
          'success': true,
          'data': response.data,
          'message':
              response.data['message'] ?? 'Worker registered successfully',
        };
      } else {
        state = state.copyWith(
          isLoading: false,
          errorMessage: response.data['message'] ?? 'Registration failed',
        );
        return {
          'success': false,
          'message': response.data['message'] ?? 'Registration failed',
        };
      }
    } on DioException catch (e) {
      log("DioException: ${e.message}");
      log("Type: ${e.type}");

      if (e.response != null) {
        log("Status: ${e.response?.statusCode}");
        log("Data: ${e.response?.data}");
      }

      String errorMessage = 'Network error occurred';

      if (e.response != null) {
        final statusCode = e.response?.statusCode;
        final data = e.response?.data;

        if (statusCode == 400) {
          errorMessage = data?['message'] ?? 'Invalid data';
        } else if (statusCode == 409) {
          errorMessage = data?['message'] ?? 'Worker already exists';
        } else if (statusCode == 500) {
          errorMessage = 'Server error';
        } else {
          errorMessage = data?['message'] ?? 'Registration failed';
        }
      } else {
        errorMessage = 'Check internet connection';
      }

      state = state.copyWith(isLoading: false, errorMessage: errorMessage);
      return {'success': false, 'message': errorMessage};
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        errorMessage: 'Unexpected error',
      );
      return {'success': false, 'message': 'Unexpected error'};
    }
  }

  Future<Map<String, dynamic>> login({
    required String username,
    required String password,
  }) async {
    state = state.copyWith(isLoading: true, errorMessage: null);

    try {
      log("Login attempt: $username");

      final response = await _dio.post(
        ApiConstants.login,
        data: {"username": username, "password": password},
      );

      log("Response: ${response.data}");

      if (response.statusCode == 200) {
        final token = response.data['access'];
        final user = response.data['user'];

        await setToken(token, userType: user['role'], userData: user);

        state = state.copyWith(isLoading: false);
        return {
          'success': true,
          'message': response.data['message'] ?? 'Login success',
          'user_type': user['role'],
          'user_data': user,
        };
      }

      state = state.copyWith(
        isLoading: false,
        errorMessage: response.data['message'] ?? 'Login failed',
      );
      return {
        'success': false,
        'message': response.data['message'] ?? 'Login failed',
      };
    } on DioException catch (e) {
      log("Login Dio Error: ${e.message}");

      String errorMessage = 'Network error';

      if (e.response != null) {
        final code = e.response?.statusCode;
        final data = e.response?.data;

        if (code == 400) {
          errorMessage = data?['message'] ?? 'Invalid credentials';
        } else if (code == 401) {
          errorMessage = data?['message'] ?? 'Wrong username/password';
        } else if (code == 500) {
          errorMessage = 'Server error';
        } else {
          errorMessage = data?['message'] ?? 'Login failed';
        }
      } else {
        errorMessage = 'No internet connection';
      }

      state = state.copyWith(isLoading: false, errorMessage: errorMessage);
      return {'success': false, 'message': errorMessage};
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        errorMessage: 'Unexpected error',
      );
      return {'success': false, 'message': 'Unexpected error'};
    }
  }

  Future<Map<String, dynamic>> logout() async {
    state = state.copyWith(isLoading: true, errorMessage: null);

    try {
      log("Logout attempt");

      final response = await _dio.post(
        ApiConstants.logout,
        options: Options(
          headers: {
            if (state.token != null) "Authorization": "Bearer ${state.token}",
          },
        ),
      );

      await clearToken();

      state = state.copyWith(isLoading: false);
      return {
        'success': true,
        'message': response.data?['message'] ?? 'Logout successful',
      };
    } catch (e) {
      await clearToken();
      state = state.copyWith(isLoading: false);
      return {'success': true, 'message': 'Logged out locally'};
    }
  }

  Future<Map<String, dynamic>> requestPasswordReset({
    required String email,
  }) async {
    state = state.copyWith(isLoading: true, errorMessage: null);

    try {
      final response = await _dio.post(
        ApiConstants.requestPasswordReset,
        data: {"email": email},
      );

      state = state.copyWith(isLoading: false);
      return {
        'success': response.statusCode == 200,
        'message': response.data?['message'] ?? 'OTP sent successfully',
      };
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        errorMessage: 'Failed to send OTP',
      );
      return {'success': false, 'message': 'Failed to send OTP'};
    }
  }

  Future<Map<String, dynamic>> verifyOtp({
    required String email,
    required String otp,
  }) async {
    state = state.copyWith(isLoading: true, errorMessage: null);

    try {
      final response = await _dio.post(
        ApiConstants.verifyOtp,
        data: {"email": email, "otp": otp},
      );

      state = state.copyWith(isLoading: false);
      return {
        'success': response.statusCode == 200,
        'message': response.data?['message'] ?? 'OTP verified successfully',
      };
    } catch (e) {
      state = state.copyWith(isLoading: false, errorMessage: 'Invalid OTP');
      return {'success': false, 'message': 'Invalid OTP'};
    }
  }

  Future<Map<String, dynamic>> changePasswordWithOtp({
    required String email,
    required String otp,
    required String password,
    required String confirmPassword,
  }) async {
    state = state.copyWith(isLoading: true, errorMessage: null);

    try {
      final response = await _dio.post(
        ApiConstants.changePasswordWithOtp,
        data: {
          "email": email,
          "otp": otp,
          "password": password,
          "confirm_password": confirmPassword,
        },
      );

      state = state.copyWith(isLoading: false);
      return {
        'success': response.statusCode == 200,
        'message': response.data?['message'] ?? 'Password changed successfully',
      };
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        errorMessage: 'Failed to change password',
      );
      return {'success': false, 'message': 'Failed to change password'};
    }
  }

  Future<Map<String, dynamic>> googleAuth({required String accessToken}) async {
    state = state.copyWith(isLoading: true, errorMessage: null);

    try {
      log("Google auth attempt");

      final response = await _dio.post(
        ApiConstants.googleAuth,
        data: {"access_token": accessToken},
      );

      log("Google auth response: ${response.data}");

      if (response.statusCode == 200) {
        final token = response.data['access'];
        final user = response.data['user'];

        await setToken(token, userType: user['role'], userData: user);

        state = state.copyWith(isLoading: false);
        return {
          'success': true,
          'message': response.data['message'] ?? 'Google login successful',
          'user_type': user['role'],
          'user_data': user,
        };
      }

      state = state.copyWith(
        isLoading: false,
        errorMessage: response.data['message'] ?? 'Google login failed',
      );
      return {
        'success': false,
        'message': response.data['message'] ?? 'Google login failed',
      };
    } on DioException catch (e) {
      log("Google auth Dio Error: ${e.message}");

      String errorMessage = 'Network error';

      if (e.response != null) {
        final code = e.response?.statusCode;
        final data = e.response?.data;

        if (code == 400) {
          errorMessage = data?['message'] ?? 'Invalid Google token';
        } else if (code == 401) {
          errorMessage = data?['message'] ?? 'Google authentication failed';
        } else if (code == 500) {
          errorMessage = 'Server error';
        } else {
          errorMessage = data?['message'] ?? 'Google login failed';
        }
      } else {
        errorMessage = 'No internet connection';
      }

      state = state.copyWith(isLoading: false, errorMessage: errorMessage);
      return {'success': false, 'message': errorMessage};
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        errorMessage: 'Unexpected error',
      );
      return {'success': false, 'message': 'Unexpected error'};
    }
  }
}

final authProvider = StateNotifierProvider<AuthNotifier, AuthState>((ref) {
  return AuthNotifier();
});
