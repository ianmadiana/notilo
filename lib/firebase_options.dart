// File generated by FlutterFire CLI.
// ignore_for_file: type=lint
import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, kIsWeb, TargetPlatform;

/// Default [FirebaseOptions] for use with your Firebase apps.
///
/// Example:
/// ```dart
/// import 'firebase_options.dart';
/// // ...
/// await Firebase.initializeApp(
///   options: DefaultFirebaseOptions.currentPlatform,
/// );
/// ```
class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform {
    if (kIsWeb) {
      return web;
    }
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return android;
      case TargetPlatform.iOS:
        return ios;
      case TargetPlatform.macOS:
        return macos;
      case TargetPlatform.windows:
        return windows;
      case TargetPlatform.linux:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for linux - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
      default:
        throw UnsupportedError(
          'DefaultFirebaseOptions are not supported for this platform.',
        );
    }
  }

  static const FirebaseOptions web = FirebaseOptions(
    apiKey: 'AIzaSyBeaWaO3Z2pF3oQJdb6BG3z0DVia0uY0NE',
    appId: '1:858725286121:web:10ea81b06f5ba120637078',
    messagingSenderId: '858725286121',
    projectId: 'notilo',
    authDomain: 'notilo.firebaseapp.com',
    storageBucket: 'notilo.appspot.com',
    measurementId: 'G-HPQ46VZFLF',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyBzKgibo7QQfND2jxrKst-mO3uWyPp-gf0',
    appId: '1:858725286121:android:dda5fe69d9af7eef637078',
    messagingSenderId: '858725286121',
    projectId: 'notilo',
    storageBucket: 'notilo.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyC7sl_JJZ7_HMN7audZeaGzwpR9kA9ixqs',
    appId: '1:858725286121:ios:8889a16fbda96590637078',
    messagingSenderId: '858725286121',
    projectId: 'notilo',
    storageBucket: 'notilo.appspot.com',
    iosBundleId: 'com.example.notilo',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyC7sl_JJZ7_HMN7audZeaGzwpR9kA9ixqs',
    appId: '1:858725286121:ios:8889a16fbda96590637078',
    messagingSenderId: '858725286121',
    projectId: 'notilo',
    storageBucket: 'notilo.appspot.com',
    iosBundleId: 'com.example.notilo',
  );

  static const FirebaseOptions windows = FirebaseOptions(
    apiKey: 'AIzaSyBeaWaO3Z2pF3oQJdb6BG3z0DVia0uY0NE',
    appId: '1:858725286121:web:b9b4fe65fd846072637078',
    messagingSenderId: '858725286121',
    projectId: 'notilo',
    authDomain: 'notilo.firebaseapp.com',
    storageBucket: 'notilo.appspot.com',
    measurementId: 'G-HXEHB36XME',
  );
}