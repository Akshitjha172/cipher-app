// File generated by FlutterFire CLI.
// ignore_for_file: type=lint
import 'package:expense_tracker/main.dart';
import 'package:firebase_core/firebase_core.dart'
    show Firebase, FirebaseOptions;
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, kIsWeb, TargetPlatform;
import 'package:flutter/material.dart';

/// Default [FirebaseOptions] for use with your Firebase apps.
///
/// Example:
/// ```dart
import 'firebase_options.dart';

/// // ...
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(CipherXApp());
}

//  await Firebase.initializeApp(
//    options: DefaultFirebaseOptions.currentPlatform,
//  );
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
    apiKey: 'AIzaSyDFki-xyjHniMN79FMuJ9u3k4ZZreWncGI',
    appId: '1:123945076529:web:d38cd65c18b760d0a65210',
    messagingSenderId: '123945076529',
    projectId: 'expense-tracker-5ee41',
    authDomain: 'expense-tracker-5ee41.firebaseapp.com',
    storageBucket: 'expense-tracker-5ee41.firebasestorage.app',
    measurementId: 'G-1P3S5HGCLW',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyBnjD-Uk6SmG7wlKCBMzZvV7Qmdu761idM',
    appId: '1:123945076529:android:a2b0a3c9cc806a33a65210',
    messagingSenderId: '123945076529',
    projectId: 'expense-tracker-5ee41',
    storageBucket: 'expense-tracker-5ee41.firebasestorage.app',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyD_yZ9GTiuSHemvqyDlU_F5sA8QAjR-OUo',
    appId: '1:123945076529:ios:57446bd4ab6b0045a65210',
    messagingSenderId: '123945076529',
    projectId: 'expense-tracker-5ee41',
    storageBucket: 'expense-tracker-5ee41.firebasestorage.app',
    iosBundleId: 'com.example.cipherx',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyD_yZ9GTiuSHemvqyDlU_F5sA8QAjR-OUo',
    appId: '1:123945076529:ios:57446bd4ab6b0045a65210',
    messagingSenderId: '123945076529',
    projectId: 'expense-tracker-5ee41',
    storageBucket: 'expense-tracker-5ee41.firebasestorage.app',
    iosBundleId: 'com.example.cipherx',
  );

  static const FirebaseOptions windows = FirebaseOptions(
    apiKey: 'AIzaSyDFki-xyjHniMN79FMuJ9u3k4ZZreWncGI',
    appId: '1:123945076529:web:e02ce729ec50d01fa65210',
    messagingSenderId: '123945076529',
    projectId: 'expense-tracker-5ee41',
    authDomain: 'expense-tracker-5ee41.firebaseapp.com',
    storageBucket: 'expense-tracker-5ee41.firebasestorage.app',
    measurementId: 'G-QPVDD248SE',
  );
}
