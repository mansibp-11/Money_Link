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
    apiKey: 'AIzaSyC6fwWMtu56dvPhzkNvUfqAUAMvF93yZ4A',
    appId: '1:921791994463:web:8fc70d83c1c0e570c299ea',
    messagingSenderId: '921791994463',
    projectId: 'moneylink-4659a',
    authDomain: 'moneylink-4659a.firebaseapp.com',
    storageBucket: 'moneylink-4659a.firebasestorage.app',
    measurementId: 'G-6E3DJRVC6Y',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyDsJiEN3NbMYExuVI7B5_ZzhYnkCZeroH4',
    appId: '1:921791994463:android:29598cbfc93d6fbdc299ea',
    messagingSenderId: '921791994463',
    projectId: 'moneylink-4659a',
    storageBucket: 'moneylink-4659a.firebasestorage.app',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyAhzC4DVyXtJvSY9-v5dObuaI-Vz_bCtXg',
    appId: '1:921791994463:ios:7201eab5a20f03ecc299ea',
    messagingSenderId: '921791994463',
    projectId: 'moneylink-4659a',
    storageBucket: 'moneylink-4659a.firebasestorage.app',
    iosBundleId: 'com.example.moneylink',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyAhzC4DVyXtJvSY9-v5dObuaI-Vz_bCtXg',
    appId: '1:921791994463:ios:7201eab5a20f03ecc299ea',
    messagingSenderId: '921791994463',
    projectId: 'moneylink-4659a',
    storageBucket: 'moneylink-4659a.firebasestorage.app',
    iosBundleId: 'com.example.moneylink',
  );

  static const FirebaseOptions windows = FirebaseOptions(
    apiKey: 'AIzaSyC6fwWMtu56dvPhzkNvUfqAUAMvF93yZ4A',
    appId: '1:921791994463:web:78c4d51fa3cbec23c299ea',
    messagingSenderId: '921791994463',
    projectId: 'moneylink-4659a',
    authDomain: 'moneylink-4659a.firebaseapp.com',
    storageBucket: 'moneylink-4659a.firebasestorage.app',
    measurementId: 'G-PQFKVZ61C6',
  );
}
