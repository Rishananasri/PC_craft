import 'package:flutter/material.dart';

enum RegisterMode { user, worker }

class RegisterModeController extends ChangeNotifier {
  RegisterMode _mode = RegisterMode.user;

  RegisterMode get mode => _mode;

  bool get isUser => _mode == RegisterMode.user;
  bool get isWorker => _mode == RegisterMode.worker;

  void setMode(RegisterMode mode) {
    if (_mode == mode) return;
    _mode = mode;
    notifyListeners();
  }

  void toggle() {
    setMode(
      _mode == RegisterMode.user ? RegisterMode.worker : RegisterMode.user,
    );
  }
}
