import 'package:flutter/material.dart';
import 'package:pc_craft/controller/pass_visibility_controller.dart';
import 'package:pc_craft/controller/password_strength_controller.dart';
import 'package:pc_craft/controller/register_mode_controller.dart';
import 'package:pc_craft/controller/theme_controller.dart';
import 'package:pc_craft/view/screens/Auth/login_screen.dart';
import 'package:pc_craft/view/screens/Auth/widgets/google_button.dart';
import 'package:pc_craft/view/screens/Auth/widgets/gradient_button.dart';
import 'package:pc_craft/view/screens/Auth/widgets/register_header.dart';
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

  String? _validateName(String? value) {
    if (value == null || value.isEmpty) {
      return 'Full name is required';
    }
    return null;
  }

  String? _validateUsername(String? value) {
    if (value == null || value.isEmpty) {
      return 'Username is required';
    }
    return null;
  }

  String? _validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return 'Email is required';
    }
    if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value)) {
      return 'Enter a valid email address';
    }
    return null;
  }

  String? _validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Password is required';
    }
    if (value.length < 8) {
      return 'Password must be at least 8 characters long';
    }
    if (!RegExp(r'[A-Z]').hasMatch(value)) {
      return 'Password must contain at least one uppercase letter';
    }
    if (!RegExp(r'[!@#$%^&*(),.?":{}|<>]').hasMatch(value)) {
      return 'Password must contain at least one special character';
    }
    if (!RegExp(r'[0-9]').hasMatch(value)) {
      return 'Password must contain at least one number';
    }
    return null;
  }

  String? _validateConfirmPassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please confirm your password';
    }
    if (value != passwordController.text) {
      return 'Passwords do not match';
    }
    return null;
  }

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
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const SizedBox(height: 50),
                // Top row: Logo + Theme toggle
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Padding(
                      padding: EdgeInsets.only(left: 100),
                      child: Header(),
                    ),
                    // Temporary theme toggle button
                    IconButton(
                      icon: Icon(
                        theme.isDark ? Icons.light_mode : Icons.dark_mode,
                        color: theme.isDark ? Colors.white : Colors.black,
                      ),
                      onPressed: () => theme.toggleTheme(),
                    ),
                  ],
                ),
                const SizedBox(height: 30),

                _RegisterModeToggle(),

                Card(
                  elevation: 1,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(25),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        children: [
                          FormFields(
                            controller: nameController,
                            hint: "Full Name",
                            validator: _validateName,
                          ),
                          const SizedBox(height: 15),
                          FormFields(
                            controller: usernameController,
                            hint: "Username",
                            validator: _validateUsername,
                          ),
                          const SizedBox(height: 15),
                          FormFields(
                            controller: emailController,
                            hint: "Email",
                            validator: _validateEmail,
                          ),
                          const SizedBox(height: 15),
                          FormFields(
                            controller: passwordController,
                            hint: "Password",
                            isPassword: true,
                            validator: _validatePassword,
                            onChangedWithContext: (context, value) => context
                                .read<PasswordStrengthController>()
                                .updatePassword(value),
                          ),
                          const SizedBox(height: 10),
                          _PasswordStrengthIndicator(),
                          const SizedBox(height: 15),
                          FormFields(
                            controller: confirmPasswordController,
                            hint: "Confirm Password",
                            isConfirmPassword: true,
                            validator: _validateConfirmPassword,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                Consumer<RegisterModeController>(
                  builder: (context, mode, child) {
                    return GradientButton(
                      text: mode.isUser
                          ? "Sign Up as User"
                          : "Sign Up as Worker",
                      onPressed: () {
                        if (_formKey.currentState!.validate()) {
                          // Proceed with registration
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(
                                mode.isUser
                                    ? 'User registration successful!'
                                    : 'Worker registration successful!',
                              ),
                            ),
                          );
                        }
                      },
                      gradient: LinearGradient(
                        colors: [Colors.cyanAccent.shade400, Colors.blueAccent],
                      ),
                    );
                  },
                ),
                const SizedBox(height: 15),
                const GoogleButton(),
                const SizedBox(height: 30),

                // Footer
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Already have an account?",
                      style: TextStyle(
                        color: theme.isDark ? Colors.grey[400] : Colors.grey,
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

    // Only show the indicator while the user is actively typing a password.
    if (strengthController.isEmpty) return const SizedBox.shrink();

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

    return Center(
      child: LayoutBuilder(
        builder: (context, constraints) {
          // Reduce overall width so toggle doesn't span too far across the form
          final width = (constraints.maxWidth * 0.75).clamp(240.0, 340.0);
          const height = 44.0;
          final handleWidth = width * 0.48;

          return GestureDetector(
            onTap: mode.toggle,
            child: Container(
              width: width,
              height: height,
              decoration: BoxDecoration(
                color: Colors.grey.shade200,
                borderRadius: BorderRadius.circular(30),
              ),
              child: Stack(
                children: [
                  AnimatedPositioned(
                    duration: const Duration(milliseconds: 220),
                    curve: Curves.easeInOut,
                    left: mode.isUser ? 2 : width - handleWidth - 2,
                    top: 2,
                    bottom: 2,
                    child: Container(
                      width: handleWidth,
                      decoration: BoxDecoration(
                        color: Colors.blueAccent,
                        borderRadius: BorderRadius.circular(28),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            mode.isUser ? Icons.person : Icons.engineering,
                            size: 18,
                            color: Colors.white,
                          ),
                        ],
                      ),
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      _ModeLabel(label: 'User', selected: mode.isUser),
                      _ModeLabel(label: 'Worker', selected: mode.isWorker),
                    ],
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

class _ModeLabel extends StatelessWidget {
  const _ModeLabel({required this.label, required this.selected});

  final String label;
  final bool selected;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Center(
        child: Text(
          label,
          style: TextStyle(
            color: selected ? Colors.white : Colors.black54,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }
}
