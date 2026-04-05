import 'package:flutter_riverpod/flutter_riverpod.dart';

class PasswordVisibilityState {
  final bool passwordVisible;
  final bool confirmPasswordVisible;

  const PasswordVisibilityState({
    this.passwordVisible = false,
    this.confirmPasswordVisible = false,
  });

  PasswordVisibilityState copyWith({
    bool? passwordVisible,
    bool? confirmPasswordVisible,
  }) {
    return PasswordVisibilityState(
      passwordVisible: passwordVisible ?? this.passwordVisible,
      confirmPasswordVisible:
          confirmPasswordVisible ?? this.confirmPasswordVisible,
    );
  }
}

class PasswordVisibilityNotifier
    extends StateNotifier<PasswordVisibilityState> {
  PasswordVisibilityNotifier() : super(const PasswordVisibilityState());

  void togglePassword() {
    state = state.copyWith(passwordVisible: !state.passwordVisible);
  }

  void toggleConfirmPassword() {
    state = state.copyWith(
      confirmPasswordVisible: !state.confirmPasswordVisible,
    );
  }
}

final passwordVisibilityProvider =
    StateNotifierProvider<PasswordVisibilityNotifier, PasswordVisibilityState>((
      ref,
    ) {
      return PasswordVisibilityNotifier();
    });
