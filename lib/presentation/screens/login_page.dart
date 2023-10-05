import 'package:docs_app/presentation/screens/home_page.dart';
import 'package:docs_app/repository/auth_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class LoginPage extends ConsumerWidget {
  const LoginPage({super.key});

  void signInWithGoogle(WidgetRef ref, BuildContext context) async {
    final sMessanger = ScaffoldMessenger.of(context);
    final navigator = Navigator.of(context);
    final errorModel =
        await ref.read(authRepositoryProvider).signInWithGoogle();
    if (errorModel.error == null) {
      ref.read(userProvider.notifier).update((state) => errorModel.data);
      navigator.push(MaterialPageRoute(builder: (context)=> HomePage()));
    } else {
      sMessanger.showSnackBar(SnackBar(content: Text(errorModel.error!)));
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      body: Center(
        child: ElevatedButton.icon(
            style: ElevatedButton.styleFrom(
                minimumSize: Size(150, 50), backgroundColor: Colors.white),
            onPressed: () => signInWithGoogle(ref, context),
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
