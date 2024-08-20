import 'package:flutter/material.dart';

class DetailScreen extends StatelessWidget {
  const DetailScreen(
      {super.key,
      required this.title,
      required this.txt,
      required this.imageUrl});

  final String title;
  final String txt;
  final String imageUrl;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Detail catatan'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: SingleChildScrollView(
          child: Center(
            child: Column(
              children: [
                Image.network(imageUrl),
                Text(title),
                const SizedBox(height: 20),
                Text(txt),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
