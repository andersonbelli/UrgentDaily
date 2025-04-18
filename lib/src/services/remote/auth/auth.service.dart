import 'dart:developer';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:google_sign_in/google_sign_in.dart';

import '../../../localization/localization.dart';

class AuthService {
  final FirebaseAuth _auth;

  late User _user;

  User get user => _user;

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
      final UserCredential userCredential = await _auth.signInWithEmailAndPassword(
        email: email.trim(),
        password: password.trim(),
      );

      setUserUid(userCredential.user);
    } on FirebaseAuthException catch (e) {
      throw e.message ?? t.unexpectedErrorSignIn;
    }
  }

  Future<void> signUpWithEmail(String email, String password) async {
    try {
      await _auth.createUserWithEmailAndPassword(
        email: email.trim(),
        password: password.trim(),
      );

      final credential = EmailAuthProvider.credential(email: email.trim(), password: password.trim());

      await FirebaseAuth.instance.currentUser?.linkWithCredential(credential);
    } on FirebaseAuthException catch (e) {
      throw 'e.message ?? t.unexpectedErrorSignUp';
    }
  }

  Future<void> loginWithGoogle() async {
    try {
      if (kIsWeb) {
        final GoogleAuthProvider googleProvider = GoogleAuthProvider();

        await _auth.signInWithPopup(googleProvider);
      } else {
        final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
        if (googleUser == null) return;

        final GoogleSignInAuthentication googleAuth = await googleUser.authentication;
        final credential = GoogleAuthProvider.credential(
          accessToken: googleAuth.accessToken,
          idToken: googleAuth.idToken,
        );

        final User? currentUser = _auth.currentUser;

        if (currentUser != null && currentUser.isAnonymous) {
          // 🔗 Link anonymous user with Google credential
          final userCredential = await currentUser.linkWithCredential(credential);
          setUserUid(userCredential.user);
        } else {
          final userCredential = await _auth.signInWithCredential(credential);
          setUserUid(userCredential.user);
        }
      }
    } on FirebaseAuthException catch (e) {
      if (e.code == 'credential-already-in-use') {
        throw t.googleAccountAlreadyLinked;
      }
      throw e.message ?? t.errorGoogleSignIn;
    } catch (e) {
      log('$runtimeType ===> Error signing in with Google: $e');
      throw t.unexpectedErrorGoogleSignIn;
    }
  }

  Future<void> resetPassword(String email) async {
    try {
      await _auth.sendPasswordResetEmail(email: email.trim());
    } on FirebaseAuthException catch (e) {
      throw e.message ?? t.errorResetPasswordEmail;
    }
  }

  Future<void> logout() async {
    await _auth.signOut();
    setUserUid(null);
  }

  Future<User?> signInAnonymously() async {
    final User? user = _auth.currentUser;

    if (user?.email == null) {
      try {
        final UserCredential userCredential = await _auth.signInAnonymously();
        setUserUid(userCredential.user);
      } on FirebaseAuthException catch (e) {
        throw e.message ?? t.errorAnonymousSignIn;
      } catch (e) {
        log('Error signing in anonymously: $e');
      }
    } else {
      setUserUid(user);
    }

    return user;
  }

  setUserUid(User? currentUser) {
    if (currentUser != null) {
      _user = currentUser;
    } else {
      throw t.pleaseLoginFirst;
    }
  }
}
