import 'package:flutter/material.dart';
import 'package:pc_craft/controller/pass_visibility_controller.dart';
import 'package:pc_craft/controller/password_strength_controller.dart';
import 'package:pc_craft/controller/register_mode_controller.dart';
import 'package:pc_craft/controller/theme_controller.dart';
import 'package:pc_craft/services/api_service.dart';
import 'package:pc_craft/utils/validators/register_validator.dart';
import 'package:pc_craft/view/screens/Auth/login_screen.dart';
import 'package:pc_craft/view/screens/Auth/widgets/google_button.dart';
import 'package:pc_craft/view/screens/Auth/widgets/gradient_button.dart';
import 'package:pc_craft/view/screens/Auth/widgets/textfield.dart';
import 'package:provider/provider.dart';

class RegisterScreen extends StatelessWidget {
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
  Widget build(BuildContext context) {
    final theme = context.watch<ThemeController>();

    return Scaffold(
      body: SafeArea(
        child: MultiProvider(
          providers: [
            ChangeNotifierProvider(create: (_) => RegisterModeController()),
            ChangeNotifierProvider(create: (_) => PasswordStrengthController()),
            ChangeNotifierProvider(
              create: (_) => PasswordVisibilityController(),
            ),
          ],
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 25),
            child: Consumer<RegisterModeController>(
              builder: (context, mode, child) {
                return Column(
                  children: [
                    const SizedBox(height: 30),
                    const SizedBox(height: 20),

                    /// TITLE
                    Text(
                      mode.isUser ? "Register as User" : "Register as Worker",
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: theme.isDark ? Colors.white : Colors.black,
                      ),
                    ),

                    const SizedBox(height: 5),

                    /// SUBTITLE
                    Text(
                      "Create your account in minutes",
                      style: TextStyle(
                        fontSize: 16,
                        color: theme.isDark
                            ? Colors.grey[400]
                            : Colors.grey[700],
                      ),
                    ),

                    const SizedBox(height: 25),

                    /// USER / WORKER TOGGLE
                    const _RegisterModeToggle(),

                    const SizedBox(height: 25),

                    /// FORM CARD
                    Card(
                      elevation: 2,
                      shadowColor: Colors.black12,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(25),
                      ),
                      color: theme.isDark ? Colors.grey[900] : Colors.white,
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
                                  context
                                      .read<PasswordStrengthController>()
                                      .updatePassword(value);
                                },
                              ),

                              const SizedBox(height: 8),

                              const _PasswordStrengthIndicator(),

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

                    /// CREATE ACCOUNT BUTTON
                    GradientButton(
                      text: "Create Account",
                      gradient: LinearGradient(
                        colors: [Colors.cyanAccent.shade400, Colors.blueAccent],
                      ),
                      onPressed: () async {
                        if (_formKey.currentState!.validate()) {
                          final authService = AuthService();

                          try {
                            if (mode.isUser) {
                              await authService.registerUser(
                                name: nameController.text.trim(),
                                username: usernameController.text.trim(),
                                email: emailController.text.trim(),
                                password: passwordController.text.trim(),
                                confirmpassword: confirmPasswordController.text
                                    .trim(),
                              );

                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text("User registered successfully"),
                                ),
                              );
                            } else {
                              await authService.registerWorker(
                                name: nameController.text.trim(),
                                username: usernameController.text.trim(),
                                email: emailController.text.trim(),
                                password: passwordController.text.trim(),
                                confirmpassword: confirmPasswordController.text
                                    .trim(),
                              );

                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text(
                                    "Worker registered successfully",
                                  ),
                                ),
                              );
                            }
                          } catch (e) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text("Registration failed"),
                              ),
                            );
                          }
                        }
                      },
                    ),

                    const SizedBox(height: 15),

                    const GoogleButton(),

                    const Spacer(),

                    /// LOGIN LINK
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "Already have an account?",
                          style: TextStyle(
                            color: theme.isDark
                                ? Colors.grey[400]
                                : Colors.grey,
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
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}

class _PasswordStrengthIndicator extends StatelessWidget {
  const _PasswordStrengthIndicator();

  @override
  Widget build(BuildContext context) {
    final strengthController = context.watch<PasswordStrengthController>();

    if (strengthController.isEmpty) return const SizedBox();

    return Row(
      children: List.generate(4, (index) {
        return Expanded(
          child: Container(
            height: 4,
            margin: const EdgeInsets.symmetric(horizontal: 2),
            decoration: BoxDecoration(
              color: strengthController.strengthColors[index],
              borderRadius: BorderRadius.circular(2),
            ),
          ),
        );
      }),
    );
  }
}

class _RegisterModeToggle extends StatelessWidget {
  const _RegisterModeToggle();

  @override
  Widget build(BuildContext context) {
    final mode = context.watch<RegisterModeController>();

    return GestureDetector(
      onTap: mode.toggle,
      child: Container(
        width: 250,
        height: 42,
        decoration: BoxDecoration(
          color: Colors.grey.shade200,
          borderRadius: BorderRadius.circular(25),
        ),
        child: Stack(
          children: [
            AnimatedAlign(
              duration: const Duration(milliseconds: 250),
              alignment: mode.isUser
                  ? Alignment.centerLeft
                  : Alignment.centerRight,
              child: Container(
                width: 125,
                decoration: BoxDecoration(
                  color: Colors.blue,
                  borderRadius: BorderRadius.circular(25),
                ),
              ),
            ),
            Row(
              children: [
                Expanded(
                  child: Center(
                    child: Text(
                      "User",
                      style: TextStyle(
                        color: mode.isUser ? Colors.white : Colors.black54,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: Center(
                    child: Text(
                      "Worker",
                      style: TextStyle(
                        color: mode.isWorker ? Colors.white : Colors.black54,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
