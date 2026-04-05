import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:pc_craft/presentation/providers/providers.dart';
import 'package:pc_craft/presentation/screens/home_screen.dart';

class GoogleButton extends ConsumerWidget {
  const GoogleButton({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeMode = ref.watch(themeProvider);
    final isDark = themeMode == ThemeMode.dark;

    return GestureDetector(
      onTap: () => _signInWithGoogle(context, ref),
      child: Container(
        height: 50,
        width: double.infinity,
        decoration: BoxDecoration(
          color: isDark
              ? Colors.grey[850]
              : const Color.fromARGB(255, 232, 230, 230),
          borderRadius: BorderRadius.circular(25),
          border: Border.all(
            color: isDark ? Colors.grey[700]! : Colors.grey[300]!,
            width: 1.5,
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset("assets/images/GoogleLogo.png", height: 24),
            const SizedBox(width: 10),
            Text(
              "Continue with Google",
              style: TextStyle(
                color: isDark ? Colors.white : Colors.black,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _signInWithGoogle(BuildContext context, WidgetRef ref) async {
    final scaffold = ScaffoldMessenger.of(context);
    final authNotifier = ref.read(authProvider.notifier);

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => const Center(child: CircularProgressIndicator()),
    );

    try {
      final GoogleSignIn googleSignIn = GoogleSignIn(
        scopes: ['email'],
        serverClientId:
            "1025867670578-k8r9qap12tgt1senkrnjqo9b65sui70k.apps.googleusercontent.com",
      );

      await googleSignIn.signOut();

      final GoogleSignInAccount? account = await googleSignIn.signIn();

      if (account == null) {
        navigatorPop(context);
        scaffold.showSnackBar(
          const SnackBar(
            content: Text('Google sign-in cancelled'),
            backgroundColor: Colors.red,
          ),
        );
        return;
      }

      final GoogleSignInAuthentication auth = await account.authentication;
      final String? accessToken = auth.accessToken;

      if (accessToken == null) {
        navigatorPop(context);
        scaffold.showSnackBar(
          const SnackBar(
            content: Text('Failed to obtain Google access token'),
            backgroundColor: Colors.red,
          ),
        );
        return;
      }

      final result = await authNotifier.googleAuth(accessToken: accessToken);

      navigatorPop(context);

      if (result['success'] == true) {
        scaffold.showSnackBar(
          SnackBar(
            content: Text(result['message']),
            backgroundColor: Colors.green,
          ),
        );

        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => const HomeScreen()),
        );
      } else {
        scaffold.showSnackBar(
          SnackBar(
            content: Text(result['message'] ?? 'Google login failed'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } catch (e) {
      navigatorPop(context);
      scaffold.showSnackBar(
        SnackBar(
          content: Text("Google login error: $e"),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  void navigatorPop(BuildContext context) {
    if (Navigator.of(context).canPop()) {
      Navigator.of(context).pop();
    }
  }
}
