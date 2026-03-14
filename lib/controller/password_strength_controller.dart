import 'package:flutter/material.dart';

class PasswordStrengthController extends ChangeNotifier {
  String _password = '';

  void updatePassword(String password) {
    _password = password;
    notifyListeners();
  }

  bool get isEmpty => _password.isEmpty;

  String get password => _password;

  List<Color> get strengthColors {
    int count = 0;
    if (_password.length >= 8) count++;
    if (RegExp(r'[A-Z]').hasMatch(_password)) count++;
    if (RegExp(r'[!@#$%^&*(),.?":{}|<>]').hasMatch(_password)) count++;
    if (RegExp(r'[0-9]').hasMatch(_password)) count++;

    if (count == 1) {
      return [
        Colors.red,
        Colors.grey.shade300,
        Colors.grey.shade300,
        Colors.grey.shade300,
      ];
    }
    if (count == 2) {
      return [
        Colors.red,
        Colors.red,
        Colors.grey.shade300,
        Colors.grey.shade300,
      ];
    }
    if (count == 3) {
      return [
        Colors.yellow,
        Colors.yellow,
        Colors.yellow,
        Colors.grey.shade300,
      ];
    }
    if (count == 4) {
      return [Colors.green, Colors.green, Colors.green, Colors.green];
    }
    return [
      Colors.grey.shade300,
      Colors.grey.shade300,
      Colors.grey.shade300,
      Colors.grey.shade300,
    ];
  }
}
