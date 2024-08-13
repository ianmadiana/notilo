import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:notilo/config/app_config.dart';
import 'package:notilo/screens/detail_screen.dart';
import 'package:notilo/screens/login_screen.dart';

import 'new_item.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    String? displayName = _auth.currentUser?.displayName;
    User? user = FirebaseAuth.instance.currentUser;
    String userId = user!.uid;
    return Scaffold(
      appBar: AppBar(
        title: Text(AppConfig.shared.appName),
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
      body: StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection('users')
            .doc(userId)
            .collection('notes')
            .orderBy('createdAt', descending: true)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Center(
              child: Text('Notes empty!'),
            );
          }
          final notesDocs = snapshot.data!.docs;

          return ListView.builder(
            itemCount: notesDocs.length,
            itemBuilder: (context, index) {
              final note = notesDocs[index];
              DateTime dateTime = note['createdAt'].toDate();

              void gotToDetailScreen() {
                Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => DetailScreen(
                    title: note['title'],
                    txt: note['txt'],
                  ),
                ));
              }

              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: InkWell(
                  child: ListTile(
                    title: Text(note['title']),
                    subtitle: Text(note['txt']),
                    trailing: Text(dateTime.toString()),
                    onTap: gotToDetailScreen,
                  ),
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => Navigator.push(
            context, MaterialPageRoute(builder: (context) => const NewItem())),
        child: const Icon(Icons.add),
      ),
    );
  }
}
