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
    apiKey: 'AIzaSyBqw5SQwZmn2WXZdArWkykclPRxKoSNsWM',
    appId: '1:544176544830:web:98676be679bcc6167bc56f',
    messagingSenderId: '544176544830',
    projectId: 'firebase-coding-owen',
    authDomain: 'fir-coding-owen.firebaseapp.com',
    storageBucket: 'firebase-coding-owen.appspot.com',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyDnwHp9a1ud-blff2oc1-K_fP_rvMu31KM',
    appId: '1:544176544830:android:2150732bcece07867bc56f',
    messagingSenderId: '544176544830',
    projectId: 'firebase-coding-owen',
    storageBucket: 'firebase-coding-owen.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyBW_aum-ktyVQi6ue7EFGa4gl_ytTw_Ze0',
    appId: '1:544176544830:ios:eda3bf9721571e2c7bc56f',
    messagingSenderId: '544176544830',
    projectId: 'firebase-coding-owen',
    storageBucket: 'firebase-coding-owen.appspot.com',
    iosBundleId: 'com.example.untitled',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyBW_aum-ktyVQi6ue7EFGa4gl_ytTw_Ze0',
    appId: '1:544176544830:ios:eda3bf9721571e2c7bc56f',
    messagingSenderId: '544176544830',
    projectId: 'firebase-coding-owen',
    storageBucket: 'firebase-coding-owen.appspot.com',
    iosBundleId: 'com.example.untitled',
  );

  static const FirebaseOptions windows = FirebaseOptions(
    apiKey: 'AIzaSyBqw5SQwZmn2WXZdArWkykclPRxKoSNsWM',
    appId: '1:544176544830:web:1dddc346673d6f337bc56f',
    messagingSenderId: '544176544830',
    projectId: 'firebase-coding-owen',
    authDomain: 'fir-coding-owen.firebaseapp.com',
    storageBucket: 'firebase-coding-owen.appspot.com',
  );
}
