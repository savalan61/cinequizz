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
    apiKey: 'AIzaSyCUyOFojvf76Gp3PMl66jVBJzdbKTH1kR4',
    appId: '1:816063847085:web:d619bbdfe0475f857f0424',
    messagingSenderId: '816063847085',
    projectId: 'yandex-clone',
    authDomain: 'yandex-clone.firebaseapp.com',
    storageBucket: 'yandex-clone.firebasestorage.app',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyAL6596RJmBiNzve8BlxhIyoX8wD1Ki1m4',
    appId: '1:816063847085:android:1d5298d56e01ba267f0424',
    messagingSenderId: '816063847085',
    projectId: 'yandex-clone',
    storageBucket: 'yandex-clone.firebasestorage.app',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyCt0Zo7Jwnq08dwsC6E3HF2KiI_kqA5jds',
    appId: '1:816063847085:ios:2ba179608253a2277f0424',
    messagingSenderId: '816063847085',
    projectId: 'yandex-clone',
    storageBucket: 'yandex-clone.firebasestorage.app',
    iosBundleId: 'com.example.cinequizz',
  );
}
