import 'dart:developer';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:google_sign_in/google_sign_in.dart';

import '../../localization/localization.dart';
import 'auth.local.service.dart';

class AuthRemoteService {
  final FirebaseAuth _firebaseAuth;
  final AuthLocalService _localAuth;

  AuthRemoteService({
    required FirebaseAuth firebaseAuth,
    required AuthLocalService localAuth,
  })  : _firebaseAuth = firebaseAuth,
        _localAuth = localAuth {
    if (bool.parse(dotenv.env['is_offline']!)) {
      _firebaseAuth
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
    final UserCredential userCredential = await _firebaseAuth.signInWithEmailAndPassword(
      email: email.trim(),
      password: password.trim(),
    );

    await _localAuth.saveUser(userCredential.user);
  }

  Future<void> signUpWithEmail(String email, String password) async {
    try {
      await _firebaseAuth.createUserWithEmailAndPassword(
        email: email.trim(),
        password: password.trim(),
      );

      final credential = EmailAuthProvider.credential(email: email.trim(), password: password.trim());

      await FirebaseAuth.instance.currentUser?.linkWithCredential(credential);
    } on FirebaseAuthException catch (e) {
      throw e.message ?? t.unexpectedErrorSignUp;
    }
  }

  Future<void> loginWithGoogle() async {
    try {
      if (kIsWeb) {
        final GoogleAuthProvider googleProvider = GoogleAuthProvider();

        await _firebaseAuth.signInWithPopup(googleProvider);
      } else {
        final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
        if (googleUser == null) return;

        final GoogleSignInAuthentication googleAuth = await googleUser.authentication;
        final credential = GoogleAuthProvider.credential(
          accessToken: googleAuth.accessToken,
          idToken: googleAuth.idToken,
        );

        final User? currentUser = _firebaseAuth.currentUser;

        if (currentUser != null && currentUser.isAnonymous) {
          // 🔗 Link anonymous user with Google credential
          final userCredential = await currentUser.linkWithCredential(credential);
          _localAuth.saveUser(userCredential.user);
        } else {
          final userCredential = await _firebaseAuth.signInWithCredential(credential);
          _localAuth.saveUser(userCredential.user);
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
      await _firebaseAuth.sendPasswordResetEmail(email: email.trim());
    } on FirebaseAuthException catch (e) {
      throw e.message ?? t.errorResetPasswordEmail;
    }
  }

  Future<void> logout() async {
    await _firebaseAuth.signOut();
    _localAuth.saveUser(null);
  }

  Future<void> signInAnonymously() async {
    final User? user = _firebaseAuth.currentUser;

    if (user?.email == null) {
      try {
        final UserCredential userCredential = await _firebaseAuth.signInAnonymously();
        _localAuth.saveUser(userCredential.user);
      } on FirebaseAuthException catch (e) {
        throw e.message ?? t.errorAnonymousSignIn;
      } catch (e) {
        log('Error signing in anonymously: $e');
      }
    } else {
      _localAuth.saveUser(user);
    }
  }
}
