import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image_network/image_network.dart';

class DetailScreen extends StatelessWidget {
  const DetailScreen(
      {super.key,
      required this.title,
      required this.txt,
      required this.imageUrl});

  final String title;
  final String txt;
  final String imageUrl;

  _handleImagePlatform() {
    if (imageUrl.isNotEmpty) {
      if (kIsWeb) {
        return ImageNetwork(
          image: imageUrl,
          height: 200,
          width: 200,
          onLoading: const CircularProgressIndicator(
            color: Colors.indigoAccent,
          ),
          onError: const Icon(
            Icons.error,
            color: Colors.red,
          ),
        );
      } else if (Platform.isAndroid) {
        return Image.network(imageUrl);
      } else {
        return const Text('Image display not supported on this platform');
      }
    }
    return const SizedBox();
  }

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
                _handleImagePlatform(),
                const SizedBox(height: 20),
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
