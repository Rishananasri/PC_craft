import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pc_craft/presentation/providers/providers.dart';
import 'package:pc_craft/presentation/screens/Auth/forgot_password_screen.dart';
import 'package:pc_craft/presentation/screens/Auth/register_screen.dart';
import 'package:pc_craft/presentation/widgets/auth_widgets/google_button.dart';
import 'package:pc_craft/presentation/widgets/auth_widgets/gradient_button.dart';
import 'package:pc_craft/presentation/widgets/auth_widgets/textfield.dart';
import 'package:pc_craft/presentation/screens/home_screen.dart';

class LoginScreen extends ConsumerWidget {
  LoginScreen({super.key});

  final TextEditingController usernameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeMode = ref.watch(themeProvider);
    final isDark = themeMode == ThemeMode.dark;

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 25),
          child: Column(
            children: [
              const SizedBox(height: 100),

              Center(
                child: Column(
                  children: [
                    Text(
                      "Welcome Back",
                      style: TextStyle(
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                        color: isDark ? Colors.white : Colors.black,
                      ),
                    ),
                    const SizedBox(height: 5),
                    Text(
                      "Login to continue",
                      style: TextStyle(
                        fontSize: 16,
                        color: isDark ? Colors.grey[400] : Colors.grey[700],
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 60),

              Card(
                elevation: 2,
                shadowColor: Colors.black12,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(25),
                ),
                color: isDark ? Colors.grey[900] : Colors.white,
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 22,
                    vertical: 30,
                  ),
                  child: Column(
                    children: [
                      FormFields(
                        controller: usernameController,
                        hint: "Email or Username",
                      ),
                      const SizedBox(height: 20),
                      FormFields(
                        controller: passwordController,
                        hint: "Password",
                        isPassword: true,
                      ),
                      const SizedBox(height: 10),
                      Align(
                        alignment: Alignment.centerRight,
                        child: GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => const ForgotPasswordScreen(),
                              ),
                            );
                          },
                          child: Text(
                            "Forgot Password?",
                            style: TextStyle(
                              color: isDark ? Colors.redAccent : Colors.red,
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 30),

              GradientButton(
                text: "Login",
                gradient: LinearGradient(
                  colors: [Colors.cyanAccent.shade400, Colors.blueAccent],
                ),
                onPressed: () async {
                  final authNotifier = ref.read(authProvider.notifier);

                  if (usernameController.text.trim().isEmpty ||
                      passwordController.text.trim().isEmpty) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text("Please fill in all fields"),
                        backgroundColor: Colors.red,
                      ),
                    );
                    return;
                  }

                  showDialog(
                    context: context,
                    barrierDismissible: false,
                    builder: (_) =>
                        const Center(child: CircularProgressIndicator()),
                  );

                  final result = await authNotifier.login(
                    username: usernameController.text.trim(),
                    password: passwordController.text.trim(),
                  );

                  if (!context.mounted) return;
                  Navigator.of(context).pop();

                  if (result['success'] == true) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(result['message']),
                        backgroundColor: Colors.green,
                      ),
                    );
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const HomeScreen(),
                      ),
                    );
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(result['message']),
                        backgroundColor: Colors.red,
                      ),
                    );
                  }
                },
              ),

              const SizedBox(height: 15),
              const GoogleButton(),
              const Spacer(),

              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Don't have an account?",
                    style: TextStyle(
                      color: isDark ? Colors.grey[400] : Colors.grey,
                    ),
                  ),
                  const SizedBox(width: 5),
                  GestureDetector(
                    onTap: () => Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (_) => RegisterScreen()),
                    ),
                    child: Text(
                      "Register",
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

              const SizedBox(height: 25),
            ],
          ),
        ),
      ),
    );
  }
}
