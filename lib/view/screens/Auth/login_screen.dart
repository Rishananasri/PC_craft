import 'package:flutter/material.dart';
import 'package:pc_craft/controller/theme_controller.dart';
import 'package:pc_craft/controller/pass_visibility_controller.dart';
import 'package:pc_craft/view/screens/Auth/register_screen.dart';
import 'package:pc_craft/view/screens/Auth/widgets/google_button.dart';
import 'package:pc_craft/view/screens/Auth/widgets/gradient_button.dart';
import 'package:pc_craft/view/screens/Auth/widgets/register_header.dart';
import 'package:pc_craft/view/screens/Auth/widgets/textfield.dart';
import 'package:provider/provider.dart';

class LoginScreen extends StatelessWidget {
  LoginScreen({super.key});

  final TextEditingController usernameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final theme = context.watch<ThemeController>();

    return Scaffold(
      body: SafeArea(
        child: ChangeNotifierProvider(
          create: (_) => PasswordVisibilityController(),
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 30),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const SizedBox(height: 40),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Header(),
                    IconButton(
                      icon: Icon(
                        theme.isDark ? Icons.light_mode : Icons.dark_mode,
                        color: theme.isDark ? Colors.white : Colors.black,
                      ),
                      onPressed: () => theme.toggleTheme(),
                    ),
                  ],
                ),
                const SizedBox(height: 50),

                // Taller Card
                Card(
                  elevation: 8,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                  color: theme.isDark ? Colors.grey[850] : Colors.white,
                  shadowColor: const Color.fromARGB(
                    40,
                    0,
                    0,
                    0,
                  ).withOpacity(0.25),
                  child: Container(
                    // Set a minimum height
                    constraints: const BoxConstraints(minHeight: 250),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 25,
                      vertical: 40,
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        FormFields(
                          controller: usernameController,
                          hint: "Username",
                        ),
                        const SizedBox(height: 25), // more space between fields
                        FormFields(
                          controller: passwordController,
                          hint: "Password",
                          isPassword: true,
                        ),
                        const SizedBox(height: 10),
                        Align(
                          alignment: Alignment.centerRight,
                          child: Text(
                            "Forgot Password?",
                            style: TextStyle(
                              color: Colors.red,
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 25),

                // Gradient Login Button
                GradientButton(
                  text: "Login",
                  onPressed: () {},
                  gradient: LinearGradient(
                    colors: [Colors.cyanAccent.shade400, Colors.blueAccent],
                  ),
                ),
                const SizedBox(height: 15),

                // Google Button
                const GoogleButton(),
                const SizedBox(height: 35),

                // Footer
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Don't have an account?",
                      style: TextStyle(
                        color: theme.isDark ? Colors.grey[400] : Colors.grey,
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
                          color: theme.isDark
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
