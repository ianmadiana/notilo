import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  // Variabel untuk menentukan apakah password sedang ditampilkan atau tidak
  bool _obscureText = true;

  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  TextEditingController emailController = TextEditingController();
  TextEditingController passController = TextEditingController();
  TextEditingController firstnameController = TextEditingController();
  TextEditingController lastnameController = TextEditingController();

  String _email = "";
  String _password = "";
  String _firstName = "";
  String _lastName = "";

  // Fungsi untuk memperlihatkan atau menyembunyikan password
  void _toggleObscureText() {
    setState(() {
      _obscureText = !_obscureText;
    });
  }

  void _signUp() async {
    try {
      UserCredential userCredential = await _auth
          .createUserWithEmailAndPassword(email: _email, password: _password);
      User? user = userCredential.user;
      print("Nama user $user");
      user?.updateDisplayName(_firstName + _lastName);
      print("Nama user $user");
      print("Registred user: ${userCredential.user}");
    } catch (e) {
      print("Error: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          centerTitle: true,
          // widget text untuk menampilkan teks
          title: const Text(
            "Notilo",
            style: TextStyle(color: Colors.black),
          ),
          elevation: 0,
          backgroundColor: Colors.white,
        ),
        // widget listview agar halaman bisa di-scroll
        body: ListView(
          children: [
            // widget kolom untuk membungkus gambar dan input text email dan password
            Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Center(
                  // widget gambar
                  child: SizedBox(
                    height: 200,
                    child: Icon(Icons.abc_outlined),
                  ),
                ),
                // widget container untuk membungkus widget text "Login"
                Container(
                  padding: const EdgeInsets.all(20),
                  child: const Text(
                    "Register",
                    style: TextStyle(fontFamily: 'ConcertOne', fontSize: 30),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(20),
                  // widget textfield untuk memasukkan input email
                  child: Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            // First Name
                            Expanded(
                              child: TextFormField(
                                controller: firstnameController,
                                keyboardType: TextInputType.name,
                                decoration: const InputDecoration(
                                  contentPadding:
                                      EdgeInsetsDirectional.symmetric(
                                          horizontal: 10),
                                  prefixIcon:
                                      Icon(Icons.alternate_email_rounded),
                                  labelText: "First Name",
                                  hintText: "Enter your first name",
                                ),
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return "Please enter your first name";
                                  }
                                  return null;
                                },
                                onChanged: (value) => setState(
                                  () {
                                    _firstName = value;
                                  },
                                ),
                              ),
                            ),
                            // Last Name
                            Expanded(
                              child: TextFormField(
                                controller: lastnameController,
                                keyboardType: TextInputType.name,
                                decoration: const InputDecoration(
                                  contentPadding:
                                      EdgeInsetsDirectional.symmetric(
                                          horizontal: 10),
                                  prefixIcon:
                                      Icon(Icons.alternate_email_rounded),
                                  labelText: "First Name",
                                  hintText: "Enter your last name",
                                ),
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return "Please enter your last name";
                                  }
                                  return null;
                                },
                                onChanged: (value) => setState(
                                  () {
                                    _lastName = value;
                                  },
                                ),
                              ),
                            ),
                          ],
                        ),
                        // EMAIL
                        TextFormField(
                          controller: emailController,
                          keyboardType: TextInputType.emailAddress,
                          decoration: const InputDecoration(
                            contentPadding:
                                EdgeInsetsDirectional.symmetric(horizontal: 10),
                            prefixIcon: Icon(Icons.alternate_email_rounded),
                            labelText: "Email",
                            hintText: "Email ID",
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return "Please enter your email";
                            }
                            return null;
                          },
                          onChanged: (value) => setState(
                            () {
                              _email = value;
                            },
                          ),
                        ),
                        // PASSWORD
                        TextFormField(
                          controller: passController,
                          keyboardType: TextInputType.emailAddress,
                          decoration: InputDecoration(
                            contentPadding:
                                const EdgeInsetsDirectional.symmetric(
                                    horizontal: 10),
                            prefixIcon: const Icon(Icons.lock),
                            labelText: "Password",
                            hintText: "password",
                            suffixIcon: IconButton(
                              icon: Icon(
                                _obscureText
                                    ? Icons.visibility
                                    : Icons.visibility_off,
                              ),
                              onPressed: _toggleObscureText,
                            ),
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return "Please enter your password";
                            }
                            return null;
                          },
                          onChanged: (value) => setState(
                            () {
                              _password = value;
                            },
                          ),
                        ),
                        const SizedBox(height: 20),
                        ElevatedButton(
                          onPressed: () {
                            if (_formKey.currentState!.validate()) {
                              _signUp();
                            }
                          },
                          child: Text(
                            "Sign Up",
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.blue[800],
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
