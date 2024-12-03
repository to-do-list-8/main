// File generated by FlutterFire CLI.
// ignore_for_file: type=lint
import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, kIsWeb, TargetPlatform;
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart' show TargetPlatform;


// ...

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
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for macos - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
      case TargetPlatform.windows:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for windows - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
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
    apiKey: 'AIzaSyCAl7N5odK7Eoxtn629un8C6RksHctcb5s',
    appId: '1:689474486678:web:0203746bf609b4fb239db7',
    messagingSenderId: '689474486678',
    projectId: 'todolist-fae63',
    authDomain: 'todolist-fae63.firebaseapp.com',
    storageBucket: 'todolist-fae63.firebasestorage.app',
    measurementId: 'G-C6PEY56Y3D',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyDj8tZoO1ffldfUbaxDqFgGEOXdodf_954',
    appId: '1:689474486678:android:5ff8208e827871c0239db7',
    messagingSenderId: '689474486678',
    projectId: 'todolist-fae63',
    storageBucket: 'todolist-fae63.firebasestorage.app',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyDfwIp9vP6RTaJZB3ckrz6hW_ris2_JztE',
    appId: '1:689474486678:ios:53a1ef7620259e93239db7',
    messagingSenderId: '689474486678',
    projectId: 'todolist-fae63',
    storageBucket: 'todolist-fae63.firebasestorage.app',
    iosBundleId: 'com.example.todoTest',
  );
}