import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class PasswordStrengthState {
  final String password;

  const PasswordStrengthState({this.password = ''});

  bool get isEmpty => password.isEmpty;

  int get strengthCount {
    int count = 0;
    if (password.length >= 8) count++;
    if (RegExp(r'[A-Z]').hasMatch(password)) count++;
    if (RegExp(r'[!@#$%^&*(),.?":{}|<>]').hasMatch(password)) count++;
    if (RegExp(r'[0-9]').hasMatch(password)) count++;
    return count;
  }

  bool get hasMinLength => password.length >= 8;
  bool get hasUppercase => password.contains(RegExp(r'[A-Z]'));
  bool get hasNumber => password.contains(RegExp(r'[0-9]'));
  bool get hasSpecialChar =>
      password.contains(RegExp(r'[!@#$%^&*(),.?":{}|<>]'));
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
}

class PasswordStrengthNotifier extends StateNotifier<PasswordStrengthState> {
  PasswordStrengthNotifier() : super(const PasswordStrengthState());

  void updatePassword(String password) {
    state = PasswordStrengthState(password: password);
  }

  void reset() {
    state = const PasswordStrengthState();
  }
}

final passwordStrengthProvider =
    StateNotifierProvider<PasswordStrengthNotifier, PasswordStrengthState>((
      ref,
    ) {
      return PasswordStrengthNotifier();
    });
