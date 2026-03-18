import 'dart:developer';

import 'package:dio/dio.dart';
import '../constants/api_constants.dart';

class AuthService {
  final Dio dio = Dio(
    BaseOptions(
      baseUrl: ApiConstants.baseUrl,
      headers: {"Content-Type": "application/json"},
    ),
  );

  /// REGISTER USER
  Future<Map<String, dynamic>> registerUser({
    required String name,
    required String username,
    required String email,
    required String password,
    required String confirmpassword,
  }) async {
    try {
      log("Attempting to register user with email: $email");
      final response = await dio.post(
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
        return {
          'success': true,
          'data': response.data,
          'message': response.data['message'] ?? 'User registered successfully',
        };
      } else {
        return {
          'success': false,
          'message': response.data['message'] ?? 'Registration failed',
        };
      }
    } on DioException catch (e) {
      log("DioException: ${e.message}");
      log("DioException type: ${e.type}");
      if (e.response != null) {
        log("Error response status: ${e.response?.statusCode}");
        log("Error response data: ${e.response?.data}");
      }

      String errorMessage = 'Network error occurred';

      if (e.response != null) {
        final statusCode = e.response?.statusCode;
        final responseData = e.response?.data;

        if (statusCode == 400) {
          errorMessage = responseData?['message'] ?? 'Invalid data provided';
        } else if (statusCode == 409) {
          errorMessage = responseData?['message'] ?? 'User already exists';
        } else if (statusCode == 500) {
          errorMessage = 'Server error. Please try again later';
        } else {
          errorMessage = responseData?['message'] ?? 'Registration failed';
        }
      } else {
        errorMessage =
            'Network connection failed. Please check your internet connection';
      }

      return {'success': false, 'message': errorMessage};
    } catch (e) {
      return {'success': false, 'message': 'An unexpected error occurred'};
    }
  }

  /// REGISTER WORKER
  Future<Map<String, dynamic>> registerWorker({
    required String name,
    required String username,
    required String email,
    required String password,
    required String confirmpassword,
  }) async {
    try {
      log("Attempting to register worker with email: $email");
      final response = await dio.post(
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
        return {
          'success': true,
          'data': response.data,
          'message':
              response.data['message'] ?? 'Worker registered successfully',
        };
      } else {
        return {
          'success': false,
          'message': response.data['message'] ?? 'Registration failed',
        };
      }
    } on DioException catch (e) {
      log("DioException: ${e.message}");
      log("DioException type: ${e.type}");
      if (e.response != null) {
        log("Error response status: ${e.response?.statusCode}");
        log("Error response data: ${e.response?.data}");
      }

      String errorMessage = 'Network error occurred';

      if (e.response != null) {
        final statusCode = e.response?.statusCode;
        final responseData = e.response?.data;

        if (statusCode == 400) {
          errorMessage = responseData?['message'] ?? 'Invalid data provided';
        } else if (statusCode == 409) {
          errorMessage = responseData?['message'] ?? 'Worker already exists';
        } else if (statusCode == 500) {
          errorMessage = 'Server error. Please try again later';
        } else {
          errorMessage = responseData?['message'] ?? 'Registration failed';
        }
      } else {
        errorMessage =
            'Network connection failed. Please check your internet connection';
      }

      return {'success': false, 'message': errorMessage};
    } catch (e) {
      return {'success': false, 'message': 'An unexpected error occurred'};
    }
  }

Future<Map<String, dynamic>> googleAuth({required String accessToken}) async {
  try {
    log("Attempting Google authentication");

    final response = await dio.post(
      ApiConstants.googleAuth,
      data: {
        "access_token": accessToken,
        "role": "user"
      },
    );

    log("Response status: ${response.statusCode}");
    log("Response data: ${response.data}");

    if (response.statusCode == 200 || response.statusCode == 201) {
      return {
        'success': true,
        'data': response.data,
        'message': 'Google authentication successful',
      };
    } else {
      return {
        'success': false,
        'message': 'Google authentication failed',
      };
    }
  } on DioException catch (e) {
    log("DioException: ${e.message}");
    log("DioException type: ${e.type}");

    if (e.response != null) {
      log("Error response status: ${e.response?.statusCode}");
      log("Error response data: ${e.response?.data}");
    }

    String errorMessage = 'Network error occurred';

    if (e.response != null) {
      final statusCode = e.response?.statusCode;
      final responseData = e.response?.data;

      if (statusCode == 400 || statusCode == 401) {
        errorMessage = responseData?['error'] ?? 'Invalid Google token';
      } else if (statusCode == 500) {
        errorMessage = 'Server error. Please try again later';
      } else {
        errorMessage = responseData?['error'] ?? 'Google authentication failed';
      }
    } else {
      errorMessage =
          'Network connection failed. Please check your internet connection';
    }

    return {'success': false, 'message': errorMessage};
  } catch (e) {
    return {'success': false, 'message': 'Unexpected error occurred'};
  }
}

  Future<Map<String, dynamic>> login({
    required String username,
    required String password,
  }) async {
    try {
      log("Attempting to login with username: $username");
      final response = await dio.post(
        ApiConstants.login,
        data: {"username": username, "password": password},
      );

      log("Response status: ${response.statusCode}");
      log("Response data: ${response.data}");

      if (response.statusCode == 200) {
        return {
          'success': true,
          'data': response.data,
          'message': response.data['message'] ?? 'Login successful',
          'user_type': response.data['user_type'],
          'user_data': response.data['user_data'],
        };
      } else {
        return {
          'success': false,
          'message': response.data['message'] ?? 'Login failed',
        };
      }
    } on DioException catch (e) {
      log("DioException: ${e.message}");
      log("DioException type: ${e.type}");
      if (e.response != null) {
        log("Error response status: ${e.response?.statusCode}");
        log("Error response data: ${e.response?.data}");
      }

      String errorMessage = 'Network error occurred';

      if (e.response != null) {
        final statusCode = e.response?.statusCode;
        final responseData = e.response?.data;

        if (statusCode == 400) {
          errorMessage = responseData?['message'] ?? 'Invalid credentials';
        } else if (statusCode == 401) {
          errorMessage =
              responseData?['message'] ?? 'Invalid username or password';
        } else if (statusCode == 500) {
          errorMessage = 'Server error. Please try again later';
        } else {
          errorMessage = responseData?['message'] ?? 'Login failed';
        }
      } else {
        errorMessage =
            'Network connection failed. Please check your internet connection';
      }

      return {'success': false, 'message': errorMessage};
    } catch (e) {
      return {'success': false, 'message': 'An unexpected error occurred'};
    }
  }
}
