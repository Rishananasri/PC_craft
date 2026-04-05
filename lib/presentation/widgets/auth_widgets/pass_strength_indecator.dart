import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pc_craft/presentation/providers/providers.dart';

/// ========= PASSWORD STRENGTH INDICATOR===============
class PasswordStrengthIndicator extends ConsumerWidget {
  const PasswordStrengthIndicator({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final passwordStrengthState = ref.watch(passwordStrengthProvider);

    if (passwordStrengthState.isEmpty) {
      return const SizedBox.shrink();
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: List.generate(4, (index) {
            final segmentStart = index / 4.0;
            final fill = ((passwordStrengthState.strength - segmentStart) * 4)
                .clamp(0.0, 1.0);

            return Expanded(
              child: Container(
                height: 8,
                margin: const EdgeInsets.symmetric(horizontal: 2),
                decoration: BoxDecoration(
                  color: Colors.grey.shade300,
                  borderRadius: BorderRadius.circular(4),
                ),
                child: LayoutBuilder(
                  builder: (context, constraints) {
                    return Stack(
                      children: [
                        AnimatedContainer(
                          duration: const Duration(milliseconds: 300),
                          curve: Curves.easeOut,
                          width: constraints.maxWidth * fill,
                          height: constraints.maxHeight,
                          decoration: BoxDecoration(
                            color: passwordStrengthState.strengthColor,
                            borderRadius: BorderRadius.circular(4),
                          ),
                        ),
                      ],
                    );
                  },
                ),
              ),
            );
          }),
        ),

        const SizedBox(height: 6),
      ],
    );
  }
}

///=============  REGISTER VALIDATORS ================
class RegisterValidators {
  static String? validateName(String? value) {
    return null;
  }

  static String? validateUsername(String? value) {
    return null;
  }

  static String? validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return null;
    }

    final emailRegex = RegExp(r'^[^@]+@[^@]+\.[^@]+');

    if (!emailRegex.hasMatch(value)) {
      return 'Invalid email format';
    }

    if (!value.endsWith('.com')) {
      return 'Email must end with .com';
    }

    return null;
  }

  static String? validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return null;
    }

    if (value.length < 8) {
      return 'Minimum 8 characters required';
    }

    if (!RegExp(r'[A-Z]').hasMatch(value)) {
      return 'Add at least 1 capital letter';
    }

    if (!RegExp(r'[0-9]').hasMatch(value)) {
      return 'Add at least 1 number';
    }

    if (!RegExp(r'[!@#\$%^&*(),.?":{}|<>]').hasMatch(value)) {
      return 'Add at least 1 special character';
    }

    return null;
  }

  static String? validateConfirmPassword(String? value, String password) {
    if (value == null || value.isEmpty) {
      return null;
    }

    if (value != password) {
      return 'Passwords do not match';
    }

    return null;
  }
}
