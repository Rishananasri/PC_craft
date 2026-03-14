import 'package:flutter/material.dart';

class PasswordVisibilityController extends ChangeNotifier {
  bool passwordVisible = false;
  bool confirmPasswordVisible = false;

  void togglePassword() {
    passwordVisible = !passwordVisible;
    notifyListeners();
  }

  void toggleConfirmPassword() {
    confirmPasswordVisible = !confirmPasswordVisible;
    notifyListeners();
  }
}