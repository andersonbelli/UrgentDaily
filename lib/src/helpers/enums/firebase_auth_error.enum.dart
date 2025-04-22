import 'package:firebase_auth/firebase_auth.dart';

import '../../localization/localization.dart';

/// Enum to represent FirebaseAuth error codes.
enum FirebaseAuthError {
  invalidEmail,
  userDisabled,
  userNotFound,
  wrongPassword,
  emailAlreadyInUse,
  operationNotAllowed,
  weakPassword,
  invalidCredential,
  accountExistsWithDifferentCredential,
  invalidVerificationCode,
  invalidVerificationId,
  sessionExpired,
  tooManyRequests,
  requiresRecentLogin,
  networkRequestFailed,
  unknown;

  String get message {
    switch (this) {
      case FirebaseAuthError.invalidEmail:
        return t.invalidEmail;
      case FirebaseAuthError.userDisabled:
        return t.userDisabled;
      case FirebaseAuthError.userNotFound:
        return t.userNotFound;
      case FirebaseAuthError.wrongPassword:
        return t.wrongPassword;
      case FirebaseAuthError.emailAlreadyInUse:
        return t.emailAlreadyInUse;
      case FirebaseAuthError.operationNotAllowed:
        return t.operationNotAllowed;
      case FirebaseAuthError.weakPassword:
        return t.weakPassword;
      case FirebaseAuthError.invalidCredential:
        return t.invalidCredential;
      case FirebaseAuthError.accountExistsWithDifferentCredential:
        return t.accountExistsWithDifferentCredential;
      case FirebaseAuthError.invalidVerificationCode:
        return t.invalidVerificationCode;
      case FirebaseAuthError.invalidVerificationId:
        return t.invalidVerificationId;
      case FirebaseAuthError.sessionExpired:
        return t.sessionExpired;
      case FirebaseAuthError.tooManyRequests:
        return t.tooManyRequests;
      case FirebaseAuthError.requiresRecentLogin:
        return t.requiresRecentLogin;
      case FirebaseAuthError.networkRequestFailed:
        return t.networkRequestFailed;
      case FirebaseAuthError.unknown:
        return t.unknownError;
    }
  }

  static FirebaseAuthError fromCode(String code) {
    switch (code) {
      case 'invalid-email':
        return FirebaseAuthError.invalidEmail;
      case 'user-disabled':
        return FirebaseAuthError.userDisabled;
      case 'user-not-found':
        return FirebaseAuthError.userNotFound;
      case 'wrong-password':
        return FirebaseAuthError.wrongPassword;
      case 'email-already-in-use':
        return FirebaseAuthError.emailAlreadyInUse;
      case 'operation-not-allowed':
        return FirebaseAuthError.operationNotAllowed;
      case 'weak-password':
        return FirebaseAuthError.weakPassword;
      case 'invalid-credential':
        return FirebaseAuthError.invalidCredential;
      case 'account-exists-with-different-credential':
        return FirebaseAuthError.accountExistsWithDifferentCredential;
      case 'invalid-verification-code':
        return FirebaseAuthError.invalidVerificationCode;
      case 'invalid-verification-id':
        return FirebaseAuthError.invalidVerificationId;
      case 'session-expired':
        return FirebaseAuthError.sessionExpired;
      case 'too-many-requests':
        return FirebaseAuthError.tooManyRequests;
      case 'requires-recent-login':
        return FirebaseAuthError.requiresRecentLogin;
      case 'network-request-failed':
        return FirebaseAuthError.networkRequestFailed;
      default:
        return FirebaseAuthError.unknown;
    }
  }
}
