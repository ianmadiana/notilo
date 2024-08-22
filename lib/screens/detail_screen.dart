import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image_network/image_network.dart';

class DetailScreen extends StatelessWidget {
  const DetailScreen(
      {super.key,
      required this.title,
      required this.txt,
      required this.imageUrl,
      required this.height,
      required this.width});

  final String title;
  final String txt;
  final String imageUrl;
  final double height;
  final double width;

  handleImagePlatform(
      String imageUrl, double width, double height, Icon icon, Color color) {
    if (imageUrl.isNotEmpty) {
      return kIsWeb
          ? ImageNetwork(
              fitWeb: BoxFitWeb.contain,
              image: imageUrl,
              height: 200,
              width: width,
              onLoading: const CircularProgressIndicator(
                color: Colors.indigoAccent,
              ),
              onError: const Icon(
                Icons.error,
                color: Colors.red,
              ),
            )
          : Image.network(
              imageUrl,
              fit: BoxFit.contain,
            );
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
                handleImagePlatform(
                  imageUrl,
                  width,
                  height,
                  const Icon(Icons.error),
                  Colors.red,
                ),
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
