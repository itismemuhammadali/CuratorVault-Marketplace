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
    final credential = await _auth.signInWithEmailAndPassword(
      email: email,
      password: password,
    );

    if (credential.user != null) {
      final adminDoc = await _firestore.collection('admins').doc(credential.user!.uid).get();
      if (!adminDoc.exists) {
        // Fallback check in users collection
        final userDoc = await _firestore.collection('users').doc(credential.user!.uid).get();
        if (!userDoc.exists || userDoc.data()?['role'] != 'admin') {
          await _auth.signOut();
          throw FirebaseAuthException(
            code: 'access-denied',
            message: 'Access denied: User is not authorized as an administrator.',
          );
        }
      }

      // Record lastLoginAt timestamp in Firestore
      await _firestore.collection('admins').doc(credential.user!.uid).set({
        'lastLoginAt': FieldValue.serverTimestamp(),
      }, SetOptions(merge: true));
    }

    return credential;
  }

  Future<UserCredential> signUpAdmin({
    required String email,
    required String password,
    required String name,
    String? phone,
  }) async {
    final credential = await _auth.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );

    if (credential.user != null) {
      await _firestore.collection('admins').doc(credential.user!.uid).set({
        'uid': credential.user!.uid,
        'email': email,
        'name': name,
        'phone': phone ?? '+1 (555) 000-0000',
        'role': 'Super Admin',
        'createdAt': FieldValue.serverTimestamp(),
        'lastLoginAt': FieldValue.serverTimestamp(),
      });
    }

    return credential;
  }

  Future<void> signOut() async {
    await _auth.signOut();
  }
}
