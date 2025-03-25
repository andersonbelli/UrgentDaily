// ignore_for_file: constant_identifier_names

import '../../../localization/localization.dart';
import 'error_fields.dart';

enum SignInErrorFieldsEnum implements ErrorFields {
  EMAIL_CANT_BE_EMPTY,
  PASSWORD_CANT_BE_EMPTY,
  INCORRECT_EMAIL_OR_PASSWORD,
  INTERNAL_SERVER_ERROR;

  @override
  String get message {
    switch (this) {
      case EMAIL_CANT_BE_EMPTY:
        return t.emailCantBeEmpty;
      case PASSWORD_CANT_BE_EMPTY:
        return t.passwordCantBeEmpty;
      case INCORRECT_EMAIL_OR_PASSWORD:
        return t.incorrectEmailOrPassword;
      case INTERNAL_SERVER_ERROR:
        return t.internalServerError;
    }
  }
}
