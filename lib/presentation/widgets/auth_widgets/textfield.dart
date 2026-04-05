import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pc_craft/presentation/providers/providers.dart';

class FormFields extends ConsumerWidget {
  final TextEditingController controller;
  final String hint;
  final bool isPassword;
  final bool isConfirmPassword;
  final String? Function(String?)? validator;
  final ValueChanged<String>? onChanged;
  final void Function(BuildContext, String)? onChangedWithContext;

  const FormFields({
    required this.controller,
    required this.hint,
    this.isPassword = false,
    this.isConfirmPassword = false,
    this.validator,
    this.onChanged,
    this.onChangedWithContext,
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeMode = ref.watch(themeProvider);
    final isDark = themeMode == ThemeMode.dark;
    final visibilityState = ref.watch(passwordVisibilityProvider);

    final bool obscureText = isPassword
        ? !visibilityState.passwordVisible
        : isConfirmPassword
        ? !visibilityState.confirmPasswordVisible
        : false;

    return TextFormField(
      controller: controller,
      obscureText: obscureText,
      validator: validator,
      onChanged: onChangedWithContext != null
          ? (value) => onChangedWithContext!(context, value)
          : onChanged,
      decoration: InputDecoration(
        hintText: hint,
        filled: true,
        fillColor: isDark
            ? Colors.grey[800]
            : const Color.fromARGB(255, 236, 235, 235),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(25),
          borderSide: BorderSide.none,
        ),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 20,
          vertical: 18,
        ),
        suffixIcon: (isPassword || isConfirmPassword)
            ? IconButton(
                icon: Icon(
                  obscureText ? Icons.visibility_off : Icons.visibility,
                  color: Colors.grey,
                ),
                onPressed: () {
                  if (isPassword) {
                    ref
                        .read(passwordVisibilityProvider.notifier)
                        .togglePassword();
                  } else {
                    ref
                        .read(passwordVisibilityProvider.notifier)
                        .toggleConfirmPassword();
                  }
                },
              )
            : null,
      ),
    );
  }
}
