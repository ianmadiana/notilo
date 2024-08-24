import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:notilo/models/notes_model.dart';
import 'package:file_picker/file_picker.dart';

class NewItem extends StatefulWidget {
  const NewItem({super.key});

  @override
  State<NewItem> createState() => _NewItemState();
}

class _NewItemState extends State<NewItem> {
  final _formKey = GlobalKey<FormState>();

  String _enteredTitle = '';
  String _enteredNote = '';
  String imageUrl = '';

  final FirebaseStorage _storage = FirebaseStorage.instance;
  final ImagePicker _picker = ImagePicker();
  File? _imageFile;
  // File? _cameraFile;
  Uint8List? _webImageBytes;
  late String _fileName;

  // SIMPAN DATA FORM KE FIREBASE
  Future<void> _saveItem(NotesModel note) async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      try {
        User? user = FirebaseAuth.instance.currentUser;
        String userId = user!.uid;

        if (_imageFile != null || _webImageBytes != null) {
          String fileName =
              '${user.uid}_${DateTime.now().millisecondsSinceEpoch}.png';
          imageUrl = await _uploadImageToFirebase(fileName);
        }

        await FirebaseFirestore.instance
            .collection('users')
            .doc(userId)
            .collection('notes')
            .add({
          'id': Timestamp.now().toString(),
          'title': _enteredTitle,
          'note': _enteredNote,
          'imageUrl': imageUrl,
          'createdAt': DateTime.now(),
        });

        Navigator.of(context).pop(); // Menutup form setelah data disimpan
      } catch (e) {
        print('Error saving to Firestore: $e');
      }
    }
  }

  void _resetItem() {
    _formKey.currentState!.reset();

    setState(() {
      _webImageBytes = null;
      _imageFile = null;
    });
    // _cameraFile = null;
  }

  // HANDLE UPLOAD IMAGE ACCORDING TO PLATFORM
  void _handleFileUpload() async {
    if (kIsWeb) {
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.any,
        allowMultiple: false,
      );
      if (result != null) {
        try {
          setState(() {
            _webImageBytes = result.files.first.bytes;
            _fileName = result.names.toString();
          });
        } catch (e) {
          if (kDebugMode) {
            print("ERROR WEB: $e");
          }
        }
        // print(file);
      }
    } else if (Platform.isAndroid) {
      final pickedImage = await _picker.pickImage(source: ImageSource.gallery);
      // final pickedCamera = await _picker.pickImage(source: ImageSource.camera);
      if (pickedImage != null) {
        try {
          setState(() {
            _imageFile = File(pickedImage.path);
            // _cameraFile = File(pickedCamera!.path);
            if (kDebugMode) {
              print('Gambar: $_imageFile');
              // print('Gambar: $_cameraFile');
            }
          });
        } catch (e) {
          if (kDebugMode) {
            print("ERROR ANDROID: $e");
          }
        }
      }
    } else {
      if (kDebugMode) {
        print("Unsupported platform");
      }
    }
  }

  // SHOW IMAGE PREVIEW
  _imagePreview() {
    if (kIsWeb) {
      return _webImageBytes == null
          ? const SizedBox(child: Text('Image here'))
          : Card(
              child: Column(
                children: [
                  Image.memory(_webImageBytes!),
                  const SizedBox(height: 5),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(_fileName.replaceAll('[', '').replaceAll(']', '')),
                        IconButton(
                            onPressed: () {
                              setState(() {
                                _webImageBytes = null;
                              });
                            },
                            icon: const Icon(
                              Icons.delete,
                              color: Colors.black,
                            ))
                      ],
                    ),
                  )
                ],
              ),
            );

      // Stack(
      //     alignment: AlignmentDirectional.bottomEnd,
      //     children: [
      //       Image.memory(_webImageBytes!),
      //       IconButton(
      //           onPressed: () {
      //             setState(() {
      //               _webImageBytes = null;
      //             });
      //           },
      //           icon: const Icon(
      //             Icons.delete,
      //             color: Colors.black,
      //           ))
      //     ],
      //   );

      // Column(
      //     children: [
      //       Image.memory(_webImageBytes!),
      //       const SizedBox(height: 5),
      //       IconButton(
      //           onPressed: () {
      //             setState(() {
      //               _webImageBytes = null;
      //             });
      //           },
      //           icon: const Icon(Icons.delete))
      //     ],
      //   );
    } else if (Platform.isAndroid) {
      return _imageFile == null || _imageFile!.path.isEmpty
          ? const SizedBox(child: Text('Image here'))
          : Column(
              children: [
                Image.file(_imageFile!),
                const SizedBox(height: 5),
                IconButton(
                    onPressed: () async {
                      await _imageFile!.delete();
                      setState(() {
                        _imageFile = null;
                      });
                    },
                    icon: const Icon(Icons.delete))
              ],
            );
    } else {
      return const SizedBox(
          child: Text('Image display not supported on this platform'));
    }
  }

  // UPLOAD IMAGE TO FIREBASE STORAGE
  Future<String> _uploadImageToFirebase(String fileName) async {
    String downloadURL = '';
    try {
      Reference ref = _storage.ref().child('images/$fileName');
      UploadTask uploadTask;

      if (kIsWeb) {
        uploadTask = ref.putData(_webImageBytes!);
      } else if (Platform.isAndroid) {
        uploadTask = ref.putFile(_imageFile!);
      } else {
        throw Exception("Unsupported platform");
      }

      TaskSnapshot snapshot = await uploadTask;
      downloadURL = await snapshot.ref.getDownloadURL();
    } catch (e) {
      print("Error uploading image: $e");
    }

    return downloadURL;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton.filled(
          icon: const Icon(
            Icons.arrow_back,
            color: Colors.white,
          ),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            autovalidateMode: AutovalidateMode.onUserInteraction,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Add a new note',
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                    IconButton(
                        onPressed: () {
                          _handleFileUpload();
                        },
                        icon: const Icon(Icons.upload_file_rounded)),
                  ],
                ),

                _imagePreview(),

                const SizedBox(height: 20),
                // TITLE
                TextFormField(
                  decoration: InputDecoration(
                    filled: true,
                    hintText: 'Input title here...',
                    labelText: 'Title',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                  validator: (value) {
                    if (
                        // value == null ||
                        //   value.isEmpty ||
                        //   value.trim().length <= 1 ||
                        value!.trim().length > 50) {
                      // return 'Must be between 1 and 50 characters';
                      return 'Must be between 1 and 50 characters';
                    }

                    return null;
                  },
                  // onSaved: (newValue) => _enteredTitle = newValue!,
                  onSaved: (newValue) {
                    _enteredTitle = newValue!;
                  },
                ),
                const SizedBox(height: 20),
                // TEXT
                TextFormField(
                  // maxLength: 50,
                  maxLines: null,
                  decoration: InputDecoration(
                    filled: true,
                    hintText: 'Input notes here...',
                    labelText: 'Body',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                  // validator: (value) {
                  //   if (value == null ||
                  //       value.isEmpty ||
                  //       value.trim().length <= 1 ||
                  //       value.trim().length > 50) {
                  //     // return 'Must be between 1 and 50 characters';
                  //     return 'Must be between 1 and 50 characters';
                  //   }

                  //   return null;
                  // },
                  // onSaved: (newValue) => _enteredNote = newValue!,
                  onSaved: (newValue) {
                    _enteredNote = newValue!;
                    if (kDebugMode) {
                      print(_enteredNote);
                    }
                  },
                ),
                const SizedBox(height: 20),

                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    TextButton(
                      onPressed: _resetItem,
                      child: const Text('Reset'),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        _saveItem(
                          NotesModel(
                            id: DateTime.now().toString(),
                            title: _enteredTitle,
                            note: _enteredTitle,
                            imageUrl: imageUrl,
                            createdAt: DateTime.now(),
                          ),
                        );
                      },
                      child: const Text('Submit'),
                    )
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
