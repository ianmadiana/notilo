import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_network/image_network.dart';

import '../screens/detail_screen.dart';

class NotesList extends StatefulWidget {
  const NotesList({
    super.key,
    required this.notesDocs,
    required this.height,
    required this.width,
    required this.userId,
    // required this.imgUrl,
  });

  final List<QueryDocumentSnapshot<Map<String, dynamic>>> notesDocs;
  final double height;
  final double width;
  final String userId;
  // final String imgUrl;

  @override
  State<NotesList> createState() => _NotesListState();
}

class _NotesListState extends State<NotesList> {
  _showImageOnList(String imageUrl) {
    return imageUrl.isNotEmpty
        ? AspectRatio(
            aspectRatio: 16 / 9,
            child: ImageNetwork(
              fitWeb: BoxFitWeb.fill,
              image: imageUrl,
              height: MediaQuery.of(context).size.height,
              width: MediaQuery.of(context).size.width,
              onLoading: const CircularProgressIndicator(
                color: Colors.indigoAccent,
              ),
            ),
          )
        : Container();
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: widget.notesDocs.length,
      itemBuilder: (context, index) {
        final note = widget.notesDocs[index];
        // final createdAt = note['createdAt'].toDate();
        final String imageUrl = note['imageUrl'];
        // String fileName = note['id'];
        void gotToDetailScreen() {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => DetailScreen(
                title: note['title'],
                note: note['note'],
                imageUrl: note['imageUrl'],
                height: widget.height,
                width: widget.width,
                documentId: note.id,
              ),
            ),
          );
        }

        return Dismissible(
          key: UniqueKey(),
          direction: DismissDirection.endToStart,
          onDismissed: (direction) async {
            try {
              // remove document from Firestore
              await FirebaseFirestore.instance
                  .collection('users')
                  .doc(widget.userId)
                  .collection('notes')
                  .doc(note.id)
                  .delete();

              // remove image from firebase storage
              if (imageUrl.isNotEmpty &&
                  (imageUrl.startsWith('gs://') ||
                      imageUrl.startsWith('https://'))) {
                final ref = FirebaseStorage.instance.refFromURL(imageUrl);
                await ref.delete();
              }

              // is mounted
              if (!context.mounted) return;

              // Remove the item locally
              if (widget.notesDocs.length < index) {
                widget.notesDocs.removeAt(index);
              }

              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Note deleted')),
              );
            } catch (e) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Failed to delete ${note['title']}')),
              );
            }
          },
          background: Container(
            color: Colors.red,
            alignment: Alignment.centerRight,
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: const Icon(
              Icons.delete,
              color: Colors.white,
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: InkWell(
              onTap: gotToDetailScreen,
              child: Card(
                child: Container(
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _showImageOnList(imageUrl),
                      Padding(
                        padding: const EdgeInsets.only(
                            top: 10, left: 20, bottom: 10),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(note['title'],
                                style: Theme.of(context).textTheme.titleMedium),
                            const SizedBox(height: 5),
                            Text(
                              note['note'],
                              style: Theme.of(context).textTheme.bodyMedium,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
