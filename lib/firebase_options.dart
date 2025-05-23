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
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for ios - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
      case TargetPlatform.macOS:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for macos - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
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
    apiKey: 'AIzaSyDUQcAmyBeCzGcqlD9To05hsCJuY2yWq9Y',
    appId: '1:954833891310:web:f17dc44e1cb37f42a0e8ff',
    messagingSenderId: '954833891310',
    projectId: 'hmsv3-1e07b',
    authDomain: 'hmsv3-1e07b.firebaseapp.com',
    databaseURL: 'https://hmsv3-1e07b-default-rtdb.europe-west1.firebasedatabase.app',
    storageBucket: 'hmsv3-1e07b.firebasestorage.app',
    measurementId: 'G-5LY3LR9Q8N',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyBqXw8vV66j7GC2Wl1iOlXGOlZFnSmVVZk',
    appId: '1:954833891310:android:dec007088e0dc68da0e8ff',
    messagingSenderId: '954833891310',
    projectId: 'hmsv3-1e07b',
    databaseURL: 'https://hmsv3-1e07b-default-rtdb.europe-west1.firebasedatabase.app',
    storageBucket: 'hmsv3-1e07b.firebasestorage.app',
  );

  static const FirebaseOptions windows = FirebaseOptions(
    apiKey: 'AIzaSyDUQcAmyBeCzGcqlD9To05hsCJuY2yWq9Y',
    appId: '1:954833891310:web:053631ffe85e67bda0e8ff',
    messagingSenderId: '954833891310',
    projectId: 'hmsv3-1e07b',
    authDomain: 'hmsv3-1e07b.firebaseapp.com',
    databaseURL: 'https://hmsv3-1e07b-default-rtdb.europe-west1.firebasedatabase.app',
    storageBucket: 'hmsv3-1e07b.firebasestorage.app',
    measurementId: 'G-6RQEGP1PNY',
  );
}
