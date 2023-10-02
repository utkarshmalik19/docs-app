import 'package:flutter/material.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: ElevatedButton.icon(
            style: ElevatedButton.styleFrom(minimumSize: Size(150, 50), backgroundColor: Colors.white),
            onPressed: () {},
            icon: Image.asset(
              'assets/images/google.png',
              height: 50,
            ),
            label: const Text('Sign in with Google',style: TextStyle(color: Colors.black),)),
      ),
    );
  }
}
