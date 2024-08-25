import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image_network/image_network.dart';
import 'package:notilo/screens/new_item.dart';

import '../widgets/back_button_custom.dart';

class DetailScreen extends StatefulWidget {
  DetailScreen(
      {super.key,
      required this.title,
      required this.note,
      required this.imageUrl,
      this.height,
      this.width,
      required this.documentId});

  String title;
  String note;
  String imageUrl;
  final double? height;
  final double? width;
  final String documentId;

  @override
  State<DetailScreen> createState() => _DetailScreenState();
}

class _DetailScreenState extends State<DetailScreen> {
  void _goToEditScreen() async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => NewItem(
          isEditing: true,
          currentTitle: widget.title,
          currentNote: widget.note,
          height: widget.height,
          width: widget.width,
          currentImageUrl: widget.imageUrl,
          documentId: widget.documentId,
        ),
      ),
    );
    if (result != null) {
      setState(() {
        widget.title = result['title'];
        widget.note = result['note'];
        widget.imageUrl = result['imageUrl'];
      });
    }
  }

  Widget handleImagePlatform(
      String imageUrl, double width, double height, Icon icon, Color color) {
    if (imageUrl.isNotEmpty) {
      return kIsWeb
          ? ImageNetwork(
              key: ValueKey(imageUrl),
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
        leading: const BackButtonCustom(),
        elevation: 0,
        actions: [
          TextButton(
            onPressed: _goToEditScreen,
            child: const Text('Edit'),
          )
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    handleImagePlatform(
                      widget.imageUrl,
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
                      widget.title,
                      style: Theme.of(context).textTheme.headlineMedium,
                    ),
                    const SizedBox(height: 20),
                    Text(
                      widget.note,
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
