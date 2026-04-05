import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pc_craft/presentation/providers/providers.dart';
import 'package:pc_craft/presentation/widgets/auth_widgets/gradient_button.dart';
import 'package:pc_craft/presentation/screens/Auth/login_screen.dart';

class ForgotPasswordScreen extends ConsumerStatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  ConsumerState<ForgotPasswordScreen> createState() =>
      _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends ConsumerState<ForgotPasswordScreen> {
  final TextEditingController emailController = TextEditingController();
  final List<TextEditingController> otpControllers = List.generate(
    6,
    (_) => TextEditingController(),
  );
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController =
      TextEditingController();

  @override
  void dispose() {
    emailController.dispose();
    for (var controller in otpControllers) {
      controller.dispose();
    }
    passwordController.dispose();
    confirmPasswordController.dispose();
    super.dispose();
  }

  void showSnack(String message, bool success) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: success ? Colors.green : Colors.red,
      ),
    );
  }

  void showLoader() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => const Center(child: CircularProgressIndicator()),
    );
  }

  String getOtp() {
    return otpControllers.map((e) => e.text).join();
  }

  @override
  Widget build(BuildContext context) {
    final themeMode = ref.watch(themeProvider);
    final isDark = themeMode == ThemeMode.dark;
    final forgotPasswordState = ref.watch(forgotPasswordProvider);
    final forgotPasswordNotifier = ref.read(forgotPasswordProvider.notifier);

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 25),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 40),
                Text(
                  forgotPasswordState.stage == 1
                      ? "Forgot Password"
                      : forgotPasswordState.stage == 2
                      ? "Enter OTP"
                      : "Reset Password",
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: isDark ? Colors.white : Colors.black,
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  forgotPasswordState.stage == 1
                      ? "Enter your email to receive OTP"
                      : forgotPasswordState.stage == 2
                      ? "Enter the 6-digit code sent to your email"
                      : "Enter your new password",
                  style: TextStyle(
                    fontSize: 16,
                    color: isDark ? Colors.grey[400] : Colors.grey[700],
                  ),
                ),
                const SizedBox(height: 40),

                if (forgotPasswordState.stage == 1) ...[
                  TextField(
                    controller: emailController,
                    decoration: InputDecoration(
                      hintText: "Email",
                      filled: true,
                      fillColor: isDark ? Colors.grey[800] : Colors.grey[100],
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide.none,
                      ),
                    ),
                    onChanged: (value) {
                      forgotPasswordNotifier.updateEmail(value);
                    },
                  ),
                  const SizedBox(height: 30),
                  GradientButton(
                    text: "Send OTP",
                    gradient: LinearGradient(
                      colors: [Colors.cyanAccent.shade400, Colors.blueAccent],
                    ),
                    onPressed: () async {
                      showLoader();
                      final result = await forgotPasswordNotifier.requestOtp();
                      if (mounted) Navigator.pop(context);
                      showSnack(result['message'], result['success']);
                    },
                  ),
                ] else if (forgotPasswordState.stage == 2) ...[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: List.generate(6, (index) {
                      return SizedBox(
                        width: 45,
                        height: 55,
                        child: TextField(
                          controller: otpControllers[index],
                          keyboardType: TextInputType.number,
                          textAlign: TextAlign.center,
                          inputFormatters: [
                            LengthLimitingTextInputFormatter(1),
                          ],
                          decoration: InputDecoration(
                            counterText: '',
                            filled: true,
                            fillColor: isDark
                                ? Colors.grey[800]
                                : Colors.grey[100],
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: BorderSide.none,
                            ),
                          ),
                          onChanged: (value) {
                            forgotPasswordNotifier.updateOtp(getOtp());
                            if (value.isNotEmpty && index < 5) {
                              FocusScope.of(context).nextFocus();
                            }
                            if (value.isEmpty && index > 0) {
                              FocusScope.of(context).previousFocus();
                            }
                          },
                        ),
                      );
                    }),
                  ),
                  const SizedBox(height: 20),
                  TextButton(
                    onPressed: forgotPasswordState.canResend
                        ? () async {
                            final result = await forgotPasswordNotifier
                                .requestOtp();
                            showSnack(result['message'], result['success']);
                          }
                        : null,
                    child: Text(
                      forgotPasswordState.canResend
                          ? 'Resend Code'
                          : 'Resend in ${forgotPasswordState.resendSeconds}s',
                    ),
                  ),
                  const SizedBox(height: 30),
                  GradientButton(
                    text: "Verify OTP",
                    gradient: LinearGradient(
                      colors: [Colors.cyanAccent.shade400, Colors.blueAccent],
                    ),
                    onPressed: () async {
                      showLoader();
                      final result = await forgotPasswordNotifier.verifyOtp();
                      if (mounted) Navigator.pop(context);
                      showSnack(result['message'], result['success']);
                    },
                  ),
                ] else if (forgotPasswordState.stage == 3) ...[
                  TextField(
                    controller: passwordController,
                    obscureText: true,
                    decoration: InputDecoration(
                      hintText: "New Password",
                      filled: true,
                      fillColor: isDark ? Colors.grey[800] : Colors.grey[100],
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide.none,
                      ),
                    ),
                    onChanged: (value) {
                      forgotPasswordNotifier.updatePassword(value);
                    },
                  ),
                  const SizedBox(height: 20),
                  TextField(
                    controller: confirmPasswordController,
                    obscureText: true,
                    decoration: InputDecoration(
                      hintText: "Confirm Password",
                      filled: true,
                      fillColor: isDark ? Colors.grey[800] : Colors.grey[100],
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide.none,
                      ),
                    ),
                    onChanged: (value) {
                      forgotPasswordNotifier.updateConfirmPassword(value);
                    },
                  ),
                  const SizedBox(height: 30),
                  GradientButton(
                    text: "Reset Password",
                    gradient: LinearGradient(
                      colors: [Colors.cyanAccent.shade400, Colors.blueAccent],
                    ),
                    onPressed: () async {
                      showLoader();
                      final result = await forgotPasswordNotifier
                          .resetPassword();
                      if (mounted) Navigator.pop(context);
                      if (result['success']) {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(builder: (_) => LoginScreen()),
                        );
                      }
                      showSnack(result['message'], result['success']);
                    },
                  ),
                ],

                const SizedBox(height: 40),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Remember password?",
                      style: TextStyle(
                        color: isDark ? Colors.grey[400] : Colors.grey,
                      ),
                    ),
                    const SizedBox(width: 5),
                    GestureDetector(
                      onTap: () => Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(builder: (_) => LoginScreen()),
                      ),
                      child: Text(
                        "Login",
                        style: TextStyle(
                          color: isDark
                              ? Colors.cyanAccent.shade400
                              : const Color.fromARGB(255, 0, 174, 255),
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
