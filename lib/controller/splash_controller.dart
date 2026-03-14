import 'dart:async';
import 'package:flutter/material.dart';

class SplashController extends ChangeNotifier {

  void startTimer(BuildContext context) {
    Timer( Duration(seconds: 3), () {
      Navigator.pushReplacementNamed(context, '/register');
    });
    
  }

}