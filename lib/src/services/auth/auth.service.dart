import 'dart:developer';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AuthService {
  final FirebaseAuth _auth;

  AuthService(this._auth) {
    if (bool.parse(dotenv.env['is_offline']!)) {
      _auth
          .useAuthEmulator(
            dotenv.env['firebase_emulator_host']!,
            int.parse(dotenv.env['firebase_auth_port']!),
          )
          .timeout(
            const Duration(seconds: 5),
            onTimeout: () => log('ERROR -> Authentication timeout'),
          );
    }
  }

  Future<void> loginWithEmail(String email, String password) async {
    try {
      await _auth.signInWithEmailAndPassword(
        email: email.trim(),
        password: password.trim(),
      );
    } on FirebaseAuthException catch (e) {
      throw e.message ?? 'An error occurred during login.';
    }
  }

  Future<void> signUpWithEmail(String email, String password) async {
    try {
      await _auth.createUserWithEmailAndPassword(
        email: email.trim(),
        password: password.trim(),
      );
    } on FirebaseAuthException catch (e) {
      throw e.message ?? 'An error occurred during sign-up.';
    }
  }

  Future<void> loginWithGoogle() async {
    try {
      if (kIsWeb) {
        final GoogleAuthProvider googleProvider = GoogleAuthProvider();

        await _auth.signInWithPopup(googleProvider);
      } else {
        final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
        if (googleUser == null) {
          return;
        }

        final GoogleSignInAuthentication googleAuth = await googleUser.authentication;
        final credential = GoogleAuthProvider.credential(
          accessToken: googleAuth.accessToken,
          idToken: googleAuth.idToken,
        );

        await _auth.signInWithCredential(credential);
      }
    } on FirebaseAuthException catch (e) {
      throw e.message ?? 'An error occurred during Google sign-in.';
    } catch (e) {
      log('===> Error signing in: $e');
    }
  }

  Future<void> resetPassword(String email) async {
    try {
      await _auth.sendPasswordResetEmail(email: email.trim());
    } on FirebaseAuthException catch (e) {
      throw e.message ?? 'An error occurred while sending password reset email.';
    }
  }

  Future<void> logout() async => _auth.signOut();

  Future<User?> signInAnonymously() async {
    User? user = _auth.currentUser;

    if (user == null) {
      try {
        final UserCredential userCredential = await _auth.signInAnonymously();
        user = userCredential.user;
      } on FirebaseAuthException catch (e) {
        throw e.message ?? 'An error occurred during anonymous sign-in.';
      } catch (e) {
        log('Error signing in anonymously: $e');
      }
    }

    return user;
  }
}
