import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:pc_craft/view/screens/Auth/register_screen.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    goToRegister(context);

    return Scaffold(
      body: Center(
        child: Lottie.asset('assets/lottie/lighting.lottie.json', height: 150),
      ),
    );
  }

  void goToRegister(BuildContext context) {
    Future.delayed( Duration(seconds: 2), () {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) =>  RegisterScreen()),
      );
    });
  }
}
