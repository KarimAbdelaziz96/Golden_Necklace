import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart' show TargetPlatform, defaultTargetPlatform;

class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform {
    if (defaultTargetPlatform == TargetPlatform.android) {
      return _android;
    } else if (defaultTargetPlatform == TargetPlatform.iOS) {
      return _ios;
    } else {
      throw UnsupportedError('Platform not supported');
    }
  }

  static const FirebaseOptions _android = FirebaseOptions(
    apiKey: 'AIzaSyAFGlI9GvVI_anfJvdFwgSiyuXNUuzT9lo',
    appId: '1:1053690911021:android:a1818a6c8f060e140a1ba4',
    messagingSenderId: '1053690911021',
    projectId: 'goldennecklace-7d09e',
    storageBucket: 'goldennecklace-7d09e.appspot.com',
  );

  static const FirebaseOptions _ios = FirebaseOptions(
    apiKey: 'AIzaSyAZdheDnxqlUxKJQUGu50ults_AwINY5vA',
    appId: '1:1053690911021:ios:172b5e13ae52ac290a1ba4',
    messagingSenderId: '1053690911021',
    projectId: 'goldennecklace-7d09e',
    storageBucket: 'goldennecklace-7d09e.appspot.com',
    iosClientId: '1053690911021-drdmsb46v7q66v2v97p0abse5i4msar7.apps.googleusercontent.com',
    iosBundleId: 'com.goldennecklace.goldennecklace',
  );
}
