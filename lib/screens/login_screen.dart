import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:notilo/config/app_config.dart';
import 'package:notilo/main_dev.dart';
import 'package:notilo/screens/home_screen.dart';

import 'register_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool _obscureText = true;

  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  TextEditingController emailController = TextEditingController();
  TextEditingController passController = TextEditingController();

  String _email = "";
  String _password = "";

  void _goToHomeScreen() {
    Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => const HomeScreen(),
        ));
  }

  void _autoLogin() async {
    await _auth.signInWithEmailAndPassword(
        email: 'ianmadiana@gmail.com', password: '28021998');
    _goToHomeScreen();
  }

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
      if (kDebugMode) {
        print("Login user: ${userCredential.user}");
      }
      _goToHomeScreen();
    } catch (e) {
      if (kDebugMode) {
        print("Error: $e");
      }
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
          title: Text(
            AppConfig.shared.appName,
            style: const TextStyle(color: Colors.black),
          ),
          elevation: 0,
          backgroundColor: Colors.white,
        ),
        // widget listview agar halaman bisa di-scroll
        body: ListView(
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  // widget gambar
                  child: SizedBox(
                    height: MediaQuery.of(context).size.height * 0.2,
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
                        const SizedBox(height: 20),
                        // PASSWORD
                        TextFormField(
                          controller: passController,
                          keyboardType: TextInputType.text,
                          obscureText: _obscureText,
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
                        SizedBox(
                          width: MediaQuery.of(context).size.width,
                          child: ElevatedButton(
                            style: ButtonStyle(
                              backgroundColor: WidgetStateProperty.all(
                                  Theme.of(context).primaryColor),
                            ),
                            onPressed: () {
                              // if (AppConfig.shared.flavor == Flavor.dev) {
                              //   _autoLogin();
                              // } else if (AppConfig.shared.flavor ==
                              //     Flavor.prod) {
                              //   if (_formKey.currentState!.validate()) {
                              //     _signIn();
                              //   }
                              // }

                              if (AppConfig.shared.flavor == Flavor.dev) {
                                _autoLogin();
                              } else if (AppConfig.shared.flavor ==
                                  Flavor.prod) {
                                if (_formKey.currentState!.validate()) {
                                  _signIn();
                                }
                              }
                            },
                            child: const Text(
                              "Sign In",
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 5),
                        SizedBox(
                          width: MediaQuery.of(context).size.width,
                          child: ElevatedButton(
                            onPressed: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        const RegisterScreen(),
                                  ));
                            },
                            child: Text(
                              "Register",
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Theme.of(context).colorScheme.primary,
                              ),
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
