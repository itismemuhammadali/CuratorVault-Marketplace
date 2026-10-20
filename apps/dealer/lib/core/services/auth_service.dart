import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  User? get currentUser => _auth.currentUser;

  Stream<User?> get authStateChanges => _auth.authStateChanges();

  Future<UserCredential> signInWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    return await _auth.signInWithEmailAndPassword(
      email: email.trim(),
      password: password,
    );
  }

  Future<UserCredential> signUpDealer({
    required String email,
    required String password,
    String storeName = 'Vintage Antique Store',
    String ownerName = 'Dealer',
    String phone = '',
  }) async {
    final credential = await _auth.createUserWithEmailAndPassword(
      email: email.trim(),
      password: password,
    );

    if (credential.user != null) {
      final uid = credential.user!.uid;
      await _firestore.collection('dealers').doc(uid).set({
        'uid': uid,
        'email': email.trim(),
        'storeName': storeName,
        'ownerName': ownerName,
        'phone': phone,
        'role': 'dealer',
        'isVerified': true,
        'rating': 4.9,
        'salesCount': 0,
        'balance': 0.0,
        'createdAt': FieldValue.serverTimestamp(),
      }, SetOptions(merge: true));

      await credential.user!.updateDisplayName(ownerName);
    }

    return credential;
  }

  Future<void> sendPasswordResetEmail(String email) async {
    await _auth.sendPasswordResetEmail(email: email.trim());
  }

  Future<void> signOut() async {
    await _auth.signOut();
  }
}
