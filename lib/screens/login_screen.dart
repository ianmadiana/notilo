import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:notilo/screens/home_screen.dart';

import 'register_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  // Variabel untuk menentukan apakah password sedang ditampilkan atau tidak
  bool _obscureText = true;

  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  TextEditingController emailController = TextEditingController();
  TextEditingController passController = TextEditingController();

  String _email = "";
  String _password = "";

  // Fungsi untuk memperlihatkan atau menyembunyikan password
  void _toggleObscureText() {
    setState(() {
      _obscureText = !_obscureText;
    });
  }

  void _signIn() async {
    try {
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
          email: _email, password: _password);
      print("Login user: ${userCredential.user}");
      Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => HomeScreen(),
          ));
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
                    height: 300,
                    child: Icon(Icons.abc_outlined),
                  ),
                ),
                // widget container untuk membungkus widget text "Login"
                Container(
                  padding: const EdgeInsets.all(20),
                  child: const Text(
                    "Login",
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
                              _signIn();
                            }
                          },
                          child: Text(
                            "Sign In",
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.blue[800],
                            ),
                          ),
                        ),
                        SizedBox(height: 20),
                        ElevatedButton(
                          onPressed: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => const RegisterScreen(),
                                ));
                          },
                          child: Text(
                            "Register",
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
