import 'package:flutter/material.dart';
import 'package:pc_craft/controller/theme_controller.dart';
import 'package:pc_craft/controller/pass_visibility_controller.dart';
import 'package:pc_craft/view/screens/Auth/register_screen.dart';
import 'package:pc_craft/view/screens/Auth/widgets/google_button.dart';
import 'package:pc_craft/view/screens/Auth/widgets/gradient_button.dart';
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
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 25),
            child: Column(
              children: [
                const SizedBox(height: 30),

                /// Theme toggle
                Align(
                  alignment: Alignment.topRight,
                  child: IconButton(
                    icon: Icon(
                      theme.isDark ? Icons.light_mode : Icons.dark_mode,
                      color: theme.isDark ? Colors.white : Colors.black,
                    ),
                    onPressed: () => theme.toggleTheme(),
                  ),
                ),

                const SizedBox(height: 40),

                /// Welcome Text
                Center(
                  child: Column(
                    children: [
                      Text(
                        "Welcome Back",
                        style: TextStyle(
                          fontSize: 32,
                          fontWeight: FontWeight.bold,
                          color: theme.isDark ? Colors.white : Colors.black,
                        ),
                      ),
                      const SizedBox(height: 5),
                      Text(
                        "Login to continue",
                        style: TextStyle(
                          fontSize: 16,
                          color: theme.isDark
                              ? Colors.grey[400]
                              : Colors.grey[700],
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 60),

                /// Login Card
                Card(
                  elevation: 2, // reduced shadow
                  shadowColor: Colors.black12,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(25),
                  ),
                  color: theme.isDark ? Colors.grey[900] : Colors.white,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 22,
                      vertical: 30,
                    ),
                    child: Column(
                      children: [
                        FormFields(
                          controller: usernameController,
                          hint: "Username",
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
                          child: Text(
                            "Forgot Password?",
                            style: TextStyle(
                              color: theme.isDark
                                  ? Colors.redAccent
                                  : Colors.red,
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 30),

                /// Login Button
                GradientButton(
                  text: "Login",
                  onPressed: () {},
                  gradient: LinearGradient(
                    colors: [Colors.cyanAccent.shade400, Colors.blueAccent],
                  ),
                ),

                const SizedBox(height: 15),

                /// Google Login
                const GoogleButton(),

                const Spacer(),

                /// Register Link
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

                const SizedBox(height: 25),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
