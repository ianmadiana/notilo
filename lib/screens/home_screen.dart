import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:notilo/screens/login_screen.dart';

import 'new_item.dart';

class HomeScreen extends StatelessWidget {
  HomeScreen({super.key});

  final FirebaseAuth _auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    String? displayName = _auth.currentUser?.displayName;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Notilo'),
        actions: [
          Text('$displayName'),
          const SizedBox(width: 10),
          IconButton(
            onPressed: () {
              _auth.signOut();
              Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const LoginScreen(),
                  ));
            },
            icon: const Icon(Icons.logout_rounded),
          ),
        ],
      ),
      body: const Center(
        child: Column(
          children: [Text('No items here, click + to create new one!')],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => Navigator.push(
            context, MaterialPageRoute(builder: (context) => const NewItem())),
        child: const Icon(Icons.add),
      ),
    );
  }
}
