import 'package:flutter/widgets.dart';
import 'package:flutter/foundation.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';

class FirebaseService {
  static Future<void> initialize() async {
    WidgetsFlutterBinding.ensureInitialized();

    if (Firebase.apps.isEmpty) {
      await Firebase.initializeApp(
        options: const FirebaseOptions(
          apiKey: "demo-key",
          appId: "demo-admin-app-id",
          messagingSenderId: "1234567890",
          projectId: "demo-vintage-vinne",
          storageBucket: "demo-vintage-vinne.appspot.com",
        ),
      );
    }

    if (kDebugMode) {
      try {
        FirebaseFirestore.instance.useFirestoreEmulator('127.0.0.1', 8080);
        await FirebaseAuth.instance.useAuthEmulator('127.0.0.1', 9099);
        await FirebaseStorage.instance.useStorageEmulator('127.0.0.1', 9199);
      } catch (e) {
        debugPrint("Firebase Emulators connection info: $e");
      }
    }
  }
}
