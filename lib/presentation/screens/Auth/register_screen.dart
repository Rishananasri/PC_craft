import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pc_craft/presentation/providers/providers.dart';
import 'package:pc_craft/presentation/screens/Auth/login_screen.dart';
import 'package:pc_craft/presentation/widgets/auth_widgets/google_button.dart';
import 'package:pc_craft/presentation/widgets/auth_widgets/gradient_button.dart';
import 'package:pc_craft/presentation/widgets/auth_widgets/pass_strength_indecator.dart';
import 'package:pc_craft/presentation/widgets/auth_widgets/registermode_toggle.dart';
import 'package:pc_craft/presentation/widgets/auth_widgets/textfield.dart';
import 'package:pc_craft/presentation/screens/home_screen.dart';

class RegisterScreen extends ConsumerWidget {
  RegisterScreen({
    super.key,
    TextEditingController? nameController,
    TextEditingController? usernameController,
    TextEditingController? emailController,
    TextEditingController? passwordController,
    TextEditingController? confirmPasswordController,
  }) : nameController = nameController ?? TextEditingController(),
       usernameController = usernameController ?? TextEditingController(),
       emailController = emailController ?? TextEditingController(),
       passwordController = passwordController ?? TextEditingController(),
       confirmPasswordController =
           confirmPasswordController ?? TextEditingController();

  final TextEditingController nameController;
  final TextEditingController usernameController;
  final TextEditingController emailController;
  final TextEditingController passwordController;
  final TextEditingController confirmPasswordController;

  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeMode = ref.watch(themeProvider);
    final isDark = themeMode == ThemeMode.dark;
    final mode = ref.watch(registerModeProvider);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(passwordStrengthProvider.notifier).reset();
    });

    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.only(bottom: 20),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 25),
            child: Column(
              children: [
                const SizedBox(height: 30),

                Text(
                  mode.isUser ? "Register as User" : "Register as Worker",
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: isDark ? Colors.white : Colors.black,
                  ),
                ),

                const SizedBox(height: 5),

                Text(
                  "Create your account in minutes",
                  style: TextStyle(
                    fontSize: 16,
                    color: isDark ? Colors.grey[400] : Colors.grey[700],
                  ),
                ),

                const SizedBox(height: 25),

                const RegisterModeToggle(),

                const SizedBox(height: 25),

                Card(
                  elevation: 1,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(25),
                  ),
                  color: isDark ? Colors.grey[900] : Colors.white,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 25,
                    ),
                    child: Form(
                      key: _formKey,
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      child: Column(
                        children: [
                          FormFields(
                            controller: nameController,
                            hint: "Full Name",
                            validator: RegisterValidators.validateName,
                          ),
                          const SizedBox(height: 12),

                          FormFields(
                            controller: usernameController,
                            hint: "Username",
                            validator: RegisterValidators.validateUsername,
                          ),
                          const SizedBox(height: 12),

                          FormFields(
                            controller: emailController,
                            hint: "Email",
                            validator: RegisterValidators.validateEmail,
                          ),
                          const SizedBox(height: 12),

                          FormFields(
                            controller: passwordController,
                            hint: "Password",
                            isPassword: true,
                            validator: RegisterValidators.validatePassword,
                            onChangedWithContext: (context, value) {
                              ref
                                  .read(passwordStrengthProvider.notifier)
                                  .updatePassword(value);
                            },
                          ),

                          const SizedBox(height: 8),
                          const PasswordStrengthIndicator(),
                          const SizedBox(height: 12),

                          FormFields(
                            controller: confirmPasswordController,
                            hint: "Confirm Password",
                            isConfirmPassword: true,
                            validator: (value) =>
                                RegisterValidators.validateConfirmPassword(
                                  value,
                                  passwordController.text,
                                ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 25),

                GradientButton(
                  text: "Create Account",
                  gradient: LinearGradient(
                    colors: [Colors.cyanAccent.shade400, Colors.blueAccent],
                  ),
                  onPressed: () async {
                    final authNotifier = ref.read(authProvider.notifier);

                    if (!_formKey.currentState!.validate()) return;

                    showDialog(
                      context: context,
                      barrierDismissible: false,
                      builder: (_) =>
                          const Center(child: CircularProgressIndicator()),
                    );

                    try {
                      final result = mode.isUser
                          ? await authNotifier.registerUser(
                              name: nameController.text.trim(),
                              username: usernameController.text.trim(),
                              email: emailController.text.trim(),
                              password: passwordController.text.trim(),
                              confirmpassword: confirmPasswordController.text
                                  .trim(),
                            )
                          : await authNotifier.registerWorker(
                              name: nameController.text.trim(),
                              username: usernameController.text.trim(),
                              email: emailController.text.trim(),
                              password: passwordController.text.trim(),
                              confirmpassword: confirmPasswordController.text
                                  .trim(),
                            );

                      if (!context.mounted) return;
                      Navigator.pop(context);

                      final messenger = ScaffoldMessenger.of(context);
                      messenger.showSnackBar(
                        SnackBar(
                          content: Text(result['message']),
                          backgroundColor: result['success']
                              ? Colors.green
                              : Colors.red,
                        ),
                      );

                      if (result['success']) {
                        final token =
                            result['data']?['access'] ??
                            result['data']?['token'];
                        if (token != null) {
                          await authNotifier.setToken(
                            token,
                            userType: result['data']?['user']?['role'],
                            userData: result['data']?['user'],
                          );
                          if (!context.mounted) return;
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                              builder: (_) => const HomeScreen(),
                            ),
                          );
                        }
                      }
                    } catch (e) {
                      Navigator.pop(context);
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text("Something went wrong"),
                          backgroundColor: Colors.red,
                        ),
                      );
                    }
                  },
                ),

                const SizedBox(height: 15),

                const GoogleButton(),

                const SizedBox(height: 20),

                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Already have an account?",
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

                const SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
