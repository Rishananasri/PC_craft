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
  Future registerUser({
    required String name,
    required String username,
    required String email,
    required String password,
    required String confirmpassword,
  }) async {
    try {
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

      return response.data;
    } catch (e) {
      print("User Register Error: $e");
    }
  }

  /// REGISTER WORKER
  Future registerWorker({
    required String name,
    required String username,
    required String email,
    required String password,
    required String confirmpassword,
  }) async {
    try {
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

      return response.data;
    } catch (e) {
      print("Worker Register Error: $e");
    }
  }
}
