import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:notilo/models/notes_model.dart';

class NewItem extends StatefulWidget {
  const NewItem({super.key});

  @override
  State<NewItem> createState() => _NewItemState();
}

class _NewItemState extends State<NewItem> {
  final _formKey = GlobalKey<FormState>();

  var _enteredTitle = '';
  var _enteredTxt = '';
  // var _imgUrl = '';

  Future<void> _saveToFirestore(NotesModel note) async {
    final notesCollection = FirebaseFirestore.instance.collection('notes');
    await notesCollection.doc(note.id).set({'title': note.title, 'txt': note.txt, 'createdAt': Timestamp.now()});
  }



  void _saveItem() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      // Navigator.of(context).pop(
      //   NotesModel(id: DateTime.now().toString(), title: _enteredTitle, txt: _enteredTxt, imageUrl: '', 
      //   )
      // );

      final note = NotesModel(
        id: DateTime.now().toString(),
        title: _enteredTitle,
        txt: _enteredTxt,
        imageUrl: '',
      );
      await _saveToFirestore(note);
      print(note.id);
      print(note.title);
      print(note.txt);
      print(note.imageUrl);

      Navigator.of(context).pop(note);
    }
  }

  


  void _resetItem() {
    _formKey.currentState!.reset();
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
        child: Form(
          key: _formKey,
          autovalidateMode: AutovalidateMode
              .onUserInteraction, // Set autovalidateMode ke onUserInteraction
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
              
              IconButton(onPressed: (){}, icon: const Icon(Icons.upload_file_rounded)),
                ],
              ),

              const SizedBox(height: 20),
              // TITLE
              TextFormField(
                // maxLength: 50,
                decoration: InputDecoration(
                  filled: true,
                  hintText: 'Input title here...',
                  labelText: 'Title',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
                validator: (value) {
                  if (value == null ||
                      value.isEmpty ||
                      value.trim().length <= 1 ||
                      value.trim().length > 50) {
                    // return 'Must be between 1 and 50 characters';
                    return 'Must be between 1 and 50 characters';
                  }

                  return null;
                },
                onSaved: (newValue) => _enteredTitle = newValue!,
              ),
              const SizedBox(height: 20),
              // TEXT
               TextFormField(
                // maxLength: 50,
                decoration: InputDecoration(
                  filled: true,
                  hintText: 'Input notes here...',
                  labelText: 'Body',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
                validator: (value) {
                  if (value == null ||
                      value.isEmpty ||
                      value.trim().length <= 1 ||
                      value.trim().length > 50) {
                    // return 'Must be between 1 and 50 characters';
                    return 'Must be between 1 and 50 characters';
                  }

                  return null;
                },
                onSaved: (newValue) => _enteredTitle = newValue!,
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
                    onPressed: _saveItem,
                    child: const Text('Submit'),
                  )
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}