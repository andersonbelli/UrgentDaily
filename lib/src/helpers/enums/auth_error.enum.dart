// ignore_for_file: constant_identifier_names

import '../../localization/localization.dart';
import 'error_fields/error_fields.dart';

enum AuthErrorEnum implements ErrorFields {
  UNEXPECTED_ERROR_SIGN_IN,
  UNEXPECTED_ERROR_SIGN_UP,
  UNEXPECTED_ERROR_GOOGLE_SIGNIN,
  ERROR_GOOGLE_SIGNIN,
  GOOGLE_ACCOUNT_ALREADY_LINKED,
  ERROR_RESET_PASSWORD,
  ERROR_ANONYMOUS_SIGNIN,
  USER_NOT_LOGGED;

  @override
  String get message {
    switch (this) {
      case AuthErrorEnum.UNEXPECTED_ERROR_SIGN_IN:
        return t.unexpectedErrorSignIn;
      case AuthErrorEnum.UNEXPECTED_ERROR_SIGN_UP:
        return t.unexpectedErrorSignUp;
      case AuthErrorEnum.UNEXPECTED_ERROR_GOOGLE_SIGNIN:
        return t.unexpectedErrorGoogleSignIn;
      case AuthErrorEnum.ERROR_GOOGLE_SIGNIN:
        return t.errorGoogleSignIn;
      case AuthErrorEnum.GOOGLE_ACCOUNT_ALREADY_LINKED:
        return t.googleAccountAlreadyLinked;
      case AuthErrorEnum.ERROR_RESET_PASSWORD:
        return t.errorResetPasswordEmail;
      case AuthErrorEnum.ERROR_ANONYMOUS_SIGNIN:
        return t.errorAnonymousSignIn;
      case AuthErrorEnum.USER_NOT_LOGGED:
        return t.pleaseLoginFirst;
    }
  }
}
