import 'package:flutter/material.dart';

class PasswordStrengthController extends ChangeNotifier {
  String _password = '';

  void updatePassword(String password) {
    _password = password;
    notifyListeners();
  }

  bool get isEmpty => _password.isEmpty;

  String get password => _password;

  int get strengthCount {
    int count = 0;
    if (_password.length >= 8) count++;
    if (RegExp(r'[A-Z]').hasMatch(_password)) count++;
    if (RegExp(r'[!@#$%^&*(),.?":{}|<>]').hasMatch(_password)) count++;
    if (RegExp(r'[0-9]').hasMatch(_password)) count++;
    return count;
  }

  double get strength => strengthCount / 4;

  Color get strengthColor {
    switch (strengthCount) {
      case 1:
        return Colors.red;
      case 2:
        return Colors.orange;
      case 3:
        return Colors.yellow.shade700;
      case 4:
        return Colors.green;
      default:
        return Colors.grey.shade300;
    }
  }

  String get strengthLabel {
    switch (strengthCount) {
      case 1:
        return "Very Weak";
      case 2:
        return "Weak";
      case 3:
        return "Medium";
      case 4:
        return "Strong";
      default:
        return "";
    }
  }

  List<Color> get strengthColors {
    final count = strengthCount;

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
