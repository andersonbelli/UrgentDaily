import 'dart:developer';

import 'package:firebase_auth/firebase_auth.dart';

class AuthService {
  final FirebaseAuth _auth;

  AuthService(this._auth);

  Future<void> signInUser() async {
    if (_auth.currentUser == null) {
      // TODO: Implement sign-in with providers
      _signInAnonymously();
    }
  }

  Future<User?> _signInAnonymously() async {
    User? user;

    if (_auth.currentUser == null) {
      try {
        final UserCredential userCredential = await _auth.signInAnonymously();
        user = userCredential.user;
      } catch (e) {
        log('Error signing in anonymously: $e');
      }
    }

    return user;
  }

// TODO: Add other methods like signInWithGoogle, signOut, etc.
}
