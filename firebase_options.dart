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
    apiKey: 'AIzaSyBihHh2YSJ7lPuUktTftQV4ZsCsMCN-zQs',
    appId: '1:925370304023:web:4fac2f083be5aef191be52',
    messagingSenderId: '925370304023',
    projectId: 'authenticationapp-ec375',
    authDomain: 'authenticationapp-ec375.firebaseapp.com',
    storageBucket: 'authenticationapp-ec375.appspot.com',
    measurementId: 'G-PH0REW52LK',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyAKWtKxUj4OxhSX_QEYX-RZLwHb7Tl72_4',
    appId: '1:925370304023:android:95bd25cd2690b0a491be52',
    messagingSenderId: '925370304023',
    projectId: 'authenticationapp-ec375',
    storageBucket: 'authenticationapp-ec375.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyBA10jJGa9eMFWNj1FEDMhwDtvChbU_rzQ',
    appId: '1:925370304023:ios:179f9a86cca08a7591be52',
    messagingSenderId: '925370304023',
    projectId: 'authenticationapp-ec375',
    storageBucket: 'authenticationapp-ec375.appspot.com',
    iosBundleId: 'com.example.kagamchat',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyBA10jJGa9eMFWNj1FEDMhwDtvChbU_rzQ',
    appId: '1:925370304023:ios:179f9a86cca08a7591be52',
    messagingSenderId: '925370304023',
    projectId: 'authenticationapp-ec375',
    storageBucket: 'authenticationapp-ec375.appspot.com',
    iosBundleId: 'com.example.kagamchat',
  );

  static const FirebaseOptions windows = FirebaseOptions(
    apiKey: 'AIzaSyBihHh2YSJ7lPuUktTftQV4ZsCsMCN-zQs',
    appId: '1:925370304023:web:2666249a6126da2691be52',
    messagingSenderId: '925370304023',
    projectId: 'authenticationapp-ec375',
    authDomain: 'authenticationapp-ec375.firebaseapp.com',
    storageBucket: 'authenticationapp-ec375.appspot.com',
    measurementId: 'G-F3QDTZBCPN',
  );

}