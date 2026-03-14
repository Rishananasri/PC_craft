import 'package:flutter/material.dart';
import 'package:pc_craft/controller/theme_controller.dart';
import 'package:provider/provider.dart';

class ThemeToggle extends StatelessWidget {
  const ThemeToggle({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<ThemeController>(
      builder: (context, theme, child) {
        return IconButton(
          icon: Icon(
            theme.isDark ? Icons.light_mode : Icons.dark_mode,
            size: 30,
          ),
          onPressed: theme.toggleTheme,
        );
      },
    );
  }
}