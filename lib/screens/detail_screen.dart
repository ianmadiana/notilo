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

  Widget handleImagePlatform(
      String imageUrl, double width, double height, Icon icon, Color color) {
    if (imageUrl.isNotEmpty) {
      return kIsWeb
          ? ImageNetwork(
              fitWeb: BoxFitWeb.contain,
              image: imageUrl,
              height: height,
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
              height: height,
              width: width,
            );
    }
    return const SizedBox();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Detail catatan'),
        actions: [TextButton(onPressed: () {}, child: const Text('Edit'))],
      ),
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          children: [
            // Expanded area for scrollable content
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    handleImagePlatform(
                      imageUrl,
                      MediaQuery.of(context)
                          .size
                          .width, // Full width of the screen
                      MediaQuery.of(context).size.height *
                          0.4, // 40% of the screen height
                      const Icon(Icons.error),
                      Colors.red,
                    ),
                    const SizedBox(height: 20),
                    Text(
                      title,
                      style: Theme.of(context).textTheme.headlineMedium,
                    ),
                    const SizedBox(height: 20),
                    Text(
                      txt,
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                  ],
                ),
              ),
            ),
            // Fixed bottom column, centered
            const SizedBox(height: 20),
            Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    DateTime.now().toString(),
                    style: Theme.of(context).textTheme.bodySmall,
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
