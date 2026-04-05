import 'package:flutter_riverpod/flutter_riverpod.dart';

enum RegisterMode { user, worker }

extension RegisterModeExtension on RegisterMode {
  bool get isUser => this == RegisterMode.user;
  bool get isWorker => this == RegisterMode.worker;
}

class RegisterModeNotifier extends StateNotifier<RegisterMode> {
  RegisterModeNotifier() : super(RegisterMode.user);

  bool get isUser => state == RegisterMode.user;
  bool get isWorker => state == RegisterMode.worker;

  void setMode(RegisterMode mode) {
    if (state == mode) return;
    state = mode;
  }

  void toggle() {
    state = state == RegisterMode.user
        ? RegisterMode.worker
        : RegisterMode.user;
  }
}

final registerModeProvider =
    StateNotifierProvider<RegisterModeNotifier, RegisterMode>((ref) {
      return RegisterModeNotifier();
    });
