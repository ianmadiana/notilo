import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:notilo/config/app_config.dart';
import 'firebase_options.dart';

import 'screens/login_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  AppConfig.create(
    appName: "Notilo Dev",
    flavor: Flavor.dev,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: true,
      theme: ThemeData.light().copyWith(
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color.fromARGB(255, 123, 2, 163),
          brightness: Brightness.light,
          // surface: Color.fromARGB(255, 0, 136, 255),
        ),
      ),
      home: const LoginScreen(),
    );
  }
}
