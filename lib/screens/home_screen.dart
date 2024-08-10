import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:notilo/screens/login_screen.dart';

class HomeScreen extends StatelessWidget {
  HomeScreen({super.key});

  final FirebaseAuth _auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    String? userEmail = _auth.currentUser?.email;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Notilo'),
      ),
      body: Center(
        child: Column(
          children: [
            const Text('Welcome to Notilo!'),
            const SizedBox(height: 20),
            Text('$userEmail'),
            const SizedBox(height: 40),
            ElevatedButton(
                onPressed: () {
                  _auth.signOut();
                  Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const LoginScreen(),
                      ));
                },
                child: const Text('Sign out'))
          ],
        ),
      ),
    );
  }
}
