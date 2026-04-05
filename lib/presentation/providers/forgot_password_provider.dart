import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'auth_provider.dart';

class ForgotPasswordState {
  final int stage;
  final int resendSeconds;
  final bool isLoading;
  final String? errorMessage;
  final String email;
  final String otp;
  final String password;
  final String confirmPassword;

  const ForgotPasswordState({
    this.stage = 1,
    this.resendSeconds = 0,
    this.isLoading = false,
    this.errorMessage,
    this.email = '',
    this.otp = '',
    this.password = '',
    this.confirmPassword = '',
  });

  bool get canResend => resendSeconds == 0;

  ForgotPasswordState copyWith({
    int? stage,
    int? resendSeconds,
    bool? isLoading,
    String? errorMessage,
    String? email,
    String? otp,
    String? password,
    String? confirmPassword,
  }) {
    return ForgotPasswordState(
      stage: stage ?? this.stage,
      resendSeconds: resendSeconds ?? this.resendSeconds,
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage ?? this.errorMessage,
      email: email ?? this.email,
      otp: otp ?? this.otp,
      password: password ?? this.password,
      confirmPassword: confirmPassword ?? this.confirmPassword,
    );
  }
}

class ForgotPasswordNotifier extends StateNotifier<ForgotPasswordState> {
  final AuthNotifier _authNotifier;
  Timer? _timer;

  ForgotPasswordNotifier(this._authNotifier)
    : super(const ForgotPasswordState());

  void updateEmail(String email) {
    state = state.copyWith(email: email);
  }

  void updateOtp(String otp) {
    state = state.copyWith(otp: otp);
  }

  void updatePassword(String password) {
    state = state.copyWith(password: password);
  }

  void updateConfirmPassword(String confirmPassword) {
    state = state.copyWith(confirmPassword: confirmPassword);
  }

  void changeStage(int value) {
    state = state.copyWith(stage: value, errorMessage: null);
  }

  void startResendTimer() {
    state = state.copyWith(resendSeconds: 30);
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (state.resendSeconds > 0) {
        state = state.copyWith(resendSeconds: state.resendSeconds - 1);
      } else {
        timer.cancel();
      }
    });
  }

  Future<Map<String, dynamic>> requestOtp() async {
    if (state.email.isEmpty) {
      state = state.copyWith(errorMessage: "Please enter your email");
      return {"success": false, "message": "Please enter your email"};
    }

    state = state.copyWith(isLoading: true, errorMessage: null);

    final result = await _authNotifier.requestPasswordReset(email: state.email);

    if (result['success'] == true) {
      state = state.copyWith(isLoading: false, stage: 2);
      startResendTimer();
    } else {
      state = state.copyWith(isLoading: false, errorMessage: result['message']);
    }

    return result;
  }

  Future<Map<String, dynamic>> verifyOtp() async {
    if (state.otp.length < 6) {
      state = state.copyWith(errorMessage: "Enter full OTP");
      return {"success": false, "message": "Enter full OTP"};
    }

    state = state.copyWith(isLoading: true, errorMessage: null);

    final result = await _authNotifier.verifyOtp(
      email: state.email,
      otp: state.otp,
    );

    if (result['success'] == true) {
      state = state.copyWith(isLoading: false, stage: 3);
    } else {
      state = state.copyWith(isLoading: false, errorMessage: result['message']);
    }

    return result;
  }

  Future<Map<String, dynamic>> resetPassword() async {
    if (state.password.isEmpty || state.confirmPassword.isEmpty) {
      state = state.copyWith(errorMessage: "Please fill password fields");
      return {"success": false, "message": "Please fill password fields"};
    }

    if (state.password != state.confirmPassword) {
      state = state.copyWith(errorMessage: "Passwords do not match");
      return {"success": false, "message": "Passwords do not match"};
    }

    state = state.copyWith(isLoading: true, errorMessage: null);

    final result = await _authNotifier.changePasswordWithOtp(
      email: state.email,
      otp: state.otp,
      password: state.password,
      confirmPassword: state.confirmPassword,
    );

    state = state.copyWith(isLoading: false);

    return result;
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }
}

final forgotPasswordProvider =
    StateNotifierProvider<ForgotPasswordNotifier, ForgotPasswordState>((ref) {
      final authNotifier = ref.watch(authProvider.notifier);
      return ForgotPasswordNotifier(authNotifier);
    });
