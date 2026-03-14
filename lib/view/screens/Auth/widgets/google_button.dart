import 'package:flutter/material.dart';
import 'package:pc_craft/controller/theme_controller.dart';
import 'package:provider/provider.dart';

class GoogleButton extends StatelessWidget {
  const GoogleButton({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = context.watch<ThemeController>();

    return Container(
      height: 50,
      width: double.infinity,
      decoration: BoxDecoration(
        color: theme.isDark
            ? Colors.grey[850]
            : const Color.fromARGB(255, 232, 230, 230),
        borderRadius: BorderRadius.circular(25),
        border: Border.all(
          color: theme.isDark ? Colors.grey[700]! : Colors.grey[300]!,
          width: 1.5,
        ),
      ),
      child: Center(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset("assets/images/GoogleLogo.png", height: 24),
            const SizedBox(width: 10),
            Text(
              "Continue with Google",
              style: TextStyle(
                color: theme.isDark ? Colors.white : Colors.black,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
