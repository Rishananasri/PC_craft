import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pc_craft/presentation/providers/providers.dart';
import 'package:pc_craft/presentation/screens/home_screen.dart';
import 'package:pc_craft/presentation/screens/landing_page.dart';

class AuthGate extends ConsumerWidget {
  const AuthGate({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authProvider);

    if (authState.isLoading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    if (!authState.isLoggedIn) {
      return const LandingScreen();
    }

    return const HomeScreen();
  }
}
