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
    apiKey: 'AIzaSyAVbiYEIaeYw7lqMaJVNUekyxZYiCy6Ab4',
    appId: '1:957426397478:web:55109c125fb5b0a9bc11e7',
    messagingSenderId: '957426397478',
    projectId: 'app-animus',
    authDomain: 'app-animus.firebaseapp.com',
    storageBucket: 'app-animus.firebasestorage.app',
    measurementId: 'G-L5VK3Q6NW6',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyBuFmnpWK3ehHpQeRNmy-XSE56lwBSje8Q',
    appId: '1:957426397478:android:87e26061d6c5a144bc11e7',
    messagingSenderId: '957426397478',
    projectId: 'app-animus',
    storageBucket: 'app-animus.firebasestorage.app',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyC0kUnTJ62oVEo2e2t9Bgg2ccUbRLZTOd8',
    appId: '1:957426397478:ios:77a9ea2e80fc53ebbc11e7',
    messagingSenderId: '957426397478',
    projectId: 'app-animus',
    storageBucket: 'app-animus.firebasestorage.app',
    iosBundleId: 'com.example.animusSenai',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyC0kUnTJ62oVEo2e2t9Bgg2ccUbRLZTOd8',
    appId: '1:957426397478:ios:77a9ea2e80fc53ebbc11e7',
    messagingSenderId: '957426397478',
    projectId: 'app-animus',
    storageBucket: 'app-animus.firebasestorage.app',
    iosBundleId: 'com.example.animusSenai',
  );

  static const FirebaseOptions windows = FirebaseOptions(
    apiKey: 'AIzaSyAVbiYEIaeYw7lqMaJVNUekyxZYiCy6Ab4',
    appId: '1:957426397478:web:b0ef857ae81c5bfebc11e7',
    messagingSenderId: '957426397478',
    projectId: 'app-animus',
    authDomain: 'app-animus.firebaseapp.com',
    storageBucket: 'app-animus.firebasestorage.app',
    measurementId: 'G-9EPLJX4Y5Q',
  );
}
