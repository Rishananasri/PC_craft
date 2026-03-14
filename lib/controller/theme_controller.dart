import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

class ThemeController extends ChangeNotifier {

  final Box box = Hive.box('settings');
  bool isDark = false;
  ThemeController() {
    loadTheme();
  }

  ThemeMode get themeMode => isDark ? ThemeMode.dark : ThemeMode.light;

  void loadTheme() {
    isDark = box.get('isDark', defaultValue: false);
    notifyListeners();
  }

  void toggleTheme() {
    isDark = !isDark;
    box.put('isDark', isDark);
    notifyListeners();
  }
}