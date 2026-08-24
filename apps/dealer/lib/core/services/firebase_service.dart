import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
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
          appId: "demo-dealer-app-id",
          messagingSenderId: "1234567890",
          projectId: "demo-vintage-vinne",
          storageBucket: "demo-vintage-vinne.appspot.com",
        ),
      );
    }

    if (kDebugMode) {
      // 10.0.2.2 is the Android Emulator loopback IP to host machine localhost
      final String host = (!kIsWeb && defaultTargetPlatform == TargetPlatform.android)
          ? '10.0.2.2'
          : '127.0.0.1';

      try {
        FirebaseFirestore.instance.useFirestoreEmulator(host, 8080);
        await FirebaseAuth.instance.useAuthEmulator(host, 9099);
        await FirebaseStorage.instance.useStorageEmulator(host, 9199);
      } catch (e) {
        debugPrint("Firebase Emulators connection info: $e");
      }
    }
  }
}
