import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class SplashNotifier extends StateNotifier<bool> {
  SplashNotifier() : super(false);

  void startTimer(BuildContext context) {
    Timer(const Duration(seconds: 3), () {
      state = true;
      Navigator.pushReplacementNamed(context, '/register');
    });
  }
}

final splashProvider = StateNotifierProvider<SplashNotifier, bool>((ref) {
  return SplashNotifier();
});
