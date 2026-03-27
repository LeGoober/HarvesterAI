import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, kIsWeb, TargetPlatform;

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
    apiKey: 'AIzaSyAiMk-ZQXd4WistpC90GaeRllM_T8-EHOk',
    appId: '1:496799233166:web:4d6f17cca3e6c5d29505df',
    messagingSenderId: '496799233166',
    projectId: 'mimi-53a26',
    authDomain: 'mimi-53a26.firebaseapp.com',
    storageBucket: 'mimi-53a26.firebasestorage.app',
    measurementId: 'G-5GXB6T54VQ',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyBKBflMJDVCCOVV5gVpVGzx8QQQrF5BDrM',
    appId: '1:496799233166:android:5c9a2b1e8f3d6e7f9a0b',
    messagingSenderId: '496799233166',
    projectId: 'mimi-53a26',
    storageBucket: 'mimi-53a26.firebasestorage.app',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyCqVL0QV6fPP5i2QQ5qF0Q5Q5Q5Q5Q5Q5Q',
    appId: '1:496799233166:ios:5c9a2b1e8f3d6e7f9a0b',
    messagingSenderId: '496799233166',
    projectId: 'mimi-53a26',
    storageBucket: 'mimi-53a26.firebasestorage.app',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyCqVL0QV6fPP5i2QQ5qF0Q5Q5Q5Q5Q5Q5Q',
    appId: '1:496799233166:macos:5c9a2b1e8f3d6e7f9a0b',
    messagingSenderId: '496799233166',
    projectId: 'mimi-53a26',
    storageBucket: 'mimi-53a26.firebasestorage.app',
  );

  static const FirebaseOptions windows = FirebaseOptions(
    apiKey: 'AIzaSyAiMk-ZQXd4WistpC90GaeRllM_T8-EHOk',
    appId: '1:496799233166:web:4d6f17cca3e6c5d29505df',
    messagingSenderId: '496799233166',
    projectId: 'mimi-53a26',
    storageBucket: 'mimi-53a26.firebasestorage.app',
  );
}
