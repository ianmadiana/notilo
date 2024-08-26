import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image_network/image_network.dart';
import 'package:image_picker/image_picker.dart';
import 'package:notilo/models/notes_model.dart';
import 'package:file_picker/file_picker.dart';
import 'package:notilo/widgets/back_button_custom.dart';

class NewItem extends StatefulWidget {
  const NewItem({
    super.key,
    this.currentTitle,
    this.currentNote,
    this.currentImageUrl,
    required this.isEditing,
    this.height,
    this.width,
    this.documentId,
  });

  final String? currentTitle;
  final String? currentNote;
  final String? currentImageUrl;
  final bool isEditing;
  final double? height;
  final double? width;
  final String? documentId;

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

  @override
  void initState() {
    if (widget.isEditing && widget.currentImageUrl != null) {
      imageUrl = widget.currentImageUrl!;
      _enteredTitle = widget.currentTitle!;
      _enteredNote = widget.currentNote!;
    }
    super.initState();
  }

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

        if (widget.isEditing) {
          await FirebaseFirestore.instance
              .collection('users')
              .doc(userId)
              .collection('notes')
              .doc(widget.documentId)
              .update({
            'title': _enteredTitle,
            'note': _enteredNote,
            'imageUrl': imageUrl,
            'createdAt': DateTime.now(),
          });
        } else {
          await FirebaseFirestore.instance
              .collection('users')
              .doc(userId)
              .collection('notes')
              .add(
            {
              'id': Timestamp.now().toString(),
              'title': _enteredTitle,
              'note': _enteredNote,
              'imageUrl': imageUrl,
              'createdAt': DateTime.now(),
            },
          );
        }

        Navigator.pop(
          context,
          {
            'title': _enteredTitle,
            'note': _enteredNote,
            'imageUrl': imageUrl,
          },
        );
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

  _buildImageFromUrl(String imageUrl) {
    return Card(
      child: Column(
        children: [
          ImageNetwork(
            fitWeb: BoxFitWeb.scaleDown,
            image: imageUrl,
            height: widget.height!,
            width: widget.width!,
            onLoading: const CircularProgressIndicator(),
            onError: const Icon(
              Icons.error,
              color: Colors.red,
            ),
          ),
          const SizedBox(height: 5),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('Change image'),
                IconButton(
                  onPressed: () {
                    setState(() {
                      _webImageBytes = null;
                    });
                  },
                  icon: const Icon(Icons.delete, color: Colors.black),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  _buildImageFromWeb() {
    return Card(
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
                  icon: const Icon(Icons.delete, color: Colors.black),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  _buildImageFromAndroid() {
    return Column(
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
  }

  // SHOW IMAGE PREVIEW
  _imagePreview() {
    if (kIsWeb) {
      if (_webImageBytes != null) {
        return _buildImageFromWeb();
      } else if (imageUrl.isNotEmpty) {
        return _buildImageFromUrl(imageUrl);
      } else {
        return const SizedBox();
      }
    } else if (Platform.isAndroid) {
      if (_imageFile != null && _imageFile!.path.isNotEmpty) {
        return _buildImageFromAndroid();
      } else if (imageUrl.isNotEmpty) {
        return _buildImageFromUrl(imageUrl);
      } else {
        return const SizedBox();
      }
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
        automaticallyImplyLeading: false,
        leading: const BackButtonCustom(),
        title: const Text('Add a new note'),
        actions: [
          IconButton(
            onPressed: () {
              _handleFileUpload();
            },
            icon: const Icon(Icons.upload_file_rounded),
          ),
        ],
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
                _imagePreview(),

                const SizedBox(height: 20),
                // TITLE
                TextFormField(
                  initialValue: widget.currentTitle,
                  maxLength: 50,
                  decoration: InputDecoration(
                    filled: true,
                    hintText: 'Input title here...',
                    labelText: 'Title',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                  validator: (value) {
                    if (value!.trim().length > 50) {
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
                  initialValue: widget.currentNote,
                  maxLines: null,
                  decoration: InputDecoration(
                    filled: true,
                    hintText: 'Input notes here...',
                    labelText: 'Body',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
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
