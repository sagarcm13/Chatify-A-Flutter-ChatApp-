// File generated by FlutterFire CLI.
// ignore_for_file: lines_longer_than_80_chars, avoid_classes_with_only_static_members
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
    apiKey: 'AIzaSyB0FUMxBVO8wYkjf1KDWOjuqD9_InR92hs',
    appId: '1:373921849813:web:74f245136e96c11fb05d5c',
    messagingSenderId: '373921849813',
    projectId: 'chatify-1aa8a',
    authDomain: 'chatify-1aa8a.firebaseapp.com',
    databaseURL: 'https://chatify-1aa8a-default-rtdb.firebaseio.com',
    storageBucket: 'chatify-1aa8a.appspot.com',
    measurementId: 'G-4B4584K7VB',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyCBhMIWhJxJzvuQAURXf7amrUX2seQ2Tgg',
    appId: '1:373921849813:android:aa659a04b4ebf28ab05d5c',
    messagingSenderId: '373921849813',
    projectId: 'chatify-1aa8a',
    databaseURL: 'https://chatify-1aa8a-default-rtdb.firebaseio.com',
    storageBucket: 'chatify-1aa8a.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyARo10jWodk_oZH5sPeqlKZjmhjovbRJQU',
    appId: '1:373921849813:ios:93c21ab6b32561f3b05d5c',
    messagingSenderId: '373921849813',
    projectId: 'chatify-1aa8a',
    databaseURL: 'https://chatify-1aa8a-default-rtdb.firebaseio.com',
    storageBucket: 'chatify-1aa8a.appspot.com',
    iosBundleId: 'com.example.chatify',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyARo10jWodk_oZH5sPeqlKZjmhjovbRJQU',
    appId: '1:373921849813:ios:16c630e75e101746b05d5c',
    messagingSenderId: '373921849813',
    projectId: 'chatify-1aa8a',
    databaseURL: 'https://chatify-1aa8a-default-rtdb.firebaseio.com',
    storageBucket: 'chatify-1aa8a.appspot.com',
    iosBundleId: 'com.example.chatify.RunnerTests',
  );
}
