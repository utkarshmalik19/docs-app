import 'package:docs_app/repository/auth_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class LoginPage extends ConsumerWidget {
  const LoginPage({super.key});

  void signInWithGoogle(WidgetRef ref) {
    ref.read(authRepositoryProvider).signInWithGoogle();
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      body: Center(
        child: ElevatedButton.icon(
            style: ElevatedButton.styleFrom(
                minimumSize: Size(150, 50), backgroundColor: Colors.white),
            onPressed: () => signInWithGoogle(ref),
            icon: Image.asset(
              'assets/images/google.png',
              height: 50,
            ),
            label: const Text(
              'Sign in with Google',
              style: TextStyle(color: Colors.black),
            )),
      ),
    );
  }
}
